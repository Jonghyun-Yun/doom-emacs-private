;;; private/reference/config.el -*- lexical-binding: t; -*-

(after! org-ref
  (require 'org-mac-link)
  (require 'org-id)

  (org-link-set-parameters "skim" :follow #'+reference/org-mac-skim-open)

  ;; create org-id for skim to org jump
  (add-hook 'org-capture-prepare-finalize-hook #'+reference/append-org-id-to-skim-hook)

;;;; org-ref-note-title-format
  (setq org-ref-note-title-format
        "** %y - %t
 :PROPERTIES:
  :Custom_ID: %k
  :AUTHOR: %9a
  :JOURNAL: %j
  :YEAR: %y
  :VOLUME: %v
  :PAGES: %p
  :DOI: %D
  :URL: %U
 :END:

")

  (setq org-ref-open-pdf-function 'org-ref-open-pdf-at-point)
  ;; (setq org-ref-notes-function #'org-ref-notes-function-one-file)
  ;; (setq org-ref-notes-function #'org-ref-notes-function-many-files)

  ;; override functions in org-ref
  ;; b/c these functions are loaded before loading org-ref
  (load! "bibtex-pdf")

  ;;   ;; https://github.com/jkitchin/org-ref/blob/master/org-ref.org
  ;;   (defun org-ref-open-pdf-at-point ()
  ;;     "Open the pdf for bibtex key under point if it exists."
  ;;     (interactive)
  ;;     (let* ((results (org-ref-get-bibtex-key-and-file))
  ;;            (key (car results))
  ;;            (pdf-file (car (bibtex-completion-find-pdf key))))
  ;;       ;; (pdf-file (car (bibtex-completion-find-pdf-in-field key))))
  ;;       (if (file-exists-p pdf-file)
  ;;           (org-open-file pdf-file)
  ;;         (message "No PDF found for %s" key))))

  ;;   ;; Override this function in org-ref.
  ;;   (defun org-ref-open-bibtex-pdf ()
  ;;     "Open pdf for a bibtex entry, if it exists.
  ;; assumes point is in
  ;; the entry of interest in the bibfile.  but does not check that."
  ;;     (interactive)
  ;;     (save-excursion
  ;;       (bibtex-beginning-of-entry)
  ;;       (let* ((bibtex-expand-strings t)
  ;;              (entry (bibtex-parse-entry t))
  ;;              (key (reftex-get-bib-field "=key=" entry))
  ;;              (pdf-file (car (bibtex-completion-find-pdf-in-field key))))
  ;;         (if (file-exists-p pdf-file)
  ;;             (call-process "open" nil 0 nil "-a" "Skim" pdf-file)
  ;;           (message "No PDF found for %s" key)))))
  )

(with-eval-after-load 'bibtex-completion
  (setq bibtex-completion-pdf-open-function
        (lambda (fpath)
          (async-start-process "open" "open" "open" nil "-a" "Skim" fpath)
          ;; (call-process "open" nil 0 nil "-a" "Skim" fpath)
          ))
  )

;; (after! org-capture
;;   (add-to-list 'org-capture-templates
;;                '("GSA" "General Skim Annotation" entry
;;                  (file+function (lambda () (buffer-file-name)) +org-move-point-to-heading)
;;                  "* %?
;;    :PROPERTIES:
;;    :CREATED: %U
;;    :SKIM_NOTE: %(+reference/skim-get-annotation)
;;    :SKIM_PAGE: %(+reference/get-skim-page-number)
;;    :END:
;;    %i"))
;;   (add-to-list 'org-capture-templates
;;                '("SA" "Skim Annotation" entry
;;                  (file+function org-ref-bibliography-notes +reference/org-move-point-to-capture-skim-annotation)
;;                  "* %?
;;    :PROPERTIES:
;;    :CREATED: %U
;;    :CITE: cite:%(+reference/skim-get-bibtex-key)
;;    :SKIM_NOTE: %(+reference/skim-get-annotation)
;;    :SKIM_PAGE: %(+reference/get-skim-page-number)
;;    :END:
;;    %i"))
;;   )

;; (use-package! org-ref
;;   :commands (org-ref-bibtex-next-entry
;;              org-ref-bibtex-previous-entry
;;              doi-utils-get-bibtex-entry-pdf
;;              org-ref-ivy-insert-cite-link
;;              org-ref-find-bibliography
;;              org-ref-open-in-browser
;;              org-ref-open-bibtex-notes
;;              org-ref-open-bibtex-pdf
;;              org-ref-bibtex-hydra/body
;;              org-ref-bibtex-hydra/org-ref-bibtex-new-entry/body-and-exit
;;              org-ref-sort-bibtex-entry
;;              arxiv-add-bibtex-entry
;;              arxiv-get-pdf-add-bibtex-entry
;;              doi-utils-add-bibtex-entry-from-doi
;;              isbn-to-bibtex
;;              pubmed-insert-bibtex-from-pmid)
;; ;; :init
;;   (when (featurep! :completion helm)
;;     (setq org-ref-completion-library 'org-ref-helm-bibtex))
;;   (when (featurep! :completion ivy)
;;     (setq org-ref-completion-library 'org-ref-ivy-cite))

  ;; :config
;; (after! org-ref

  ;; (setq
   ;; orhc-bibtex-cache-file (concat doom-cache-dir "org-ref.cache")

   ;; org-ref-get-pdf-filename-function
   ;; (lambda (key) (car (bibtex-completion-find-pdf key)))
  ;; (setq
  ;;  org-ref-notes-function
  ;;  (lambda (thekey)
  ;;    (let*
  ;;        ((results
  ;;          (org-ref-get-bibtex-key-and-file thekey))
  ;;         (key
  ;;          (car results))
  ;;         (bibfile
  ;;          (cdr results)))
  ;;      (with-temp-buffer
  ;;        (insert-file-contents bibfile)
  ;;        (bibtex-set-dialect
  ;;         (parsebib-find-bibtex-dialect)
  ;;         t)
  ;;        (bibtex-search-entry key)
  ;;        (org-ref-open-bibtex-notes)))
  ;;    )
  ;;  )

  ;; (setq
  ;;  org-ref-notes-function
  ;;  (lambda (thekey)
  ;;    (let* ((results (org-ref-get-bibtex-key-and-file thekey))
  ;;           (key (car results))
  ;;           (bibfile (cdr results))
  ;;           )
  ;;      (save-excursion
  ;;        (with-temp-buffer
  ;;          (insert-file-contents bibfile)
  ;;          (bibtex-set-dialect (parsebib-find-bibtex-dialect) t)
  ;;          (bibtex-search-entry key)
  ;;          (org-ref-open-bibtex-notes)
  ;;          ))))
  ;;  )

   ;; org-ref-create-notes-hook
   ;; '((lambda ()
   ;;     (org-narrow-to-subtree)
   ;;     (insert (format "cite:%s\n" (org-entry-get (point) "CUSTOM_ID")))))

   ;; org-ref-note-title-format "* TODO %t \n:PROPERTIES: \n:CUSTOM_ID: %k \n:END:"

   ;; )

  ;; (when (eq +reference-field 'bioinfo)
  ;;   (require 'org-ref-biorxiv)
  ;;   (add-to-list 'doi-utils-pdf-url-functions 'oup-pdf-url)
  ;;   (add-to-list 'doi-utils-pdf-url-functions 'bmc-pdf-url)
  ;;   (add-to-list 'doi-utils-pdf-url-functions 'biorxiv-pdf-url))

  ;; (when IS-MAC
  ;;   (setq doi-utils-pdf-url-functions
  ;;         (delete 'generic-full-pdf-url doi-utils-pdf-url-functions))
  ;;   (add-to-list 'doi-utils-pdf-url-functions 'generic-as-get-pdf-url t))

  ;; )


;; (use-package! bibtex
;;   :defer t
;;   :config
;;   (setq bibtex-dialect 'biblatex
;;         bibtex-align-at-equal-sign t
;;         bibtex-text-indentation 20)
;;   (map! :map bibtex-mode-map
;;         [fill-paragraph] #'bibtex-fill-entry))


;; (use-package! bibtex-completion
;;   :defer t
;;   :config
;;   (setq bibtex-completion-format-citation-functions
;;         '((org-mode . bibtex-completion-format-citation-pandoc-citeproc)
;;           (latex-mode . bibtex-completion-format-citation-cite)
;;           (default . bibtex-completion-format-citation-default))
;;         bibtex-completion-pdf-field "file"
;;         bibtex-completion-additional-search-fields '("journaltitle")
;;         bibtex-completion-pdf-symbol "@"
;;         bibtex-completion-notes-symbol "#"
;;         bibtex-completion-display-formats '((t . "${=has-pdf=:1}${=has-note=:1} ${author:20} ${journaltitle:10} ${year:4} ${title:*} ${=type=:3}")))
;;   (cond
;;    (IS-MAC
;;     (setq bibtex-completion-pdf-open-function
;;           (lambda (fpath)
;;             (async-start-process "open" "open" "open" fpath))))
;;    (IS-LINUX
;;     (setq bibtex-completion-pdf-open-function
;;           (lambda (fpath)
;;             (async-start-process "open-pdf" "/usr/bin/xdg-open" nil fpath))))))

(after! ivy-bibtex

  (setq ivy-bibtex-default-action 'ivy-bibtex-insert-key)
  ;; (setq ivy-bibtex-default-action 'ivy-bibtex-open-any)

  ;; (add-to-list 'ivy-re-builders-alist '(ivy-bibtex . ivy--regex-plus))
  (when IS-MAC
    (ivy-bibtex-ivify-action bibtex-completion-quicklook ivy-bibtex-quicklook)
    (ivy-add-actions 'ivy-bibtex '(("SPC" ivy-bibtex-quicklook "Quick look"))))
  )

;; (use-package! ivy-bibtex
;;   :when (featurep! :completion ivy)
;;   :commands (ivy-bibtex)
;;   :config
;;   (setq ivy-bibtex-default-action 'ivy-bibtex-insert-key)
;;   (add-to-list 'ivy-re-builders-alist '(ivy-bibtex . ivy--regex-plus))
;;   (when IS-MAC
;;     (ivy-bibtex-ivify-action bibtex-completion-quicklook ivy-bibtex-quicklook)
;;     (ivy-add-actions 'ivy-bibtex '(("SPC" ivy-bibtex-quicklook "Quick look")))))


;; (use-package! helm-bibtex
;;   :when (featurep! :completion helm)
;;   :commands helm-bibtex)

;; (after! org-capture
;;   (add-to-list 'org-capture-templates
;;                '("GSA" "General Skim Annotation" entry
;;                  (file+function (lambda () (buffer-file-name)) +org-move-point-to-heading)
;;                  "* %?
;;    :PROPERTIES:
;;    :CREATED: %U
;;    :SKIM_NOTE: %(+reference/skim-get-annotation)
;;    :SKIM_PAGE: %(+reference/get-skim-page-number)
;;    :END:
;;    %i"))
;;   (after! org-ref
;;     (add-to-list 'org-capture-templates
;;                  '("SA" "Skim Annotation" entry
;;                    (file+function org-ref-bibliography-notes +reference/org-move-point-to-capture-skim-annotation)
;;                    "* %?
;;    :PROPERTIES:
;;    :CREATED: %U
;;    :CITE: cite:%(+reference/skim-get-bibtex-key)
;;    :SKIM_NOTE: %(+reference/skim-get-annotation)
;;    :SKIM_PAGE: %(+reference/get-skim-page-number)
;;    :END:
;;    %i"))))

;; ;; skim to org-roam-bibtex integration
;; ;; org-id is not generated
;; ;; org-roam-capture error (due to outdated package) -> updated
;; ;; more than 2 attachment -> error
;; (with-eval-after-load 'org-capture
;;     (add-to-list 'org-capture-templates
;;                  '("RSA" "Skim Annotation" entry
;;                    (file+function yunj/skim-orb-notes +reference/org-move-point-to-capture-skim-annotation)
;;                    "* %^{Note for...}
;;    :PROPERTIES:
;;    :CREATED: %U
;;    :CITE: cite:%(+reference/skim-get-bibtex-key)
;;    :SKIM_NOTE: %(+reference/skim-get-annotation)
;;    :SKIM_PAGE: %(+reference/get-skim-page-number)
;;    :END:
;;    %i \n%?"))
;;     )

;; ;;;###autoload
;; (defun yunj/skim-orb-notes ()
;;   (progn
;;     (orb-notes-fn (+reference/skim-get-bibtex-key))
;;     (let ((bname (buffer-file-name)))
;;       (kill-this-buffer)
;;       bname)))

