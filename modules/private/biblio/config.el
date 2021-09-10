;;; tools/biblio/config.el -*- lexical-binding: t; -*-

;; Internal function to set the various paths used in the
;; reference packages.
(defun +biblio-set-paths-fn (&optional symbol value)
  (when symbol
    (set-default symbol value))
  (when value
    (cond ((eq symbol '+biblio-pdf-library-dir)
           (when (featurep! :lang org)
             (setq org-ref-pdf-directory value))
           (setq bibtex-completion-library-path value))
          ((eq symbol '+biblio-default-bibliography-files)
           (when (featurep! :lang org)
             (setq reftex-default-bibliography value
                   org-ref-default-bibliography value))
           (setq bibtex-completion-bibliography value))
          ((eq symbol '+biblio-notes-path)
           (when (featurep! :lang org)
             (if (directory-name-p value)
                 (setq org-ref-notes-directory value)
               (setq org-ref-bibliography-notes value)))
           (setq bibtex-completion-notes-path value)))))


(defcustom +biblio-pdf-library-dir nil
  "Directory where pdf files are stored. Must end with a slash."
  :type 'string
  :set #'+biblio-set-paths-fn)

(defcustom +biblio-default-bibliography-files nil
  "A list of default bibtex files to use."
  :type '(repeat :tag "List of bibtex files" file)
  :set #'+biblio-set-paths-fn)

(defcustom +biblio-notes-path nil
  "The place where you will store your notes for bibliography files.

This can be either a single file or directory of files.
In case of directory the path must end with a slash."
  :type 'string
  :set #'+biblio-set-paths-fn)


(use-package! bibtex-completion
  :defer t
  :preface
  ;; Allow the user to set a template of their own via (setq). if the user does
  ;; not set one fall back to the +biblio variants which have a reasonable
  ;; fallback.
  (defvar bibtex-completion-notes-template-multiple-files nil)
   :config

  (when (featurep! :completion ivy)
    (add-to-list 'ivy-re-builders-alist '(ivy-bibtex . ivy--regex-plus)))

  (setq bibtex-completion-additional-search-fields '(keywords)
        ;; This tell bibtex-completion to look at the File field of the bibtex
        ;; to figure out which pdf to open
        bibtex-completion-pdf-field "file")
  ;; orb will define handlers for note taking so not needed to use the
  ;; ones set for bibtex-completion
  (unless (featurep! :lang org +roam2)

    (setq bibtex-completion-notes-path +biblio-notes-path)
    (unless bibtex-completion-notes-template-multiple-files
      (setq bibtex-completion-notes-template-multiple-files
            "${title} : (${=key=})

- tags ::
- keywords :: ${keywords}
\n* ${title}\n  :PROPERTIES:\n  :Custom_ID: ${=key=}\n  :URL: ${url}\n  :AUTHOR: ${author-or-editor}\n  :NOTER_DOCUMENT: /${file}\n  :NOTER_PAGE: \n  :END:\n\n"))))


;; TODO which set of keys that should be bound for commonly used functions
;; see https://github.com/jkitchin/org-ref/blob/master/org-ref-core.el#L3998
(use-package! org-ref
  :when (featurep! :lang org)
  :after org
  :preface
  ;; This need to be set before the package is loaded, because org-ref will
  ;; automatically `require' an associated package during its loading.
  ;; (setq org-ref-completion-library (cond ((featurep! :completion ivy)  #'org-ref-ivy-cite)
  ;;                                        ((featurep! :completion helm) #'org-ref-helm-bibtex)
  ;;                                        (t                            #'org-ref-reftex)))
  (setq org-ref-completion-library #'org-ref-ivy-cite)
  ;; (require 'org-ref-ivy-cite)
  :config
  ;; Although the name is helm-bibtex, it is actually a bibtex-completion function
  ;; it is the legacy naming of the project helm-bibtex that causes confusion.
  ;; (setq org-ref-open-pdf-function 'org-ref-get-pdf-filename-helm-bibtex)
  ;; (setq org-ref-open-pdf-function 'org-ref-open-pdf-at-point)
  ;; orb will define handlers for note taking so not needed to use the
  ;; ones set for bibtex-completion
  (unless (featurep! :lang org +roam2)
    ;; determine how org ref should handle the users notes path (dir, or file)
    (if (directory-name-p +biblio-notes-path)
        (setq org-ref-notes-directory +biblio-notes-path)
      (setq org-ref-bibliography-notes +biblio-notes-path))
    ;; Allow org-ref to use the same template mechanism as {helm,ivy}-bibtex for
    ;; multiple files if the user has chosen to spread their notes.
    (setq org-ref-notes-function (if (and org-ref-notes-directory (directory-name-p org-ref-notes-directory))
                                     #'org-ref-notes-function-many-files
                                   #'org-ref-notes-function-one-file))))


(use-package! org-roam-bibtex
  :when (featurep! +roam-bibtex)
  :after org-roam
  :preface
  ;; if the user has not set a template mechanism set a reasonable one of them
  ;; The package already tests for nil itself so we define a dummy tester
  (defvar orb-preformat-keywords
    '("=key=" "title" "url" "file" "author-or-editor" "keywords" "citekey" "pdf"))
  ;;:hook (org-roam-mode . org-roam-bibtex-mode)
  :custom
  (orb-note-actions-interface 'default)
  ;; (orb-note-actions-interface (cond ((featurep! :completion ivy)  'ivy)
  ;;                                   ((featurep! :completion helm) 'helm)
  ;;                                   ((t                           'default))))
  :config
  (setq orb-insert-interface 'ivy-bibtex)
  ;; (setq orb-insert-interface (cond ((featurep! :completion ivy)  'ivy-bibtex)
  ;;                                  ((featurep! :completion helm) 'helm-bibtex)
  ;;                                  ;; ((t                           'generic))
  ;;                                  ((t                           'ivy-bibtex))
  ;;                                  ))
  (setq orb-process-file-keyword t
        orb-file-field-extensions '("pdf"))

  (add-to-list 'org-roam-capture-templates
               '("b" "Bibliography note" plain
                 "%?
- keywords :: %^{keywords}
- related ::
\n* %^{title}
:PROPERTIES:
:Custom_ID: %^{citekey}
:URL: %^{url}
:AUTHOR: %^{author-or-editor}
:NOTER_DOCUMENT: %^{file}
:NOTER_PAGE:
:END:\n\n"
                 :if-new (file+head "${=key=}.org" ":PROPERTIES:
:ROAM_REFS: cite:${=key=}
:END:
#+TITLE: ${title}\n")
                 :unnarrowed t))
  (require 'org-ref))

;; (use-package! bibtex-actions
;;   :when (featurep! :completion vertico)
;;   :after embark
;;   :defer t
;;   :config
;; (add-to-list 'embark-keymap-alist '(bibtex . bibtex-actions-map)))

;; (use-package! bibtex-completion
;;   :defer t
;;   :config
;;   (setq bibtex-completion-additional-search-fields '(keywords)
;;         bibtex-completion-pdf-field "file"));; This tell bibtex-completion to look at the File field of the bibtex to figure out which pdf to open

;; (use-package! ivy-bibtex
;;   :when (featurep! :completion ivy)
;;   :defer t
;;   :config
;;   (add-to-list 'ivy-re-builders-alist '(ivy-bibtex . ivy--regex-plus)))

;; (use-package! bibtex-actions
;;   :when (featurep! :completion vertico)
;;   :after embark
;;   :defer t
;;   :config
;;   (add-to-list 'embark-keymap-alist '(bibtex . bibtex-actions-map)))

;; (use-package! citeproc
;;   :defer t)

;; ;;; Org-Cite configuration

;; (use-package! oc
;;   :after org
;;   :config
;;   (setq org-cite-global-bibliography '("~/bib/references.bib"))
;;   ;; setup export processor; default csl/citeproc-el, with biblatex for latex
;;   (setq org-cite-export-processors
;;         '((latex natbib)
;;           (t csl))))

;; (use-package! oc-bibtex-actions
;;   :when (featurep! :completion vertico)
;;   :after (oc bibtex-actions)
;;   :config
;;   (setq org-cite-insert-processor 'oc-bibtex-actions
;;         org-cite-follow-processor 'oc-bibtex-actions))

;;   ;;; Org-cite processors
;; (use-package! oc-basic
;;   :after oc)

;; (use-package! oc-biblatex
;;   :after oc)

;; (use-package! oc-csl
;;   :after oc
;;   :config
;;   ;; REVIEW optional; add to docs instead?
;;   (setq org-cite-csl-styles-dir "~/.local/share/csl/styles")
;;   (setq org-cite-csl-locales-dir "~/.local/share/csl/locales"))

;; (use-package! oc-natbib
;;   :after oc)
