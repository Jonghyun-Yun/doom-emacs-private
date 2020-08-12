;; (setq helm-bibtex-full-frame nil)

;; open zotero pdf in org-ref
(setq org-ref-default-bibliography "~/Zotero/myref.bib"
      org-ref-pdf-directory "~/Zotero/storage/"
      org-ref-bibliography-notes "~/Zotero/refnotes.org")

(setq bibtex-completion-library-path "~/Zotero/storage/"
      bibtex-completion-bibliography org-ref-default-bibliography
      bibtex-completion-notes-path org-ref-bibliography-notes
      bibtex-completion-pdf-field "file"
      bibtex-completion-find-additional-pdfs t)

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

(setq bibtex-completion-pdf-open-function
      (lambda (fpath)
        (call-process "open" nil 0 nil "-a" "Skim" fpath)))

(with-eval-after-load 'org-ref
  (setq org-ref-open-pdf-function 'org-ref-open-pdf-at-point)

  ;; https://github.com/jkitchin/org-ref/blob/master/org-ref.org
  (defun org-ref-open-pdf-at-point ()
    "Open the pdf for bibtex key under point if it exists."
    (interactive)
    (let* ((results (org-ref-get-bibtex-key-and-file))
           (key (car results))
           (pdf-file (car (bibtex-completion-find-pdf key))))
      ;; (pdf-file (car (bibtex-completion-find-pdf-in-field key))))
      (if (file-exists-p pdf-file)
          (org-open-file pdf-file)
        (message "No PDF found for %s" key))))

  ;; Override this function.
  (defun org-ref-open-bibtex-pdf ()
    "Open pdf for a bibtex entry, if it exists.
assumes point is in
the entry of interest in the bibfile.  but does not check that."
    (interactive)
    (save-excursion
      (bibtex-beginning-of-entry)
      (let* ((bibtex-expand-strings t)
             (entry (bibtex-parse-entry t))
             (key (reftex-get-bib-field "=key=" entry))
             (pdf-file (car (bibtex-completion-find-pdf-in-field key))))
        (if (file-exists-p pdf-file)
            (call-process "open" nil 0 nil "-a" "Skim" pdf-file)
          (message "No PDF found for %s" key)))))
  )

;;;; org-skim integration
(use-package org-protocol
  :demand
  :config
  (add-to-list 'org-capture-templates
               '("SA" "Skim Annotation" entry
                 (file+function org-ref-bibliography-notes my-org-move-point-to-capture-skim-annotation)
                 "* %?
:PROPERTIES:
:CREATED: %U
:CITE: cite:%(my-as-get-skim-bibtex-key)
:SKIM_NOTE: %(my-org-mac-skim-get-page)
:SKIM_PAGE: %(my-as-get-skim-page)
:END:
%i\n"
                 :prepend f
                 :empty-lines 1))

  ("GSA" "General Skim Annotation" entry
           (file+function (lambda () (buffer-file-name)) +org-move-point-to-heading)
           "* %?
:PROPERTIES:
:Created: %U
:SKIM_NOTE: %(+org-reference-skim-get-annotation)
:SKIM_PAGE: %(+org-reference-get-skim-page-number)
:END:
%i
%?")
  )


