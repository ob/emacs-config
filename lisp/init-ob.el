;;; ob -- my custom stuff
;;; Commentary:
;;; Code:

(require 'init-elpa)
(require-package 'ansi-color)
(require-package 'session)
(require-package 'iedit)

(desktop-save-mode 1)

;; Disable tramp (We hates it my preciousss, yes we do)
(setq tramp-mode nil)

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;; customize commint
(defun ob-comint-handler (proc string)
  "PROC: the proc.  STRING: The string."
  (if (string-match "^[ 	]*man \\(.*\\)" string)
      (progn
        (man (match-string 1 string))
        (comint-simple-send proc ""))
    (if (string-match "^[ 	]*bk[ 	]+help[ 	]+\\(.*\\)" string)
        (progn
          (bk-help (match-string 1 string))
          (comint-simple-send proc ""))
      (comint-simple-send proc string))))

;; trap "man" and "bk help" commands in shell mode and run emacs
;; functions instead.
(setq comint-input-sender 'ob-comint-handler)
(add-to-list 'comint-output-filter-functions 'ansi-color-process-output)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(set-face-attribute 'comint-highlight-prompt nil
                    :inherit nil)

(add-hook 'comint-mode-hook (lambda ()
                              (local-set-key
                               "\M-p"
                               'comint-previous-matching-input-from-input)
                              (local-set-key
                               "\M-n"
                               'comint-next-matching-input-from-input)))

(defun colorize-compilation-buffer ()
  "Colorize Compilation Buffer."
  (toggle-read-only)
  (ansi-color-apply-on-region compilation-filter-start (point))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

(add-hook 'after-init-hook 'session-initialize)

(define-key global-map (kbd "C-;") 'iedit-mode)

(setq ediff-split-window-function 'split-window-horizontally)
;; don't start a new frame

(setq ediff-window-setup-function 'ediff-setup-windows-plain)


(provide 'init-ob)
;;; init-ob ends here
