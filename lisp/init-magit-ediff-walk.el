;;; init-magit-ediff-walk.el --- Walk all files in a commit via ediff -*- lexical-binding: t; -*-
;;; Commentary:
;;
;; Provides three entry points, surfaced in magit's `E' transient as `W':
;;   `ob/magit-ediff-commit-walk' — walk every file in a commit.
;;   `ob/magit-ediff-worktree-walk' — walk every working-tree change vs HEAD.
;;   `ob/magit-ediff-walk-dwim' — pick whichever fits the current magit context.
;;
;; In a walk session, four keys are rebound in the ediff control buffer:
;;   `n' — next diff; at end of file, jumps to next file's first diff.
;;   `p' — previous diff; at start of file, jumps to previous file's LAST diff.
;;   SPC — DWIM forward: scroll both side buffers if more of the current diff
;;         is below the fold; otherwise advance (with cross-file flow).
;;   S-SPC — DWIM backward: mirror of SPC. Scroll up if start of diff is above
;;           the fold; otherwise retreat (with cross-file flow).
;;
;; Boundaries: at the end (or start) of the commit, the walk ends with a
;; message. A manual `q' clears walk state cleanly.
;;
;;; Code:

(require 'ediff)
(require 'magit)
(require 'magit-ediff)

(defvar ob/ediff-walk-state nil
  "Plist describing an in-progress commit walk.
Keys: :rev :parent :files :index :direction.")

(defvar ob/ediff-walk--programmatic-quit nil
  "Bound to non-nil while the walker quits a session to advance.
Lets the per-session quit hook distinguish programmatic from manual quits.")

(defun ob/ediff-walk-active-p ()
  "Non-nil when a commit walk is currently in progress."
  (and ob/ediff-walk-state t))

(defun ob/ediff-walk--changed-files (parent rev)
  "Return files changed between PARENT and REV as a list of repo-relative paths."
  (magit-git-lines "diff" "--name-only" parent rev))

;;;###autoload
(defun ob/magit-ediff-commit-walk (rev)
  "Walk every changed file in REV with ediff, flowing `n'/`p' across files."
  (interactive
   (list (or (magit-commit-at-point)
             (magit-read-branch-or-commit "Walk commit"))))
  (let* ((parent (concat rev "^"))
         (files (ob/ediff-walk--changed-files parent rev)))
    (unless files (user-error "No changed files in %s" rev))
    (setq ob/ediff-walk-state
          (list :rev rev :parent parent :files files
                :index 0 :direction 'forward))
    (ob/ediff-walk--start)))

;;;###autoload
(defun ob/magit-ediff-worktree-walk ()
  "Walk every working-tree change vs HEAD with ediff."
  (interactive)
  (let ((files (magit-git-lines "diff" "--name-only" "HEAD")))
    (unless files (user-error "No working-tree changes vs HEAD"))
    (setq ob/ediff-walk-state
          (list :rev nil :parent "HEAD" :files files
                :index 0 :direction 'forward))
    (ob/ediff-walk--start)))

;;;###autoload
(defun ob/magit-ediff-walk-dwim ()
  "Walk the commit at point if there is one, else walk worktree vs HEAD."
  (interactive)
  (if-let ((commit (and (derived-mode-p 'magit-mode)
                        (magit-commit-at-point))))
      (ob/magit-ediff-commit-walk commit)
    (ob/magit-ediff-worktree-walk)))

(defun ob/ediff-walk--start ()
  "Launch ediff for the file at the current walk index."
  (let* ((s ob/ediff-walk-state)
         (rev (plist-get s :rev))
         (parent (plist-get s :parent))
         (files (plist-get s :files))
         (index (plist-get s :index))
         (file (nth index files)))
    (message "Walk %d/%d  %s  (%s..%s)"
             (1+ index) (length files) file parent (or rev "worktree"))
    (magit-ediff-compare parent rev file file)))

(defun ob/ediff-walk--on-startup ()
  "Configure a fresh ediff control buffer when a walk is in progress."
  (when (ob/ediff-walk-active-p)
    (setq-local ob/ediff-walk-control t)
    (local-set-key "n" #'ob/ediff-walk-next)
    (local-set-key "p" #'ob/ediff-walk-previous)
    (local-set-key (kbd "SPC") #'ob/ediff-walk-space)
    (local-set-key (kbd "S-SPC") #'ob/ediff-walk-shift-space)
    (add-hook 'ediff-quit-hook #'ob/ediff-walk--on-quit nil t)
    ;; Auto-select a diff on entry so the user sees content immediately.
    ;; Forward → first diff, backward → last diff. Suppress the
    ;; "Region N in buffer X is empty" chatter for added/deleted files.
    (when (> ediff-number-of-differences 0)
      (let ((inhibit-message t))
        (if (eq (plist-get ob/ediff-walk-state :direction) 'backward)
            (ediff-jump-to-difference ediff-number-of-differences)
          (ediff-jump-to-difference 1))))))

(add-hook 'ediff-startup-hook #'ob/ediff-walk--on-startup)

(defun ob/ediff-walk--on-quit ()
  "Clear walk state when the user quits manually."
  (unless ob/ediff-walk--programmatic-quit
    (setq ob/ediff-walk-state nil)))

(defun ob/ediff-walk-next ()
  "Advance to the next diff, crossing into the next file at end of buffer."
  (interactive)
  (cond
   ((not (bound-and-true-p ob/ediff-walk-control))
    (call-interactively #'ediff-next-difference))
   ((< ediff-current-difference (1- ediff-number-of-differences))
    (ediff-next-difference))
   (t (ob/ediff-walk--advance 1))))

(defun ob/ediff-walk-previous ()
  "Go to the previous diff, crossing into the previous file at start of buffer."
  (interactive)
  (cond
   ((not (bound-and-true-p ob/ediff-walk-control))
    (call-interactively #'ediff-previous-difference))
   ((> ediff-current-difference 0)
    (ediff-previous-difference))
   (t (ob/ediff-walk--advance -1))))

(defun ob/ediff-walk-space ()
  "DWIM SPC: scroll if more of the current diff is below the fold, else advance."
  (interactive)
  (cond
   ((not (bound-and-true-p ob/ediff-walk-control))
    (call-interactively #'ediff-next-difference))
   ;; No diff selected (shouldn't normally happen — startup auto-jumps).
   ((< ediff-current-difference 0)
    (ob/ediff-walk-next))
   ;; End of current diff visible in both side buffers → advance.
   ((ob/ediff-walk--diff-fully-visible-p)
    (ob/ediff-walk-next))
   ;; Otherwise scroll both A and B down by a window-full.
   (t (ob/ediff-walk--scroll-pages))))

(defun ob/ediff-walk--scroll-pages ()
  "Scroll both side buffers (A and B) down by one window-full."
  (dolist (buf (list ediff-buffer-A ediff-buffer-B))
    (when (and buf (buffer-live-p buf))
      (let ((win (get-buffer-window buf t)))
        (when win
          (with-selected-window win
            (condition-case nil
                (scroll-up-command)
              (end-of-buffer (goto-char (point-max))))))))))

(defun ob/ediff-walk-shift-space ()
  "Mirror of SPC: scroll back if the diff start is above the fold, else retreat."
  (interactive)
  (cond
   ((not (bound-and-true-p ob/ediff-walk-control))
    (call-interactively #'ediff-previous-difference))
   ((< ediff-current-difference 0)
    (ob/ediff-walk-previous))
   ;; Start of current diff visible in both side buffers → retreat.
   ((ob/ediff-walk--diff-start-visible-p)
    (ob/ediff-walk-previous))
   ;; Otherwise scroll both A and B up by a window-full.
   (t (ob/ediff-walk--scroll-pages-back))))

(defun ob/ediff-walk--scroll-pages-back ()
  "Scroll both side buffers (A and B) up by one window-full."
  (dolist (buf (list ediff-buffer-A ediff-buffer-B))
    (when (and buf (buffer-live-p buf))
      (let ((win (get-buffer-window buf t)))
        (when win
          (with-selected-window win
            (condition-case nil
                (scroll-down-command)
              (beginning-of-buffer (goto-char (point-min))))))))))

(defun ob/ediff-walk--diff-start-visible-p ()
  "Non-nil when the start of the current diff is visible in BOTH A and B."
  (and (>= ediff-current-difference 0)
       (ob/ediff-walk--side-start-visible-p 'A ediff-buffer-A)
       (ob/ediff-walk--side-start-visible-p 'B ediff-buffer-B)))

(defun ob/ediff-walk--side-start-visible-p (side buffer)
  "Non-nil if start of current diff overlay on SIDE is within BUFFER's window."
  (when (and buffer (buffer-live-p buffer))
    (let ((overlay (ediff-get-diff-overlay ediff-current-difference side))
          (win (get-buffer-window buffer t)))
      (when (and overlay win)
        (>= (overlay-start overlay) (window-start win))))))

(defun ob/ediff-walk--diff-fully-visible-p ()
  "Non-nil when the end of the current diff is visible in BOTH A and B."
  (and (>= ediff-current-difference 0)
       (ob/ediff-walk--side-end-visible-p 'A ediff-buffer-A)
       (ob/ediff-walk--side-end-visible-p 'B ediff-buffer-B)))

(defun ob/ediff-walk--side-end-visible-p (side buffer)
  "Non-nil if end of current diff overlay on SIDE is within BUFFER's window."
  (when (and buffer (buffer-live-p buffer))
    (let ((overlay (ediff-get-diff-overlay ediff-current-difference side))
          (win (get-buffer-window buffer t)))
      (when (and overlay win)
        (<= (overlay-end overlay) (window-end win t))))))

(defun ob/ediff-walk--advance (delta)
  "Quit the current session and start the file DELTA positions away."
  (let* ((s ob/ediff-walk-state)
         (files (plist-get s :files))
         (next (+ (plist-get s :index) delta)))
    (cond
     ((>= next (length files))
      (ob/ediff-walk--finish "End of commit"))
     ((< next 0)
      (ob/ediff-walk--finish "Beginning of commit"))
     (t
      (setq ob/ediff-walk-state
            (plist-put (plist-put s :index next)
                       :direction (if (> delta 0) 'forward 'backward)))
      (let ((ob/ediff-walk--programmatic-quit t))
        (ediff-really-quit nil))
      (ob/ediff-walk--start)))))

(defun ob/ediff-walk--finish (msg)
  "End the walk: quit current session quietly, drop walk state, surface MSG."
  (let ((ob/ediff-walk--programmatic-quit t))
    (ediff-really-quit nil))
  (setq ob/ediff-walk-state nil)
  (message "%s" msg))

;; Surface in magit's E transient as `E W' (capital — `w' is taken by
;; magit-ediff's own "Show worktree").
(with-eval-after-load 'magit-ediff
  (when (fboundp 'transient-append-suffix)
    (unless (ignore-errors (transient-get-suffix 'magit-ediff "W"))
      (ignore-errors
        (transient-append-suffix 'magit-ediff "s"
          '("W" "Walk (commit at point or worktree vs HEAD)"
            ob/magit-ediff-walk-dwim))))))

(provide 'init-magit-ediff-walk)
;;; init-magit-ediff-walk.el ends here
