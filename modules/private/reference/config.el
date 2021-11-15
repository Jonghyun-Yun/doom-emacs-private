;;; private/reference/config.el -*- lexical-binding: t; -*-
;;;
(after! (org-ref org-capture)
  (add-to-list 'org-capture-templates
               '("GSA" "General Skim Annotation" entry
                 (file+function (lambda () (buffer-file-name)) +org-move-point-to-heading)
                 "* %? \n:PROPERTIES: \n:CREATED: %U
:SKIM_NOTE: %(+reference/skim-get-annotation)
:SKIM_PAGE: %(+reference/get-skim-page-number)
:END: \n%i"))
  ;; (if (equal org-ref-notes-function #'orb-notes-fn)
  ;;       (add-to-list 'org-capture-templates
  ;;                    '("SA" "Skim Annotation" entry
  ;;                      (function (lambda () (progn (orb-notes-fn (+reference/skim-get-bibtex-key))
  ;;                                             (+reference/org-move-point-to-capture-skim-annotation)
  ;;                                             ;; (+org-move-point-to-heading)
  ;;                                             ;; (cond ((org-at-heading-p)
  ;;                                             ;;        (org-beginning-of-line))
  ;;                                             ;;       (t
  ;;                                             ;;        (org-previous-visible-heading
  ;;                                             ;;         1)))
  ;;                                             )))
  ;;                      "* %?
  ;; :PROPERTIES:
  ;; :CREATED: %U
  ;; :SKIM_NOTE: %(+reference/skim-get-annotation)
  ;; :SKIM_PAGE: %(+reference/get-skim-page-number)
  ;; :END:
  ;; %i")))
  (if (featurep! :private biblio +roam-bibtex)
      (add-to-list 'org-capture-templates
                   '("SA" "Skim Annotation" entry
                     (function (lambda () (progn (;; orb-notes-fn
                                             orb-edit-note (+reference/skim-get-bibtex-key))
                                            ;; (+reference/org-roam-bibtex-move-point-to-capture-skim-annotation)
                                            ;; (+org-move-point-to-heading)
                                            ;; (cond ((org-at-heading-p)
                                            ;;        (org-beginning-of-line))
                                            ;;       (t
                                            ;;        (org-previous-visible-heading
                                            ;;         1)))
                                            )))
                     "* %? \n:PROPERTIES: \n:CREATED: %U
:SKIM_NOTE: %(+reference/skim-get-annotation)
:SKIM_PAGE: %(+reference/get-skim-page-number)
:END: \n%i"))
    ;; else
    (if (equal org-ref-notes-function #'org-ref-notes-function-one-file)
        (add-to-list 'org-capture-templates
                     '("SA" "Skim Annotation" entry
                       (file+function org-ref-bibliography-notes +reference/org-move-point-to-capture-skim-annotation)
                       "* %? \n:PROPERTIES: \n:CREATED: %U \n:CITE: cite:%(+reference/skim-get-bibtex-key)
:SKIM_NOTE: %(+reference/skim-get-annotation)
:SKIM_PAGE: %(+reference/get-skim-page-number)
:END: \n%i"))))
  )

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

  (if (featurep! :private biblio +roam-bibtex)
      (setq org-ref-notes-function #'orb-org-ref-edit-note))

  ;; override functions in org-ref
  ;; b/c these functions are loaded before loading org-ref
  (load! "bibtex-pdf")
  )

(after! 'bibtex-completion
  (cond
   (IS-MAC
    (setq bibtex-completion-pdf-open-function
          (lambda (fpath)
            ;; (async-start-process "open" "open" "open" nil "-a" "Skim" fpath) ;; not wokring
            ;; (async-start-process "open" "open" nil fpath) ;; system default
            (async-start-process "open" "open" nil "-a" "Skim" fpath) ;; skim
            ;; (call-process "open" nil 0 nil "-a" "Skim" fpath) ;; skim
            ))
    )
   (IS-LINUX
    (setq bibtex-completion-pdf-open-function
          (lambda (fpath)
            (async-start-process "open-pdf" "/usr/bin/xdg-open" nil fpath)))))

  ;; (setq bibtex-completion-pdf-open-function 'find-file) ;; using pdf-tools
  )

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

