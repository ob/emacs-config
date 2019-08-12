;;; ob -- my fonts
;;; Commentary:
;;; Code:

;; (set-frame-font
;;  "-*-Hack-normal-normal-normal-*-11-*-*-*-m-0-iso10646-1" nil t)

(set-frame-font
 "-*-Fira Code-normal-normal-normal-*-12-*-*-*-m-0-iso10646-1" nil t)

(if (or (eq window-system 'ns) (eq window-system 'mac))
    ;; (set-frame-font
    ;;  "-apple-Inconsolata-medium-normal-normal-*-14-*-*-*-m-0-iso10646-1" nil t)
  (mac-auto-operator-composition-mode))

(provide 'init-fonts)
;;; init-fonts ends here
