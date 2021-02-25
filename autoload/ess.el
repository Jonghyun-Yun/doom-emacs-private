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
        '(("nw") ("Snw") ("Rnw")))
  )