(with-eval-after-load 'org
  (require 'org-mac-link)
  (require 'org-id))

(with-eval-after-load 'org-ref-ivy
;; (with-eval-after-load 'org-ref-helm
  (org-link-set-parameters "skim" :follow #'my-org-mac-skim-open)

  (defun my-org-mac-skim-open (uri)
    "Visit page of pdf in Skim"
    (let* ((note (when (string-match ";;\\(.+\\)\\'" uri) (match-string 1 uri)))
           (page (when (string-match "::\\(.+\\);;" uri) (match-string 1 uri)))
           (document (substring uri 0 (match-beginning 0))))
      (do-applescript
       (concat
        "tell application \"Skim\"\n"
        "activate\n"
        "set theDoc to \"" document "\"\n"
        "set thepage to " page "\n"
        "set theNote to " note "\n"
        "open theDoc\n"
        "go document 1 to page thePage of document 1\n"
        "if theNote is not 0\n"
        "    go document 1 to item theNote of notes of page thePage of document 1\n"
        "    set active note of document 1 to item theNote of notes of page thePage of document 1\n"
        "end if\n"
        "end tell"))))

  ;; (defadvice org-capture-finalize
  ;;     (after org-capture-finalize-after activate)
  ;;   "Advise capture-finalize to close the frame"
  ;;   (if (equal "SA" (org-capture-get :key))
  ;;       (do-applescript "tell application \"Skim\"\n    activate\nend tell")))

  (defun my-as-get-skim-page-link ()
    (do-applescript
     (concat
      "tell application \"Skim\"\n"
      "set theDoc to front document\n"
      "set theTitle to (name of theDoc)\n"
      "set thePath to (path of theDoc)\n"
      "set thePage to (get index for current page of theDoc)\n"
      "set theSelection to selection of theDoc\n"
      "set theContent to (contents of (get text for theSelection))\n"
      "try\n"
      "    set theNote to active note of theDoc\n"
      "end try\n"
      "if theNote is not missing value then\n"
      "    set theContent to contents of (get text for theNote)\n"
      "    set theNotePage to get page of theNote\n"
      "    set thePage to (get index for theNotePage)\n"
      "    set theNoteIndex to (get index for theNote on theNotePage)\n"
      "else\n"
      "    if theContent is missing value then\n"
      "        set theContent to theTitle & \", p. \" & thePage\n"
      "        set theNoteIndex to 0\n"
      "    else\n"
      "        tell theDoc\n"
      "            set theNote to make new note with data theSelection with properties {type:highlight note}\n"
      "            set active note of theDoc to theNote\n"
      "            set text of theNote to (get text for theSelection)\n"
      "            set theNotePage to get page of theNote\n"
      "            set thePage to (get index for theNotePage)\n"
      "            set theNoteIndex to (get index for theNote on theNotePage)\n"
      "            set theContent to contents of (get text for theNote)\n"
      "        end tell\n"
      "    end if\n"
      "end if\n"
      "set theLink to \"skim://\" & thePath & \"::\" & thePage & \";;\" & theNoteIndex & "
      "\"::split::\" & theContent\n"
      "end tell\n"
      "return theLink as string\n")))

  (defun my-as-get-skim-bibtex-key ()
    (let* ((name (do-applescript
                  (concat
                   "tell application \"Skim\"\n"
                   "set theDoc to front document\n"
                   "set theTitle to (name of theDoc)\n"
                   "end tell\n"
                   "return theTitle as string\n")))
           (key (when (string-match "\\(.+\\).pdf" name) (match-string 1 name))))
           ;; (key (when (string= (file-name-extension name) "pdf") (file-name-sans-extension name))))
      key)
    )

  (defun my-as-get-skim-page ()
    (let* ((page (do-applescript
                  (concat
                   "tell application \"Skim\"\n"
                   "set theDoc to front document\n"
                   "set thePage to (get index for current page of theDoc)\n"
                   "end tell\n"
                   "return thePage as string\n"))))
      page))

  (defun my-as-clean-skim-page-link (link)
    (let* ((link (replace-regexp-in-string "\n" " " link))
           (link (replace-regexp-in-string "- " " " link)))
      link))

  (defun my-org-mac-skim-get-page ()
    (interactive)
    (message "Applescript: Getting Skim page link...")
    (org-mac-paste-applescript-links (my-as-clean-skim-page-link (my-as-get-skim-page-link))))

  (defun my-org-mac-skim-insert-page ()
    (interactive)
    (insert (my-org-mac-skim-get-page)))

  (defun my-org-move-point-to-capture ()
    (cond ((org-at-heading-p) (org-beginning-of-line))
          (t (org-previous-visible-heading 1))))

  (defun my-org-ref-find-entry-in-notes (key)
    "Find or create bib note for KEY"
    (let* ((entry (bibtex-completion-get-entry key)))
      (widen)
      (goto-char (point-min))
      (unless (derived-mode-p 'org-mode)
        (error
         "Target buffer \"%s\" for jww/find-journal-tree should be in Org mode"
         (current-buffer)))
      (let* ((headlines (org-element-map
                            (org-element-parse-buffer)
                            'headline 'identity))
             (keys (mapcar
                    (lambda (hl) (org-element-property :CUSTOM_ID hl))
                    headlines)))
        ;; put new entry in notes if we don't find it.
        (if (-contains? keys key)
            (progn
              (org-open-link-from-string (format "[[#%s]]" key))
              (lambda nil
                (cond ((org-at-heading-p)
                       (org-beginning-of-line))
                      (t (org-previous-visible-heading 1))))
              )
          ;; no entry found, so add one
          (goto-char (point-max))
          (insert (org-ref-reftex-format-citation
                   entry (concat "\n" org-ref-note-title-format)))
          (mapc (lambda (x)
                  (save-restriction
                    (save-excursion
                      (funcall x))))
                org-ref-create-notes-hook)
          (org-open-link-from-string (format "[[#%s]]" key))
          (lambda nil
            (cond ((org-at-heading-p)
                   (org-beginning-of-line))
                  (t (org-previous-visible-heading 1))))
          ))
      ))

  (defun my-org-move-point-to-capture-skim-annotation ()
    (let* ((keystring (my-as-get-skim-bibtex-key)))
      (my-org-ref-find-entry-in-notes keystring)
      ))
  )

;; create org-id for skim to org jump
;; (add-hook 'org-capture-prepare-finalize-hook #'(lambda () (my-as-set-skim-org-link (org-id-get-create))))
(add-hook 'org-capture-prepare-finalize-hook #'my-as-set-skim-org-link-hook)

;; do NOT create org-id for gcal.org
(defun my-as-set-skim-org-link-hook ()
  ;; (when (string-equal (car (cdr (org-capture-get :target))) 'org-ref-bibliography-notes)
    ;; (my-as-set-skim-org-link (org-id-get-create)))
  "Create org-id only for org-skim-capture"
    (if (equal "SA" (org-capture-get :key))
        (my-as-set-skim-org-link (org-id-get-create))))

(defun my-as-set-skim-org-link (id)
  (do-applescript (concat
                   "tell application \"Skim\"\n"
                   "set runstatus to \"not set\"\n"
                   "set theDoc to front document\n"
                   "try\n"
                   "    set theNote to active note of theDoc\n"
                   "end try\n"
                   "if theNote is not missing value then\n"
                   "    set newText to text of theNote\n"
                   "    set startpoint to  (offset of \"org-id:{\" in newtext)\n"
                   "    set endpoint to  (offset of \"}:org-id\" in newtext)\n"
                   "    if (startpoint is equal to endpoint) and (endpoint is equal to 0) then\n"
                   "        set newText to text of theNote & \"\norg-id:{\" & "
                   (applescript-quote-string id)
                   " & \"}:org-id\"\n"
                   "        set text of theNote to newText\n"
                   "        return \"set success\"\n"
                   "    end if\n"
                   "end if\n"
                   "end tell\n"
                   "return \"unset\"\n"
                   )))

;;;###autoload
(defun applescript-quote-string (argument)
  "Quote a string for passing as a string to AppleScript."
  (if (or (not argument) (string-equal argument ""))
      "\"\""
    ;; Quote using double quotes, but escape any existing quotes or
    ;; backslashes in the argument with backslashes.
    (let ((result "")
          (start 0)
          end)
      (save-match-data
        (if (or (null (string-match "[^\"\\]" argument))
                (< (match-end 0) (length argument)))
            (while (string-match "[\"\\]" argument start)
              (setq end (match-beginning 0)
                    result (concat result (substring argument start end)
                                   "\\" (substring argument end (1+ end)))
                    start (1+ end))))
        (concat "\"" result (substring argument start) "\"")))))
