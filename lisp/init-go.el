;;; go -- init-go.el
;;; Commentary:
;;; Code:

(require 'init-elpa)
(require-package 'go-mode)
(require-package 'company)
(require-package 'company-go)

(require 'go-mode)
(require 'company)
(require 'company-go)

;; https://github.com/mdempsky/gocode/tree/master/emacs-company
(setq company-tooltip-limit 20)                      ; bigger popup window
(setq company-idle-delay .3)                         ; decrease delay before autocompletion popup shows
(setq company-echo-delay 0)                          ; remove annoying blinking
(setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "GOPATH"))

(add-hook 'go-mode-hook (lambda ()
                          (set (make-local-variable 'company-backends) '(company-go))
                          (company-mode)))

;; go-def bindings
(add-hook 'go-mode-hook (lambda()
                          (add-hook 'before-save-hook 'gofmt-before-save 'go-remove-unused-imports)
                          (if (not (string-match "go" compile-command))
                              (set (make-local-variable 'compile-command)
                                   "go build -v && go test -v && go vet"))
                          (local-set-key (kbd "M-.") 'godef-jump)
                          (local-set-key (kbd "M-*") 'pop-tag-mark)
                          (electric-pair-mode 1)))

(provide 'init-go)
;;; init-go ends here
