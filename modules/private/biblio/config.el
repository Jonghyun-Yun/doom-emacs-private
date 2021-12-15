;;; tools/biblio/config.el -*- lexical-binding: t; -*-

;; Internal function to set the various paths used in the
;; reference packages.
(defun +biblio-set-paths-fn (&optional symbol value)
  (when symbol
    (set-default symbol value))
  (when value
    (cond ((eq symbol '+biblio-pdf-library-dir)
           (setq bibtex-completion-library-path value))
          ((eq symbol '+biblio-default-bibliography-files)
           (when (featurep! :lang org)
             (setq reftex-default-bibliography value))
           (setq bibtex-completion-bibliography value))
          ((eq symbol '+biblio-notes-path)
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

  ;; determine how org ref should handle the users notes path (dir, or file)
  (setq bibtex-completion-notes-path +biblio-notes-path)
  ;; orb will define handlers for note taking so not needed to use the
  ;; ones set for bibtex-completion
  (unless (featurep! :lang org +roam2)
    (unless bibtex-completion-notes-template-multiple-files
      (setq bibtex-completion-notes-template-multiple-files
            "${title} : (${=key=})

- tags ::
- keywords :: ${keywords}
\n* ${title}\n  :PROPERTIES:\n  :Custom_ID: ${=key=}\n  :URL: ${url}\n  :AUTHOR: ${author-or-editor}\n  :NOTER_DOCUMENT: /${file}\n  :NOTER_PAGE: \n  :END:\n\n")))
  (when (featurep! :lang org +roam2)
    (setq bibtex-completion-notes-path +biblio-notes-path)
    (setq bibtex-completion-edit-notes-function 'orb-edit-notes-default)
    (defun orb-edit-notes-default (keys)
      "Open the notes associated with the entries in KEYS.
Creates new notes where none exist yet."
      (dolist (key keys)
        (orb-org-ref-edit-note key))))
  (cond
   (IS-MAC
    (setq bibtex-completion-pdf-open-function
          (lambda (fpath)
            ;; (async-start-process "open" "open" nil fpath) ;; system default
            (async-start-process "open" "open" nil "-a" "Skim" fpath) ;; skim
            ;; (call-process "open" nil 0 nil "-a" "Skim" fpath) ;; skim
            )))
   (IS-LINUX
    (setq bibtex-completion-pdf-open-function
          (lambda (fpath)
            (async-start-process "open-pdf" "/usr/bin/xdg-open" nil fpath)))))

  ;; (setq bibtex-completion-pdf-open-function 'find-file) ;; using pdf-tools

  (setq bibtex-completion-display-formats
        '((article       . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${journal:40}")
          (inbook        . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
          (incollection  . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
          (inproceedings . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
          (t             . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*}"))))


;; TODO which set of keys that should be bound for commonly used functions
;; see https://github.com/jkitchin/org-ref/blob/master/org-ref-core.el#L3998
(use-package! org-ref
  ;; :when (featurep! :lang org)
  :after org
  ;; :preface
  ;; This need to be set before the package is loaded, because org-ref will
  ;; automatically `require' an associated package during its loading.
  ;; (setq org-ref-completion-library (cond ((featurep! :completion ivy)  #'org-ref-ivy-cite)
  ;;                                        ((featurep! :completion helm) #'org-ref-helm-bibtex)
  ;;                                        (t                            #'org-ref-reftex)))
  ;; (setq org-ref-completion-library #'org-ref-ivy-cite)
  ;; (require 'org-ref-ivy-cite)
  ;; :bind*
  ;; ([remap org-remove-file] . org-ref-insert-link)
  :init
  ;; (define-key org-mode-map (kbd "C-c ]") 'org-ref-insert-link)
  (map!
   (:map org-mode-map
    :g "C-c ]" #'org-ref-insert-link
    (:prefix-map ("C-c [" . "agenda-file")
     "[" #'org-agenda-file-to-front
     "]" #'org-remove-file))))

(use-package! org-roam-bibtex
  :when (featurep! +roam-bibtex)
  :after org-roam
  :preface
  ;; if the user has not set a template mechanism set a reasonable one of them
  ;; The package already tests for nil itself so we define a dummy tester
  (setq orb-preformat-keywords
    '("=key=" "title" "url" "file" "author-or-editor" "keywords" "citekey" "pdf"))
  ;; - org-ref-v2: Old Org-ref cite:links
  ;; - org-ref-v3: New Org-ref cite:&links
  ;; - org-cite  : Org-cite @elements
  (setq orb-roam-ref-format 'org-ref-v3)
  :custom
  (orb-note-actions-interface (cond ((featurep! :completion ivy)  'ivy)
                                    ((featurep! :completion helm) 'helm)
                                    (t                           'default)))
  :config
  ;; https://github.com/org-roam/org-roam-bibtex/blob/master/doc/orb-manual.org
  ;; (setq orb-note-actions-interface 'hydra)

  ;; (setq orb-insert-interface 'generic)
  (setq orb-insert-interface (cond ((featurep! :completion ivy)  'ivy-bibtex)
                                   ((featurep! :completion helm) 'helm-bibtex)
                                   (t                           'generic)))
  (setq orb-process-file-keyword t
        orb-attached-file-extensions '("pdf"))

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

(use-package! citeproc :defer t)
;; https://github.com/andras-simonyi/citeproc-org
;; looks like i don't need this
(use-package! citeproc-org
  :commands (citeproc-org-setup))

;;; `org-cite'

(use-package! oc
  :defer t
  :config
  (setq org-cite-global-bibliography
        (doom-enlist
         (or (bound-and-true-p citar-bibliography)
             (bound-and-true-p bibtex-completion-bibliography)))
        ;; Setup export processor; default csl/citeproc-el, with biblatex for
        ;; latex
        org-cite-export-processors '((latex biblatex) (t csl))
        org-support-shift-select t))

(use-package! citar
  :when (featurep! :completion vertico)
  :no-require
  :config
  (setq org-cite-insert-processor 'citar
        org-cite-follow-processor 'citar
        org-cite-activate-processor 'citar)
  (when (featurep! :lang org +roam2)
    ;; Include property drawer metadata for 'org-roam' v2.
    (setq citar-file-note-org-include '(org-id org-roam-ref))
    (setq citar-open-note-function 'orb-citar-edit-note))
  ;; to have the Embark menu open with org-open-at-point
  (setq citar-at-point-function 'embark-act)
  )

;; `org-cite' processors
(use-package! oc-biblatex :after oc)
(use-package! oc-csl :after oc)
(use-package! oc-natbib :after oc)
