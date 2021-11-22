;;; ~/.doom.d/autoload/bibtex.el -*- lexical-binding: t; -*-

;;;###autoload
(defadvice! jyun/org-ref-open-pdf-at-point ()
  "Open the first pdf file for bibtex key under point."
  :override #'org-ref-open-pdf-at-point
  (interactive)
  (let* ((results (org-ref-get-bibtex-key-and-file))
         (key (car results))
         (pdf-file (car (bibtex-completion-find-pdf key))))
    ;; (pdf-file (car (bibtex-completion-find-pdf-in-field key))))
    (if (file-exists-p pdf-file)
        (org-open-file pdf-file)
      (message "No PDF found for %s" key))))

;; See https://github.com/jkitchin/org-ref/blob/master/org-ref.org"
;; (defun org-ref-open-pdf-at-point ()
;;   "Open the pdf for bibtex key under point if it exists."
;;   (interactive)
;;   (let* ((results (org-ref-get-bibtex-key-and-file))
;;          (key (car results))
;;          (pdf-file (car (bibtex-completion-find-pdf key))))
;;     ;; (pdf-file (car (bibtex-completion-find-pdf-in-field key))))
;;     (if (file-exists-p pdf-file)
;;         (org-open-file pdf-file)
;;       (message "No PDF found for %s" key))))

;; Override this function in org-ref.
;; (defun org-ref-open-bibtex-pdf ()
;;   "Open pdf for a bibtex entry, if it exists.
;; assumes point is in the entry of interest in the bibfile.  but does not check that."
;;   (interactive)
;;   (save-excursion
;;     (bibtex-beginning-of-entry)
;;     (let* ((bibtex-expand-strings t)
;;            (entry (bibtex-parse-entry t))
;;            (key (reftex-get-bib-field "=key=" entry))
;;            (pdf-file (car (bibtex-completion-find-pdf-in-field key))))
;;       (if (file-exists-p pdf-file)
;;           ;; (call-process "open" nil 0 nil "-a" "Skim" pdf-file)
;;           (async-start-process "open" "open" nil "-a" "Skim" fpath)
;;         (message "No PDF found for %s" key)))))

;; (package! org-ref :pin "caca18f8eeae213c2719e628949df70910f7d3c7") ;; breaking changes in this commit
;; (defun org-ref-open-bibtex-notes ()
;;   "From a bibtex entry, open the notes if they exist."
;;   (interactive)

;;   (bibtex-beginning-of-entry)
;;   (let* ((cb (current-buffer))
;;          (bibtex-expand-strings t)
;;          (entry (cl-loop for (key . value) in (bibtex-parse-entry t)
;;                          collect (cons (downcase key) (s-collapse-whitespace value))))
;;          (key (reftex-get-bib-field "=key=" entry)))

;;     (with-temp-buffer
;;       (insert key)
;;       (kill-ring-save (point-min) (point-max)))

;;     ;; now look for entry in the notes file
;;     (save-restriction
;;       (if  org-ref-bibliography-notes
;;           (find-file-other-window org-ref-bibliography-notes)
;;         (error "org-ref-bibliography-notes is not set to anything"))

;;       (widen)
;;       (goto-char (point-min))
;;       (let* ((headlines (org-element-map
;;                             (org-ref-parse-buffer)
;;                             'headline 'identity))
;;              (keys (mapcar
;;                     (lambda (hl) (org-element-property :CUSTOM_ID hl))
;;                     headlines)))

;;         ;; put new entry in notes if we don't find it.
;;         (if (-contains? keys key)
;;             (progn
;;               (org-open-link-from-string (format "[[#%s]]" key))
;;               (funcall org-ref-open-notes-function))
;;           ;; no entry found, so add one
;;           (goto-char (point-max))
;;           (insert (org-ref-reftex-format-citation
;;                    entry (concat "\n" org-ref-note-title-format)))
;;           (mapc (lambda (x)
;;                   (save-restriction
;;                     (save-excursion
;;                       (funcall x))))
;;                 org-ref-create-notes-hook)
;;           (save-buffer))
;;         )))
;;   )
