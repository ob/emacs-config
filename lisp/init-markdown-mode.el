;;; markdown-mode -- init markdown
;;; Commentary:
;;; Code:

(require 'init-elpa)
(require-package 'markdown-mode)

; https://github.com/defunkt/markdown-mode
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(autoload 'gfm-mode "markdown-mode"
   "Major mode for editing GitHub Flavored Markdown files" t)
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))

;; Soft-wrap markdown so long paragraphs stay as a single logical line
;; (clean copy/paste) but wrap visually at a readable width instead of the
;; full window width. `M-q' would insert hard newlines and mangle pastes.
(require-package 'visual-fill-column)

;; `unfill-toggle' is a smarter `M-q': it fills an unfilled paragraph and
;; joins a hard-wrapped one back into a single logical line. That join is the
;; fix for docs received with a hard newline after every line, which paste
;; into GitHub/Slack looking mangled.
(require-package 'unfill)

(defun ob/markdown-soft-wrap ()
  "Enable readable soft wrapping for prose buffers."
  (visual-line-mode 1)                  ; wrap at word boundaries, no newlines
  (setq visual-fill-column-width 80     ; wrap column
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1)
  (local-set-key (kbd "M-q") #'unfill-toggle))

(add-hook 'markdown-mode-hook #'ob/markdown-soft-wrap)
(add-hook 'gfm-mode-hook #'ob/markdown-soft-wrap)

(setq markdown-command
      "pandoc --from=gfm --to=html5 --standalone=false --highlight-style=pygments")

(setq markdown-css-paths
      '("https://cdn.jsdelivr.net/npm/github-markdown-css@5/github-markdown.min.css"
        "https://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/styles/github.min.css"))

(setq markdown-xhtml-header-content
      (concat
       "<meta name='viewport' content='width=device-width, initial-scale=1'>"
       "<style>"
       "  :root { color-scheme: light dark; }"
       "  body { box-sizing: border-box; max-width: 860px; margin: 40px auto;"
       "         padding: 48px; font-size: 16px; line-height: 1.6; }"
       "  @media (max-width: 767px) { body { padding: 20px; margin: 0; } }"
       "  @media (prefers-color-scheme: dark) {"
       "    body { background: #0d1117; }"
       "    .markdown-body { --color-canvas-default: #0d1117;"
       "                     --color-fg-default: #c9d1d9; }"
       "  }"
       "  .markdown-body { box-shadow: 0 1px 3px rgba(0,0,0,0.08); border-radius: 6px; }"
       "</style>"
       "<link rel='stylesheet'"
       "      href='https://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/styles/github-dark.min.css'"
       "      media='(prefers-color-scheme: dark)'>"
       "<script src='https://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/highlight.min.js'></script>"
       "<script>"
       "document.addEventListener('DOMContentLoaded', function() {"
       "  document.body.classList.add('markdown-body');"
       "  document.querySelectorAll('pre code').forEach(function(b){ hljs.highlightElement(b); });"
       "});"
       "</script>"))

(provide 'init-markdown-mode)
;;; init-markdown-mode ends here
