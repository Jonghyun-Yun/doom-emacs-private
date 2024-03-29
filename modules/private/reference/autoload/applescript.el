;;; private/reference/autoload/applescript.el -*- lexical-binding: t; -*-
;;;###if IS-MAC

;;;###autoload
(defun +reference/org-mac-skim-open (uri)
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

;;;###autoload
(defun +reference/append-org-id-to-skim-hook ()
  "NOT to create org-id for gcal.org. Create org-id only for org-skim-capture"
  (require 'org-id)
  (if (or (equal "SA" (org-capture-get :key))
          (equal "GSA" (org-capture-get :key)))
      (+reference/append-org-id-to-skim (org-id-get-create))))

;;;###autoload
(defun +reference/append-org-id-to-skim (id)
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
(defun +reference/get-skim-page-link ()
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

;;;###autoload
(defun +reference/skim-get-bibtex-key ()
  (let* ((name (do-applescript
                (concat
                 "tell application \"Skim\"\n"
                 "set theDoc to front document\n"
                 "set theTitle to (name of theDoc)\n"
                 "end tell\n"
                 "return theTitle as string\n")))
         ;; (key (when (string-match "\\(.+\\).pdf" name) (match-string 1 name))))
         (key (when (string-match ".\\(.+\\).pdf" name) (match-string 1 name)))) ;; otherwise extract "key instead of key
    key)
  )

;;;###autoload
(defun +reference/get-skim-page-number ()
  (let* ((page (do-applescript
                (concat
                 "tell application \"Skim\"\n"
                 "set theDoc to front document\n"
                 "set thePage to (get index for current page of theDoc)\n"
                 "end tell\n"
                 "return thePage as integer\n"))))
    (cond ((integerp page)
           (int-to-string page))
          ((numberp page)
           (number-to-string page))
          ((stringp page) page))))

;;;###autoload
(defun +reference/clean-skim-page-link (link)
  (let* ((link (replace-regexp-in-string "\n" " " link))
         (link (replace-regexp-in-string "- " " " link)))
    link))

;;;###autoload
(defun +reference/skim-get-annotation ()
  (interactive)
  (message
   "Applescript: Getting Skim page link...")
  (org-mac-link-paste-applescript-links
   (+reference/clean-skim-page-link
    (+reference/get-skim-page-link))))

;;;###autoload
(defun +reference/org-mac-skim-insert-page ()
  (interactive)
  (insert
   (+reference/skim-get-annotation)))

;;;###autoload
(defun +reference/org-ref-find-entry-in-notes (key)
  "Find or create bib note for KEY"
  (let* ((entry (bibtex-completion-get-entry
                 key)))
    (widen)
    (goto-char (point-min))
    (unless (derived-mode-p 'org-mode)
      (error
       "Target buffer \"%s\" for jww/find-journal-tree should be in Org mode"
       (current-buffer)))
    (let* ((headlines (org-element-map
                          (org-element-parse-buffer)
                          'headline
                        'identity))
           (keys (mapcar
                  (lambda (hl)
                    (org-element-property
                     :CUSTOM_ID hl))
                  headlines)))
      ;; put new entry in notes if we don't find it.
      (if (-contains? keys key)
          (progn
            (org-link-open-from-string
             (format "[[#%s]]" key))
            (lambda nil
              (cond ((org-at-heading-p)
                     (org-beginning-of-line))
                    (t
                     (org-previous-visible-heading
                      1)))))
        ;; no entry found, so add one
        (goto-char (point-max))
        (insert
         (org-ref-reftex-format-citation
          entry
          (concat
           "\n"
           org-ref-note-title-format)))
        (mapc
         (lambda (x)
           (save-restriction
             (save-excursion (funcall x))))
         org-ref-create-notes-hook)
        (org-link-open-from-string
         (format "[[#%s]]" key))
        (lambda nil
          (cond ((org-at-heading-p)
                 (org-beginning-of-line))
                (t
                 (org-previous-visible-heading
                  1))))))))

;;;###autoload
(defun +reference/org-move-point-to-capture-skim-annotation ()
  (let* ((keystring (+reference/skim-get-bibtex-key)))
    (+reference/org-ref-find-entry-in-notes
     keystring)))

;;;###autoload
(defun +reference/orb-find-entry-in-notes (key)
  "Find or create bib note for KEY"
  (let* ((entry (bibtex-completion-get-entry
                 key)))
    (widen)
    (goto-char (point-min))
    (unless (derived-mode-p 'org-mode)
      (error
       "Target buffer \"%s\" for jww/find-journal-tree should be in Org mode"
       (current-buffer)))
    (let* ((headlines (org-element-map
                          (org-element-parse-buffer)
                          'headline
                        'identity))
           )
      ;; put new entry in notes if we don't find it.
      ;; disabled for org-roam-bibtex associated with org-roam V2
      ;; (progn
      ;;   (org-link-open-from-string
      ;;    (format "[[#%s]]" key))
      ;;   (lambda nil
      ;;     (cond ((org-at-heading-p)
      ;;            (org-beginning-of-line))
      ;;           (t
      ;;            (org-previous-visible-heading
      ;;             1)))))
      )))

;;;###autoload
(defun +reference/org-roam-bibtex-move-point-to-capture-skim-annotation ()
  (let* ((keystring (+reference/skim-get-bibtex-key)))
    (+reference/orb-find-entry-in-notes
     keystring)))
