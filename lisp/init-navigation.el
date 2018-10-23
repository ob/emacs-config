;;; Package -- Summary
;;; Commentary:
;;; Code:

(require 'init-elpa)
(require 'ido)
(require 'recentf)
;;(require-package 'ido-ubiquitous)
(require-package 'smex)
(require-package 'projectile)

(setq recentf-save-file (concat user-emacs-directory ".recentf"))
(recentf-mode 1)
(setq recentf-max-menu-items 40)

(ido-mode t)
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point nil)
(setq ido-auto-merge-work-directories-length -1)
(setq ido-use-virtual-buffers t)

;;(ido-ubiquitous-mode 1)

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


(setq smex-save-file (concat user-emacs-directory ".smex-items"))
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)

(projectile-global-mode)

;; Enable move point from window to window using Shift and the arrow keys
(windmove-default-keybindings)

(provide 'init-navigation)
;;; init-navigation ends here
