;;; ~/.doom.d/autoload/ess.el -*- lexical-binding: t; -*-
;;;###if (featurep! :lang ess)

;;; Rscript
;;;###autoload
(defun jyun/run-Rscript-file (rname &optional wd)
  "Async Rscript a file."
  (jyun/check-Rscript-file-extension rname)
  (let ((default-directory (or wd default-directory))
        (buf (current-buffer)))
    (setq jyun/Rscript-last-executed-file rname)
    (setq jyun/Rscript-last-working-directory default-directory)
    (start-process "Rscript" "*Rscript*" "Rscript" rname)
    (set-process-sentinel (get-process "Rscript") 'msg-me)
    (with-current-buffer "*Rscript*"
      (ess-r-mode)
      (+popup/buffer)
      (buffer-disable-undo))))

(defun jyun/run-last-Rscript-file ()
  "Async Rscript the last file."
  (interactive)
  (jyun/run-Rscript-file jyun/Rscript-last-executed-file
                         jyun/Rscript-last-working-directory))

;;;###autoload
;; (defun jyun/find-or-run-last-Rscript (&optional arg)
;;   "Async run Rscript on a selected file."
;;   (interactive "P")
;;   (cond
;;    ((equal arg '(4))
;;     (jyun/run-last-Rscript jyun/Rscript-last-executed-file jyun/Rscript-last-working-directory))
;;    (t
;;     (let ((rname (read-file-name "Rscript: "))
;;           (default-directory (ffip-project-root)))
;;       (jyun/check-Rscript-file-extension rname)
;;       (setq jyun/Rscript-last-executed-file rname)
;;       (setq jyun/Rscript-last-working-directory default-directory)
;;       (let ((relname (abbreviate-file-name
;;                       (file-relative-name rname default-directory))))
;;         (jyun/run-last-Rscript relname default-directory))))))

;;;###autoload
(defun jyun/find-and-run-Rscript-file (&optional guess)
  "Select an R file and Async run it using Rscript."
  (interactive)
  (let* ((rname (read-file-name "Rscript: " nil guess))
         (default-directory (ffip-project-root))
         (relname (jyun/file-path-from-project rname)))
    (jyun/run-Rscript-file relname)))

;;;###autoload
(defun jyun/file-path-from-project (&optional fname)
  (let ((filename (or
                   fname
                   (buffer-file-name (buffer-base-buffer))
                   (bound-and-true-p list-buffers-directory))))
    (abbreviate-file-name
     (file-relative-name filename (ffip-project-root)))))

;;;###autoload
(defun jyun/save-current-buffer-and-run-Rscript ()
  "TODO"
  (interactive)
  (let ((default-directory (ffip-project-root))
        (relname (jyun/file-path-from-project)))
    (save-buffer)
    (jyun/run-Rscript-file relname)))

;;;###autoload
(defun jyun/check-Rscript-file-extension (file)
"TODO"
(unless (or (string= (file-name-extension file) "R")
            (string= (file-name-extension file) "r"))
  (user-error "The target is not an Rscript.")))

;;;###autoload
(defun jyun/run-Rscript-at-point (&optional identifier)
  "Tries to locate the file at point (or in active selection).
Uses find-in-project functionality (provided by ivy, helm, or project),
otherwise falling back to ffap.el (find-file-at-point)."
  (interactive)
  (let ((guess
         (cond (identifier)
               ((doom-region-active-p)
                (buffer-substring-no-properties
                 (doom-region-beginning)
                 (doom-region-end)))
               ((if (require 'ffap) (ffap-guesser)))
               ((thing-at-point 'filename t)))))
    (cond ((and (stringp guess)
                (file-exists-p guess))
           (jyun/run-Rscript-file guess (ffip-project-root)))
          (t
           (jyun/find-and-run-Rscript-file guess)
           ))
    t))

;;; Sweave
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

;;; RStudio's `clean and rebuild'
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
