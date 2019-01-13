;;; Package -- init-ui
;;; Commentary:
;;; Code:
(require 'init-elpa)
(require-package 'color-theme-sanityinc-tomorrow)
(require-package 'atom-one-dark-theme)
(require-package 'golden-ratio)

(require 'golden-ratio)

(setq inhibit-startup-message t)
(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

(set-face-attribute 'default nil :height 140)
(setq-default line-spacing 0.2)

(setq
      x-select-enable-clipboard t
      x-select-enable-primary t
      save-interprogram-paste-before-kill t
      apropos-do-all t
      mouse-yank-at-point t)

;;(load-theme 'atom-one-dark t)
(load-theme 'sanityinc-tomorrow-bright t)

(blink-cursor-mode 0)
(setq-default cursor-type 'box)
(set-cursor-color "#cccccc")
(setq ring-bell-function 'ignore)

;; Not sure I like it
;; (golden-ratio-mode 1)

(provide 'init-ui)
;;; init-ui ends here
