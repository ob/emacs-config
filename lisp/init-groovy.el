;;; groovy -- init-groovy.el
;;; Commentary:
;;; Code:

(require 'init-elpa)
(require-package 'gradle-mode)
(require-package 'groovy-mode)

(require 'gradle-mode)
(require 'groovy-mode)

(add-hook 'groovy-mode-hook
          (lambda ()
            (setq-default groovy-indent-offset 2)))


(provide 'init-groovy)
;;; init-groovy ends here
