;;; private/reference/config.el -*- lexical-binding: t; -*-

;;; org-ref V3
(after! org-ref-ivy
  (setq org-ref-insert-link-function 'org-ref-insert-link-hydra/body
        org-ref-insert-cite-function 'org-ref-cite-insert-ivy
        org-ref-insert-label-function 'org-ref-insert-label-link
        org-ref-insert-ref-function 'org-ref-insert-ref-link
        org-ref-cite-onclick-function (lambda (_) (org-ref-citation-hydra/body)))
  )

(after! org-capture
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

(after! org
  ;; (require 'org-mac-link)
  ;; (require 'org-id)

  (org-link-set-parameters "skim" :follow #'+reference/org-mac-skim-open)

  ;; create org-id for skim to org jump
  (add-hook 'org-capture-prepare-finalize-hook #'+reference/append-org-id-to-skim-hook)
  )
