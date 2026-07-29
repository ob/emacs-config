;;; Package -- Summary
;;; Commentary:
;;; Code:

(require 'init-elpa)
(require 'recentf)
(require-package 'vertico)
(require-package 'orderless)
(require-package 'marginalia)
(require-package 'projectile)
(require-package 'consult)

(setq recentf-save-file (concat user-emacs-directory ".recentf"))
(recentf-mode 1)
(setq recentf-max-menu-items 40)

;; Vertico: vertical completion UI for every `completing-read'.
(vertico-mode 1)

;; Orderless: space-separated, any-order matching.
(setq completion-styles '(orderless basic)
      completion-category-defaults nil
      completion-category-overrides '((file (styles partial-completion))))

;; Marginalia: rich annotations in the minibuffer.
(marginalia-mode 1)

;; Persist minibuffer history so frequently-used commands sort first.
(savehist-mode 1)

;; Shows a list of buffers
(global-set-key (kbd "C-x C-b") 'ibuffer)

(when (memq window-system '(mac ns x))
  (setq mac-option-modifier 'meta))

(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)
(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)

;; Make my life easier for moving between windows
(defun other-window-previous ()
  "Move to the previous window."
  (interactive)
  (other-window (- 1)))

(global-set-key "\C-x\C-n" 'other-window)
(global-set-key "\C-xn" 'other-window)
(global-set-key "\C-x\C-p" 'other-window-previous)
(global-set-key "\C-xp" 'other-window-previous)
(global-set-key "\C-x\C-o" 'other-window)

;; Some time savers
;;
;; M-x bound to C-x C-m
(global-set-key "\C-x\C-m" 'execute-extended-command)
;; I don't send mail with emacs, and I keep hitting stuff by
;; mistake.
(global-set-key "\C-xm" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

;; scrolling in place is really useful for reading code
(global-set-key
 [S-up] '(lambda (n) "Scroll up in place."
           (interactive "p")
           (let* ((p (point)))
             (progn
               (scroll-down n)
               (goto-char p)))))

(global-set-key
 [S-down] '(lambda (n) "Scroll down in place."
             (interactive "p")
             (let* ((p (point)))
               (progn
                 (scroll-up n)
                 (goto-char p)))))
(global-set-key
 [M-up] '(lambda (n) "Scroll down."
           (interactive "p")
           (scroll-down n)))
(global-set-key
 [M-down] '(lambda (n) "Scroll up."
             (interactive "p")
             (scroll-up n)))

;; make f2 a toggle for selective-display (C-x $)
(defun toggle-selective-display ()
  "Toggle selective display."
  (interactive)
  (set-selective-display (if selective-display nil 1)))
(global-set-key [f2] 'toggle-selective-display)


(projectile-global-mode)

;; Faster indexing on large repos: defer to `git ls-files' / `fd' rather
;; than walking the tree in elisp, and cache the result so repeated
;; lookups in the same project are instant.
(setq projectile-indexing-method 'alien
      projectile-enable-caching  t
      projectile-sort-order      'recently-active
      projectile-completion-system 'default) ; let vertico handle the UI

;; "Do what I mean" find-file: project-wide fuzzy when inside a project,
;; standard find-file otherwise.  Bound to C-x C-f to reclaim the muscle
;; memory.
(defun ob/find-file-dwim ()
  "Fuzzy-find across the current project, falling back to `find-file'."
  (interactive)
  (if (and (fboundp 'projectile-project-p) (projectile-project-p))
      (projectile-find-file)
    (call-interactively #'find-file)))

(global-set-key (kbd "C-x C-f") #'ob/find-file-dwim)
(global-set-key (kbd "C-x f")   #'find-file) ; escape hatch to plain find-file
(global-set-key (kbd "C-x b")   #'consult-buffer)
(global-set-key (kbd "M-s r")   #'consult-ripgrep)
(global-set-key (kbd "M-g g")   #'consult-goto-line)

;; Enable move point from window to window using Shift and the arrow keys
(windmove-default-keybindings)

(provide 'init-navigation)
;;; init-navigation ends here
