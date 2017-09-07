;;; elm -- init-elm.el
;;; Commentary:
;;; Code:

(require 'init-elpa)
(require-package 'company)
(require-package 'elm-mode)
(require-package 'flycheck)
(require-package 'flycheck-elm)

(require 'company)
(require 'elm-mode)
(require 'flycheck)
(require 'flycheck-elm)


(add-to-list 'company-backends 'company-elm)

(provide 'init-elm)
;;; init-elm ends here
