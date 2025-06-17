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
;(require 'init-jira)
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
(require 'init-rust)
(require 'init-swift)
;; C++ is special
;; This next section from: https://tuhdo.github.io/c-ide.html
(require-package 'use-package)
(setq use-package-always-ensure t)
(add-to-list 'load-path "~/.emacs.d/c++")
(require 'setup-general)
(if (version< emacs-version "24.4")
    (require 'setup-ivy-counsel)
  (require 'setup-helm)
  (require 'setup-helm-gtags))
;; (require 'setup-ggtags)
(require 'setup-cedet)
(require 'setup-editing)

(use-package undo-tree
  :ensure t
  :init
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo-tree-history/")))
  (setq undo-tree-auto-save-history t)
  :config
  (global-undo-tree-mode 1))

;; Save autosaves to a consistent directory
(setq auto-save-file-name-transforms
      `((".*" "~/.emacs.d/auto-save/" t)))

;; Ensure autosave is on for *all* buffers
(setq auto-save-default t)
(setq auto-save-timeout 20)   ; seconds idle before autosave
(setq auto-save-interval 200) ; keystrokes before autosave

(defun sanitize-buffer-name (name)
  "Return a safe filename based on buffer NAME."
  (replace-regexp-in-string "[^a-zA-Z0-9_-]" "_" name))

;; Auto-save even for new unnamed buffers
(defun force-buffer-auto-save ()
  "Enable autosaving for buffers with no associated file, using a temp file named after the buffer."
  (unless buffer-file-name
    (let* ((safe-name (sanitize-buffer-name (buffer-name)))
           (tmpfile (make-temp-file (concat "emacs-unsaved-" safe-name "-"))))
      (setq buffer-file-name tmpfile)))
  (auto-save-mode 1))

(add-hook 'after-change-major-mode-hook #'force-buffer-auto-save)

;; Save local customizations in a per-machine file
(setq custom-file "~/.emacs-custom.el")
(load custom-file)


(provide 'init)
;;; init.el ends here
