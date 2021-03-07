;;; ess-plus.el --- description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2020 Jonghyun Yun
;;
;; Author: Jonghyun Yun <http://github/yunj>
;; Maintainer: Jonghyun Yun <jonghyun.yun@gmail.com>
;; Created: June 08, 2020
;; Modified: June 08, 2020
;; Version: 0.0.1
;; Keywords:
;; Homepage: https://github.com/yunj/ess-plus
;; Package-Requires: ((emacs 27.0.91) (cl-lib "0.5"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  description
;;
;;; Code:

;; ;; language server w/o launching R
;; (with-eval-after-load 'lsp-mode
;;   (lsp-register-client
;;    (make-lsp-client :new-connection (lsp-stdio-connection '("R" "--slave" "-e" "languageserver::run()"))
;;                     :major-modes '(ess-r-mode)
;;                     :server-id 'lsp-R))

;;   (setq lsp-language-id-configuration
;;         (append lsp-language-id-configuration
;;                 '((ess-r-mode . "R")
;;                   ;; (Sweave-mode . "R")
;;                   )))
;;   )

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

;; (defun poly-org-mode ()
;; "Polymode for Org files"
;; (interactive)
;; (require 'poly-org)
;; (poly-org-mode))
;; (use-package poly-R
;;   :ensure t
;;   :defer t
;; )

;; (use-package poly-markdown
;;   :ensure t
;;   :defer t
;;   )

;; (use-package poly-noweb
;; :ensure t
;; :defer t
;; )

;;   (use-package poly-org
;;     :ensure t
;;     :defer t
;;     )

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

(with-eval-after-load 'polymode
  ;; no filetype tags
  (setq polymode-exporter-output-file-format "%s"
        polymode-weaver-output-file-format "%s")
  )

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

(provide 'ess-plus)
;;; ess-plus.el ends here
