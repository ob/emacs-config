;;; git -- init git
;;; Commentary:
;;; Code:

(require 'init-elpa)
(require-package 'magit)

(global-set-key (kbd "C-x g") 'magit-status)

(provide 'init-git)
;;; init-git ends here
