;;; ediff -- customize ediff
;;; Commentary:
;;; Code:
(require 'init-elpa)

(setq ediff-split-window-function 'split-window-horizontally)
;; don't start a new frame
(setq ediff-window-setup-function 'ediff-setup-windows-plain)


(provide 'init-ediff)
;;; init-ediff ends here
