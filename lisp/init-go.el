;;; init-go -- Go-mode wired to gopls via eglot
;;; Commentary:
;; Modern Go tooling: eglot (built-in LSP client) talks to gopls (the
;; official Go language server).  Replaces the dead godef/gocode/company-go
;; stack.
;;
;; Prerequisite (one-time):
;;   go install golang.org/x/tools/gopls@latest
;; Then ensure $(go env GOPATH)/bin is on PATH.
;;
;; Keys (provided by eglot/xref):
;;   M-.   — jump to definition
;;   M-,   — jump back
;;   M-?   — find references
;;   C-c C-r — rename symbol (eglot-rename)
;;; Code:

(require 'init-elpa)
(require-package 'go-mode)
(require-package 'eglot)
(require 'go-mode)

;; Don't log JSON-RPC traffic. The events buffer accumulates raw bytes
;; from gopls that can't be re-encoded as UTF-8, which makes session/
;; desktop save prompt for a coding system on quit.
(setq eglot-events-buffer-size 0)
(with-eval-after-load 'eglot
  (when (boundp 'eglot-events-buffer-config)
    (setq eglot-events-buffer-config '(:size 0 :format full))))

;; PATH itself is imported once in init-exec-path; GOPATH is Go-specific.
(when (or (memq window-system '(mac ns)) (daemonp))
  (exec-path-from-shell-copy-env "GOPATH"))

;; Spotlight-launched Emacs doesn't always inherit the shell PATH.
;; Make sure gopls (and other Go binaries) are findable regardless.
(let ((gobin (expand-file-name "~/go/bin")))
  (when (file-directory-p gobin)
    (add-to-list 'exec-path gobin)
    (setenv "PATH" (concat gobin path-separator (getenv "PATH")))))

(add-hook 'go-mode-hook #'eglot-ensure)

(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'gofmt-before-save nil t)
            (unless (and compile-command (string-match-p "go" compile-command))
              (setq-local compile-command "go build -v && go test -v && go vet"))
            (electric-pair-mode 1)))

;; Ask gopls to organize imports on save (the gopls equivalent of goimports).
(defun ob/eglot-organize-imports ()
  "Call gopls' source.organizeImports code action."
  (when (and (bound-and-true-p eglot--managed-mode)
             (derived-mode-p 'go-mode))
    (eglot-code-actions nil nil "source.organizeImports" t)))

(add-hook 'before-save-hook #'ob/eglot-organize-imports)

(provide 'init-go)
;;; init-go ends here
