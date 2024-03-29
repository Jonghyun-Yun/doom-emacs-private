;;; ../Dropbox/emacs/.doom.d/local/ess-plus.el -*- lexical-binding: t; -*-

(defvar jyun/Rscript-last-executed-file nil
  "Rscript file I run the last time.")
(defvar jyun/Rscript-last-working-directory nil
  "Working directory that I run Rscript the last time.")
(set-popup-rule! "\\*Rscript" :size 0.3 :select t :ttl nil)
;; Display output in a popup.
(defun msg-me (process event)
   (princ
     (format "Process: %s had the event `%s'" process event)))

;; ;; https://github.com/emacs-ess/ESS/issues/842
;; ;; doom has no quickhelp mode?
;; (defun disable-company-quickhelp-in-ESS-R ()
;;   (company-quickhelp-mode -1))
;; (add-hook 'inferior-ess-r-mode-hook 'disable-company-quickhelp-in-ESS-R)

;; ;; ess: leave my underscore key alone!
;; (add-hook 'ess-mode-hook
;;           (lambda ()
;;             (ess-toggle-underscore nil)))

(setq ess-eval-visibly 'nowait
      inferior-R-args "--no-restore-history --no-save "
      ess-ask-for-ess-directory nil
      ;; ess-style 'RStudio
      ;; ess-tab-complete-in-script t
      )
(setq ess-R-font-lock-keywords
      '((ess-R-fl-keyword:keywords . t)
        (ess-R-fl-keyword:constants . t)
        (ess-R-fl-keyword:modifiers . t)
        (ess-R-fl-keyword:fun-defs . t)
        (ess-R-fl-keyword:assign-ops . t)
        (ess-R-fl-keyword:%op% . t)
        (ess-fl-keyword:fun-calls . t)
        (ess-fl-keyword:numbers)
        (ess-fl-keyword:operators)
        (ess-fl-keyword:delimiters)
        (ess-fl-keyword:=)
        (ess-R-fl-keyword:F&T)
        ))

(with-eval-after-load 'ess
;;; lintr
;; disable assignment fix (= to <-)
  ;; https://github.com/jimhester/lintr
  (setq flycheck-lintr-linters
        "with_defaults(line_length_linter(120), assignment_linter = NULL, object_name_linter = NULL)")

  (evil-set-initial-state 'inferior-ess-r-mode 'insert)
  ;; (setq ess-assign-list '(" <- " " = " " -> ")
  ;;       ess-r-smart-operators t)
  ;; ;; ess-assign
  ;; (defvar ess-assign-key "\M--"
  ;;   "Call `ess-insert-assign'.")

  ;; (with-eval-after-load 'ess-r-mode
  ;;   (define-key ess-r-mode-map ess-assign-key #'ess-insert-assign))
  ;; (add-hook 'inferior-ess-r-mode-hook
  ;;           #'(lambda () (define-key inferior-ess-r-mode-map ess-assign-key #'ess-insert-assign)))
  )

;;; tab to space
;; http://xahlee.info/emacs/emacs/emacs_tabs_space_indentation_setup.html
(defun jyun/disable-indent-tabs ()
  "set `indent-tabs-mode' to nil"
  (setq indent-tabs-mode nil))
(add-hook 'ess-r-mode-hook #'jyun/disable-indent-tabs)

;;; polymode
;; The following chunks are taken from https://github.com/vspinu/polymode

;; no filetype tags
(setq polymode-exporter-output-file-format "%s"
      polymode-weaver-output-file-format "%s")


;;;; MARKDOWN
;; (add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))

;;;; R modes
(add-to-list 'auto-mode-alist '("\\.[rR]md$". poly-markdown+r-mode))
;; (add-to-list 'auto-mode-alist '("\\.rapport$" . poly-rapport-mode))
;; (add-to-list 'auto-mode-alist '("\\.Rhtml$" . poly-html+r-mode))
;; (add-to-list 'auto-mode-alist '("\\.Rbrew$" . poly-brew+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rcpp$" . poly-r+c++-mode))
(add-to-list 'auto-mode-alist '("\\.cppR$" . poly-c++r-mode))

;; forward/inverse sync: Rnw and pdf
;; don't move this to private layer -> won't work
;; eval-after-load or use-package not working
;; (require 'ess-site)

;; (setq ess-swv-plug-into-AUCTeX-p t)
;; (setq ess-swv-processor 'knitr)

;; (setq auto-mode-alist (delete '("\\.Snw\\'" . poly-noweb+r-mode) auto-mode-alist))
;; (setq auto-mode-alist (delete '("\\.[rR]nw\\'" . poly-noweb+r-mode) auto-mode-alist))

;; ESS drops the support for Rnw
(add-to-list 'auto-mode-alist '("\\.[sS]nw\\'" . Sweave-mode))
(add-to-list 'auto-mode-alist '("\\.[rR]nw\\'" . Sweave-mode))
(add-to-list 'auto-mode-alist '("\\.[rR]markdown\\'" . ploy-markdown+R-mode))

(eval-after-load "poly-markdown+r-mode"
  '(progn
     (defun rmarkdown-new-chunk (name)
       "Insert a new R chunk."
       (interactive "sChunk name: ")
       (insert "\n```{r " name "}\n")
       (save-excursion
         (newline)
         (insert "```\n")
         ;; (previous-line)
         (forward-line -1)
         ))
     (local-set-key [M-ni] (quote rmarkdown-new-chunk))
     ))

;; ;; Default exporter
;; (defun my-poly-markdown+r-options ()
;;   (oset pm/polymode :exporter 'pm-exporter/Rmarkdown-ESS))

;; (add-hook 'poly-markdown+r-mode-hook 'my-poly-markdown+r-options)

;; what is this for???
(with-eval-after-load 'ess-site ;;ess-swv? or ess?
  (defun ess-swv-remove-TeX-commands (x)
    "Helper function: check if car of X is one of the Knitr strings"
    (let ((swv-cmds '("Knit" "LaTeXKnit" "Patch Knitr Synctex")))
      (unless (member (car x) swv-cmds) x)))
  )

;; Make RefTex aware of Snw and Rnw files
(setq reftex-file-extensions
      '(("Snw" "Rnw" "nw" "tex" ".tex" ".ltx") ("bib" ".bib")))
