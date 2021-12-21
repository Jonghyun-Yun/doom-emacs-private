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

;;; citar
;;;###autoload
(defun citar-open-bibtex-pdf (keys-entries)
  "Open pdf file associated with the KEYS-ENTRIES.

With prefix, rebuild the cache before offering candidates."
  (interactive (list (citar-select-refs
                      :rebuild-cache current-prefix-arg)))
  (when (and citar-library-paths
             (stringp citar-library-paths))
    (message "Make sure 'citar-library-paths' is a list of paths"))
  ;; (citar--library-files-action keys-entries 'open)
  (let* ((key (car (car keys-entries)))
         (pdf-file (car (bibtex-completion-find-pdf key))))
      (if (file-exists-p pdf-file)
          (funcall bibtex-completion-pdf-open-function pdf-file)
        ;; (org-open-file pdf-file)
        (message "No PDF found for %s" key-entries))))
