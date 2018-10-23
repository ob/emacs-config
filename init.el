;;; Package -- Summary
;;; Commentary:
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;;; Code:
(package-initialize)

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
(require 'init-jira)
(require 'init-ob)

;; Languages
(require 'init-elm)
(require 'init-groovy)
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


(provide 'init)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (sanityinc-tomorrow-day)))
 '(custom-safe-themes
   (quote
    ("bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" default)))
 '(package-selected-packages
   (quote
    (helm-jira jira-markup-mode org-jira ox-jira atom-one-light-theme enh-ruby-mode go-add-tags go-autocomplete go-complete go-direx go-dlv go-eldoc go-errcheck go-fill-struct go-gen-test go-gopath go-guru go-impl go-imports go-mode go-playground go-playground-cli go-projectile go-rename go-scratch go-snippets go-stacktracer go-tag jinja2-mode bazel-mode cmake-font-lock cmake-ide cmake-mode cmake-project cpputils-cmake toml-mode better-defaults company-sourcekit yaml-mode markdown-mode markdown-mode+ magit sanityinc-tomorrow-night flycheck-rust racer company projectile smex ido-ubiquitous flycheck rainbow-delimiters golden-ratio atom-one-dark-theme exec-path-from-shell)))
 '(safe-local-variable-values
   (quote
    ((flycheck-clang-language-standard . c++14)
     (eval if
           (assoc "llbuild" c-style-alist)
           (c-set-style "llbuild"))
     (eval unless
           (featurep
            (quote llbuild-project-settings))
           (message "loading 'llbuild-project-settings")
           (add-to-list
            (quote load-path)
            (concat
             (let
                 ((dlff
                   (dir-locals-find-file default-directory)))
               (if
                   (listp dlff)
                   (car dlff)
                 (file-name-directory dlff)))
             "utils/emacs")
            :append)
           (require
            (quote llbuild-project-settings)))
     (eval unless
           (featurep
            (quote swiftpm-project-settings))
           (message "loading 'swiftpm-project-settings")
           (add-to-list
            (quote load-path)
            (concat
             (let
                 ((dlff
                   (dir-locals-find-file default-directory)))
               (if
                   (listp dlff)
                   (car dlff)
                 (file-name-directory dlff)))
             "Utilities/Emacs")
            :append)
           (require
            (quote swiftpm-project-settings)))
     (tab-always-indent . t)
     (swift-basic-offset . 2)
     (swift-syntax-check-fn . swift-project-swift-syntax-check)
     (swift-find-executable-fn . swift-project-executable-find)
     (whitespace-style face lines indentation:space)
     (eval add-hook
           (quote prog-mode-hook)
           (lambda nil
             (whitespace-mode 1))
           (not :APPEND)
           :BUFFER-LOCAL)
     (eval let*
           ((x
             (dir-locals-find-file default-directory))
            (this-directory
             (if
                 (listp x)
                 (car x)
               (file-name-directory x))))
           (unless
               (or
                (featurep
                 (quote swift-project-settings))
                (and
                 (fboundp
                  (quote tramp-tramp-file-p))
                 (tramp-tramp-file-p this-directory)))
             (add-to-list
              (quote load-path)
              (concat this-directory "utils")
              :append)
             (let
                 ((swift-project-directory this-directory))
               (require
                (quote swift-project-settings))))
           (set
            (make-local-variable
             (quote swift-project-directory))
            this-directory)))))
 '(session-use-package t nil (session)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ediff-current-diff-C ((t (:background "midnight blue"))))
 '(ediff-even-diff-A ((t (:background "dim gray"))))
 '(ediff-even-diff-B ((t (:background "dim gray"))))
 '(ediff-even-diff-C ((t (:background "dim gray"))))
 '(ediff-fine-diff-B ((t (:background "dark green"))))
 '(ediff-fine-diff-C ((t (:background "dark slate blue"))))
 '(ediff-odd-diff-A ((t (:background "dim gray"))))
 '(ediff-odd-diff-Ancestor ((t (:background "dim gray"))))
 '(ediff-odd-diff-B ((t (:background "dim gray"))))
 '(ediff-odd-diff-C ((t (:background "dim gray")))))
;;; init.el ends here
