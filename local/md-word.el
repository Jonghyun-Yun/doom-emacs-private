;;; md-word.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Jonghyun Yun
;;
;; Author: Jonghyun Yun <https://github.com/jonghyun-yun>
;; Maintainer: Jonghyun Yun <jonghyun.yun@gmail.com>
;; Created: April 29, 2021
;; Modified: April 29, 2021
;; Version: 0.0.1
;; Keywords: Symbol’s value as variable is void: finder-known-keywords
;; Homepage: https://github.com/yunj/md-word
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

;; #+bibliography:~/Zotero/myref.bib
;; #+PANDOC-CSL: /Users/yunj/Zotero/styles/cell.csl
;; #+PANDOC_OPTIONS: number-sections:t
;; #+PANDOC_OPTIONS: csl:/Users/yunj/Zotero/styles/ieee.csl
;; #+PANDOC_OPTIONS: biblatex:t natbib:t

(eval-when-compile (require 'cl))
(require 'cl-lib)
(require 'org-ref)
(require 'ox)
(require 'ox-latex)

(defvar md-word-fix-author-yaml-header nil
  "Fix yaml header.
author:
- auth1, auth2, ...

->
author: auth1, auth2, ...
.")

(defvar md-word-delete-temp-files t
  "Delete an intermediate files.")

(defvar md-word-args nil
  "Pandoc arguments for rendering markdown to generate MS Word.")

(defun ox-export-via-latex-pandoc-to-docx-and-open (&optional async subtreep visible-only body-only options)
  (interactive)
  (let* ((biblio (or (cdar (org-collect-keywords '("bibliography"))) (cdar (org-collect-keywords '("BIBLIOGRAPHY")))))
         (bibfiles (if biblio biblio (mapcar 'expand-file-name (org-ref-find-bibliography))))
         (temp-bib)
         (bibtex-entries)
         biboption
         csl
         ;; this is probably a full path
         (current-file (buffer-file-name))
         (basename (file-name-sans-extension current-file))
         (tex-file (concat basename ".tex"))
         (docx-file (concat basename ".docx"))
         (md-file (concat basename ".md"))
         )

    (save-buffer)

    (when bibfiles
      (setq bibtex-entries (let* ((bibtex-files bibfiles)
                                  (keys (reverse (org-ref-get-bibtex-keys)))
                                  (bibtex-entry-kill-ring-max (length keys))
                                  (bibtex-entry-kill-ring '()))

                             (save-window-excursion
                               (cl-loop for key in keys
                                        do
                                        (bibtex-search-entry key t)
                                        (bibtex-kill-entry t)))
                             (mapconcat
                              'identity
                              bibtex-entry-kill-ring
                              "\n\n"))
            temp-bib (make-temp-file "ox-word-" nil ".bib")
            biboption (format " --bibliography=%s " temp-bib))
      (with-temp-file temp-bib
        (insert bibtex-entries))
      )


    (setq csl (cdr (assoc "PANDOC-CSL"
                          (org-element-map (org-element-parse-buffer) 'keyword
                            (lambda (key) (cons
                                      (org-element-property :key key)
                                      (org-element-property :value key)))))))
    (if csl (setq csl (format " --csl=%s " (expand-file-name csl)))
      (setq csl " "))

    (setq md-word-args
          `(" -s -f markdown -t docx" " -F pandoc-crossref" " --citeproc" ,csl
            ,biboption
            ;; "-t" ,(or output-format format)
            ,@(and docx-file
                   (list "-o " (expand-file-name docx-file)))
            ;; ,@(-mapcat (lambda (key)
            ;;              (-when-let (vals (gethash key options))
            ;;                (if (equal vals t) (setq vals (list t)))
            ;;                (--map (concat "--" (symbol-name key)
            ;;                               (when (not (equal it t)) (format "=%s" it)))
            ;;                       vals)))
            ;;            (ht-keys options))
            " "
            ,(expand-file-name md-file)))
    ;; (org-latex-export-to-latex async subtreep visible-only body-only options)
    ;; (let ((process
    ;;            (apply 'start-process
    ;;                   `("pandoc" ,(generate-new-buffer "*Pandoc*")
    ;;                     ,org-pandoc-command ,@md-word-args))))
    ;;       (set-process-sentinel process 'org-pandoc-sentinel)
    ;;       process))
    ;; (message (apply #'concatenate 'string md-word-args))

    (org-latex-export-to-latex async subtreep visible-only body-only options)
    (shell-command (format "pandoc -f latex -t markdown -s %s -o %s" tex-file md-file)) ; -s for --standalone (need to get yaml header)

    ;; post-processing Md
    ;; fix author header
    (when md-word-fix-author-yaml-header
      (let* ((author-regex "^---[^\\$]^author:\\(.*\\)[^\\$]- \\(.*\\)$")
             (buf (find-file-noselect md-file)))
        (with-current-buffer buf
          (goto-char (point-min))
          (while (re-search-forward author-regex nil t)
            (replace-match "author: \\2"))
          (save-buffer)
          (message "done with authors.")
          )
        ))

    ;; table caption
    (let* ((tab-regex ": \\[\\\\\\[tab:\\(.*?\\)\\\\\\]\\]{#\\(2?.*\\) label=\"\\2\"}\\(.*\\)$")
           (buf (find-file-noselect md-file))
           (i 0)
           labels)
      (with-current-buffer buf
        (goto-char (point-min))
        (while (re-search-forward tab-regex nil t)
          (incf i)
          (push (cons (match-string 1) i) labels)
          (replace-match (format ": Table %d: \\3" i)))
        (save-buffer)
        (message "done with tables.")
        ))

    ;; figure
    (let* ((fig-regex "!\\[\\[\\\\\\[\\(fig:.*\\)\\\\\\]\\]{#\\(.*\\) label=\"\\2\"}")
           (buf (find-file-noselect md-file)))
      (with-current-buffer buf
        (goto-char (point-min))
        (while (re-search-forward fig-regex nil t)
          (replace-match "![")
          (join-line 1))
        (save-buffer)
        (message "done with figures.")
        ))

    ;; eqn
    (let* ((eqn-regex
            "\\(?:^\\|[^\\]\\)\\\\label{eq:\\(.*\\)}\\(?:\\([^\\$]\\|\\\\.\\)*\\)\\(?:\\$\\$\\)")
           (eqref-regex
            "\\[\\\\\\[eq:\\(.*\\)\\\\\\]\\]")
           (buf (find-file-noselect md-file))
           (i 0)
           labels)
      (with-current-buffer buf
;;; fix eqn #
        (goto-char (point-min))
        (while (re-search-forward eqn-regex nil t)
          (incf i)
          (push (cons (match-string 1) i) labels)
          (replace-match "\\&{#eq:\\1}"))
;;; fix eqn reference
        (goto-char (point-min))
        (while (re-search-forward eqref-regex nil t)
          (when (cdr (assoc (match-string 1) labels))
            (replace-match (format "[%d]" (cdr (assoc (match-string 1) labels))))))
        (save-buffer)
        (message "done with equations.")
        (kill-buffer buf)
        ))
    ;; go pandoc
    (message "Running pandoc with args: %s" md-word-args)
    (when (file-exists-p docx-file) (delete-file docx-file))
    (shell-command (concat "pandoc" (apply #'cl-concatenate 'string md-word-args)))
    (when (file-exists-p temp-bib)
      (delete-file temp-bib))
    (when md-word-delete-temp-files
      (progn
        (when
            (file-exists-p md-file)
          (delete-file md-file))
        (when (file-exists-p tex-file)
          (delete-file tex-file))
        )
      )
    (org-open-file docx-file '(16)))
  )

(org-export-define-derived-backend 'MSWord 'latex
  :menu-entry
  '(?w "Export to MS Word"
       ((?p "via Pandoc/LaTeX" ox-export-via-latex-pandoc-to-docx-and-open))))

(provide 'md-word)
;;; md-word.el ends here
