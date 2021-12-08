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
