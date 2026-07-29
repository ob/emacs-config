;;; early-init.el --- Pre-init setup -*- lexical-binding: t; -*-
;;; Commentary:
;; Runs before package initialization and before init.el, so anything
;; that must be in place before the native compiler runs belongs here.
;;; Code:

;; The bundled libgccjit (GCC 14) derives the deployment target from the
;; Darwin kernel version with the pre-macOS-26 mapping (major - 9), so on
;; Darwin 27 it emits -mmacosx-version-min=18.0, a macOS release that never
;; existed.  Apple clang then rejects it and every native compilation fails
;; with "error invoking gcc driver".  Setting the target explicitly makes the
;; driver skip its own (broken) guess; the value is inherited by the async
;; native-comp subprocesses too.
(when (and (eq system-type 'darwin)
           (not (getenv "MACOSX_DEPLOYMENT_TARGET")))
  (setenv "MACOSX_DEPLOYMENT_TARGET" "15.0"))

(provide 'early-init)
;;; early-init.el ends here
