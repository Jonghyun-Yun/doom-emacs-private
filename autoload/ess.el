;;; ~/.doom.d/autoload/ess.el -*- lexical-binding: t; -*-
;;;###if (featurep! :lang ess)

;;;###autoload
(defun Sweave-mode ()
  "ESS Sweave mode for Rnw files."
  (interactive)
  ;; (require 'ess-site)
  ;; (require 'poly-R)
  ;; (require 'poly-noweb)
  (poly-noweb+r-mode)
  ;; ESS drops Rnw support
  ;; (Rnw-mode)
  "Add commands to AUCTeX's \\[TeX-command-list]."
  (unless (and (featurep 'tex-site) (featurep 'tex))
    (error "AUCTeX does not seem to be loaded"))
  (add-to-list 'TeX-command-list
               '("Knit" "Rscript -e \"library(knitr); knit('%t')\""
                 TeX-run-command nil t :help
                 "Run Knitr"))
  (add-to-list 'TeX-command-list
               '("Knit2PDF" "Rscript -e \"library(knitr); source('~/Dropbox/emacs/patchKnitrSynctex/knitmk.R'); knitmk('%t'); source('~/Dropbox/emacs/patchKnitrSynctex/patchKnitrSynctex.R'); patchKnitrSynctex('%s.tex')\""
                 TeX-run-command nil t :help
                 "Run Knit to PDF and Patch Synctex"))
  (add-to-list 'TeX-command-list
               '("PatchKnitrSynctex"
                 "Rscript -e \"source('~/Dropbox/emacs/patchKnitrSynctex/patchKnitrSynctex.R'); patchKnitrSynctex('%s.tex')\""
                 TeX-run-command nil :help
                 "Patch Knitr Synctex"))
  (add-to-list 'TeX-command-list
               '("LaTeXKnit" "%`%l%(mode)%' %s"
                 TeX-run-TeX nil (latex-mode doctex-mode) :help
                 "Run LaTeX on TeX files knitted from Rnw"))

  (setq TeX-command-default "Knit")

  (mapc (lambda (suffix)
          (add-to-list 'TeX-file-extensions suffix))
        '("nw" "Snw" "Rnw"))

  (mapc (lambda (suffix)
          (add-to-list 'reftex-file-extensions suffix))
        '(("nw") ("Snw") ("Rnw"))))

;; ESS's equivalent of RStudio's `clean and rebuild'
;;;###autoload
(defun ess-r-devtools-clean-and-rebuild-package (&optional arg)
  "Interface to `devtools::install()'.
By default the installation is \"quick\" with arguments quick =
TRUE, upgrade = FALSE, build = FALSE. On prefix ARG
\\[universal-argument] install with the default
`devtools::install()' arguments."
  (interactive "P")
  (progn
    (ess-r-package-eval-linewise "Rcpp::compileAttributes(%s)")
    (ess-r-package-eval-linewise
     "devtools::install(%s)\n" "Installing %s" arg
     '("quick = TRUE, build = FALSE, upgrade = FALSE, keep_source = TRUE"
       (read-string "Arguments: " "keep_source = TRUE, force = TRUE")))))
