;;; ob -- my fonts
;;; Commentary:
;;; Code:

;; (set-frame-font
;;  "-*-Hack-normal-normal-normal-*-11-*-*-*-m-0-iso10646-1" nil t)

;; (set-frame-font
;;  "-*-Fira Code-normal-normal-normal-*-12-*-*-*-m-0-iso10646-1" nil t)

(when (memq window-system '(ns mac))
  (set-frame-font
   "-apple-Inconsolata-medium-normal-normal-*-16-*-*-*-m-0-iso10646-1" nil t)
  ;; Ligatures: only the emacs-mac port defines this.
  (when (fboundp 'mac-auto-operator-composition-mode)
    (mac-auto-operator-composition-mode)))

(provide 'init-fonts)
;;; init-fonts ends here
