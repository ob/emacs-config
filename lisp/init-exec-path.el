(require 'init-elpa)

(require-package 'exec-path-from-shell)
;; A daemon started from launchd/Spotlight has no window-system yet and
;; inherits no shell PATH, so it needs this too.
(when (or (memq window-system '(mac ns x)) (daemonp))
  (exec-path-from-shell-initialize))

(provide 'init-exec-path)
