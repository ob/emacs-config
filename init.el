;;; Package -- Summary
;;; Commentary:
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;;; Code:

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'init-elpa)
(require 'init-fonts)
(require 'init-exec-path)
(require 'init-ui)
(require 'init-editing)
(require 'init-navigation)
(require 'init-markdown-mode)
(require 'init-miscellaneous)
(require 'init-company-mode)
(require 'init-git)
(require 'init-ediff)
(require 'init-ob)

;; Fix environment
(require-package 'exec-path-from-shell)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; Languages
(require 'init-groovy)
(require 'init-go)
(require 'init-python)
(require 'init-ruby)
;;(require 'init-rust)
(require 'init-swift)
;; C++ is special
;; This next section from: https://tuhdo.github.io/c-ide.html
(require-package 'use-package)
(setq use-package-always-ensure t)

;; Save autosaves to a consistent directory
(setq auto-save-file-name-transforms
      `((".*" "~/.emacs.d/auto-save/" t)))

;; Ensure autosave is on for *all* buffers
(setq auto-save-default t)
(setq auto-save-timeout 20)   ; seconds idle before autosave
(setq auto-save-interval 200) ; keystrokes before autosave

;; Persist file-less buffers across sessions in a stable location,
;; so a reboot doesn't lose them (macOS wipes /var/folders/.../T/).
(defvar scratch-buffer-dir
  (expand-file-name "scratch-buffers/" user-emacs-directory)
  "Directory where file-less buffers are auto-saved and restored from.")
(make-directory scratch-buffer-dir t)

(defun sanitize-buffer-name (name)
  "Return a safe filename based on buffer NAME."
  (replace-regexp-in-string "[^a-zA-Z0-9_-]" "_" name))

(defun scratch-buffer-skip-p (buf)
  "Return non-nil for transient/system buffers that should not be persisted."
  (let ((n (buffer-name buf)))
    (or (string-prefix-p " " n)
        (string-match-p
         "\\` ?\\*\\(Minibuf\\|Echo\\|Messages\\|Completions\\|Help\\|Warnings\\|Backtrace\\|Compile-Log\\|tramp\\|scratch\\|Async-native-compile-log\\|Customize\\)"
         n)
        (memq (buffer-local-value 'major-mode buf)
              '(dired-mode magit-status-mode magit-log-mode
                magit-diff-mode magit-process-mode
                vterm-mode shell-mode eshell-mode term-mode
                comint-mode special-mode help-mode
                Info-mode messages-buffer-mode)))))

(defun save-scratch-buffers ()
  "Persist every file-less, non-skip buffer's content into `scratch-buffer-dir'.
Replaces whatever was previously persisted, so deleted buffers don't
keep coming back."
  (when (file-directory-p scratch-buffer-dir)
    (dolist (f (directory-files scratch-buffer-dir t "\\`[^.]"))
      (unless (file-directory-p f)
        (ignore-errors (delete-file f)))))
  (dolist (b (buffer-list))
    (with-current-buffer b
      (when (and (not buffer-file-name)
                 (not (scratch-buffer-skip-p b))
                 (> (buffer-size) 0))
        (let ((path (expand-file-name
                     (sanitize-buffer-name (buffer-name))
                     scratch-buffer-dir)))
          (ignore-errors
            (write-region (point-min) (point-max) path nil 'silent)))))))

(add-hook 'kill-emacs-hook #'save-scratch-buffers)

(defun restore-scratch-buffers ()
  "Recreate buffers from files in `scratch-buffer-dir'."
  (when (file-directory-p scratch-buffer-dir)
    (dolist (f (directory-files scratch-buffer-dir t "\\`[^.]"))
      (unless (file-directory-p f)
        (let ((name (file-name-nondirectory f)))
          (with-current-buffer (get-buffer-create name)
            (when (zerop (buffer-size))
              (insert-file-contents f))
            (set-buffer-modified-p nil)))))))

(add-hook 'emacs-startup-hook #'restore-scratch-buffers)

;; Save local customizations in a per-machine file
(setq custom-file "~/.emacs-custom.el")
(load custom-file)


(provide 'init)
;;; init.el ends here
