;;; ado-org.el --- Org-mode ↔ Azure DevOps via ado-py + gptel MCP -*- lexical-binding: t; -*-

(load! "../local-secrets.el")

;;; Commentary:
;;
;; Bridge between Org-mode headings and Azure DevOps work items.
;; Primary backend: ado-py Python module (deterministic, fast).
;; MCP tools: available as fallback for operations ado-py doesn't cover.
;;
;; Per-file configuration via keywords:
;;   #+ADO_PROJECT: <your-project>
;;   #+ADO_TEAM: <your-team>
;;   #+ADO_WIT: User Story
;;   #+FILETAGS: :ms:
;;
;; Work items are tracked as org headings with properties:
;;   :ADO_ID:, :ADO_URL:, :ADO_TYPE:, :ASSIGNED:,
;;   :STORY_POINTS:, :WORK_TYPE:, :PARENT_FEATURE:, :PARENT_ID:,
;;   :ITERATION:, :ITERATION_START:, :ITERATION_END:

;;; Code:

(require 'org)

;;;; --------------------------------------------------------------------------
;;;; Org link types
;;;; --------------------------------------------------------------------------

(defvar ado/org-name (bound-and-true-p jyun/ado-org)
  "Azure DevOps organization name.")

(defvar ado/default-project (bound-and-true-p jyun/ado-project)
  "Default ADO project. Auto-set from #+ADO_PROJECT when in a buffer.")

(defun ado/--workitem-url (id)
  "Build ADO work item URL for ID."
  (let ((project (or (ado/project-from-file) ado/default-project)))
    (format "https://dev.azure.com/%s/%s/_workitems/edit/%s"
            ado/org-name project id)))

(defun ado/--pr-url (path)
  "Build ADO pull request URL from PATH.
PATH can be: ID, REPO/ID, or ORG/PROJECT/REPO/ID."
  (let* ((parts (split-string path "/"))
         (nparts (length parts)))
    (cond
     ((>= nparts 4)
      (let ((org (mapconcat #'identity (butlast parts 2) "/"))
            (repo (nth (- nparts 2) parts))
            (id (car (last parts))))
        (format "https://dev.azure.com/%s/_git/%s/pullrequest/%s" org repo id)))
     ((= nparts 2)
      (let ((repo (car parts))
            (id (cadr parts))
            (project (or (ado/project-from-file) ado/default-project)))
        (format "https://dev.azure.com/%s/%s/_git/%s/pullrequest/%s"
                ado/org-name project repo id)))
     (t
      (let ((project (or (ado/project-from-file) ado/default-project)))
        (format "https://dev.azure.com/%s/%s/_git/pullrequest/%s"
                ado/org-name project path))))))

(defun ado/--build-url (id)
  "Build ADO build URL for ID."
  (let ((project (or (ado/project-from-file) ado/default-project)))
    (format "https://dev.azure.com/%s/%s/_build/results?buildId=%s"
            ado/org-name project id)))

(defun ado/--pipeline-url (id)
  "Build ADO pipeline URL for ID."
  (let ((project (or (ado/project-from-file) ado/default-project)))
    (format "https://dev.azure.com/%s/%s/_build?definitionId=%s"
            ado/org-name project id)))

(defun ado/--export-link (type url description format)
  "Export a link of TYPE with URL and DESCRIPTION to FORMAT."
  (let ((desc (or description (format "%s %s" type url))))
    (pcase format
      (`html (format "<a href=\"%s\">%s</a>" url desc))
      (`latex (format "\\href{%s}{%s}" url desc))
      (`md (format "[%s](%s)" desc url))
      (`ascii (format "%s (%s)" desc url))
      (_ url))))

(org-link-set-parameters
 "workitem"
 :follow (lambda (path) (browse-url (ado/--workitem-url (car (last (split-string path ":"))))))
 :export (lambda (path description format _plist)
           (ado/--export-link "Work Item" (ado/--workitem-url (car (last (split-string path ":"))))
                              description format)))

(org-link-set-parameters
 "pr"
 :follow (lambda (path) (browse-url (ado/--pr-url path)))
 :export (lambda (path description format _plist)
           (ado/--export-link "PR" (ado/--pr-url path) description format)))

(org-link-set-parameters
 "build"
 :follow (lambda (path) (browse-url (ado/--build-url path)))
 :export (lambda (path description format _plist)
           (ado/--export-link "Build" (ado/--build-url path) description format)))

(org-link-set-parameters
 "pipeline"
 :follow (lambda (path) (browse-url (ado/--pipeline-url path)))
 :export (lambda (path description format _plist)
           (ado/--export-link "Pipeline" (ado/--pipeline-url path) description format)))

;;;; --------------------------------------------------------------------------
;;;; ADO TODO keywords
;;;; --------------------------------------------------------------------------

(after! org
  (add-to-list 'org-todo-keywords
               '(sequence "BKLG(b)" "DEFN(f)" "PROG(p!)" "|" "CMPL(o!)" "ACPT(a!)")
               t)

  (setq org-todo-keyword-faces
        (cl-union '(("BKLG" . (:foreground "#8b8b8b" :weight bold))
                    ("DEFN" . (:foreground "#51afef" :weight bold))
                    ("PROG" . (:foreground "#ECBE7B" :weight bold))
                    ("CMPL" . (:foreground "#98be65" :weight bold))
                    ("ACPT" . (:foreground "#4db5bd" :weight bold)))
                  org-todo-keyword-faces
                  :key #'car :test #'equal)))

;;;; --------------------------------------------------------------------------
;;;; ADO ↔ Org state mapping
;;;; --------------------------------------------------------------------------

(defconst ado/state-org-to-ado
  '(("BKLG" . "Backlog")
    ("DEFN" . "Defined")
    ("PROG" . "In-Progress")
    ("CMPL" . "Completed")
    ("ACPT" . "Accepted"))
  "Mapping from org TODO keywords to ADO work item states.")

(defconst ado/state-ado-to-org
  '(("Backlog"     . "BKLG")
    ("Defined"     . "DEFN")
    ("In-Progress" . "PROG")
    ("Completed"   . "CMPL")
    ("Accepted"    . "ACPT"))
  "Mapping from ADO work item states to org TODO keywords.")

;;;; --------------------------------------------------------------------------
;;;; ADO org tag ↔ work item type mapping
;;;; --------------------------------------------------------------------------

(defconst ado/type-to-tag
  '(("User Story" . "story")
    ("Task"       . "task")
    ("Bug"        . "bug")
    ("Feature"    . "feature")
    ("Epic"       . "epic"))
  "Mapping from ADO work item type to org tag.")

(defconst ado/tag-to-type
  '(("story"   . "User Story")
    ("task"    . "Task")
    ("bug"     . "Bug")
    ("feature" . "Feature")
    ("epic"    . "Epic"))
  "Mapping from org tag to ADO work item type.")

;;;; --------------------------------------------------------------------------
;;;; File-level keyword readers
;;;; --------------------------------------------------------------------------

(defun ado/project-from-file ()
  "Read #+ADO_PROJECT from current buffer."
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^#\\+ADO_PROJECT:[ \t]+\\(.+\\)" nil t)
      (string-trim (match-string 1)))))

(defun ado/team-from-file ()
  "Read #+ADO_TEAM from current buffer."
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^#\\+ADO_TEAM:[ \t]+\\(.+\\)" nil t)
      (string-trim (match-string 1)))))

(defun ado/github-repo-from-file ()
  "Read #+GITHUB_REPO from current buffer."
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^#\\+GITHUB_REPO:[ \t]+\\(.+\\)" nil t)
      (string-trim (match-string 1)))))

(defun ado/wit-from-file ()
  "Read #+ADO_WIT from current buffer, default \"User Story\"."
  (or (save-excursion
        (goto-char (point-min))
        (when (re-search-forward "^#\\+ADO_WIT:[ \t]+\\(.+\\)" nil t)
          (string-trim (match-string 1))))
      "User Story"))

;;;; --------------------------------------------------------------------------
;;;; Heading context extraction
;;;; --------------------------------------------------------------------------

(defun ado/heading-context ()
  "Extract context from the org heading at point for gptel.
Returns a plist with heading info."
  (save-excursion
    (org-back-to-heading t)
    (let* ((heading (org-get-heading t t t t))
           (todo-state (org-get-todo-state))
           (tags (org-get-tags))
           (ado-id (org-entry-get nil "ADO_ID"))
           (ado-type (org-entry-get nil "ADO_TYPE"))
           (assigned (org-entry-get nil "ASSIGNED"))
           (story-points (org-entry-get nil "STORY_POINTS"))
           (work-type (org-entry-get nil "WORK_TYPE"))
           (parent-feature (org-entry-get nil "PARENT_FEATURE"))
           (parent-id (org-entry-get nil "PARENT_ID"))
           (ado-tags (org-entry-get nil "ADO_TAGS"))
           (iteration (org-entry-get nil "ITERATION"))
           (deadline (org-entry-get nil "DEADLINE"))
           (body (org-agenda-get-some-entry-text
                  (point-marker) most-positive-fixnum))
           (links '()))
      (save-restriction
        (org-narrow-to-subtree)
        (goto-char (point-min))
        (while (re-search-forward org-link-any-re nil t)
          (push (match-string 0) links)))
      (list :heading heading
            :todo todo-state
            :tags tags
            :ado-id ado-id
            :ado-type (or ado-type (ado/wit-from-file))
            :assigned assigned
            :story-points (or story-points "1")
            :work-type (or work-type "4. Software / UX")
            :parent-feature parent-feature
            :parent-id parent-id
            :ado-tags ado-tags
            :iteration iteration
            :deadline deadline
            :body body
            :links (nreverse links)
            :project (ado/project-from-file)
            :team (ado/team-from-file)
            :github-repo (ado/github-repo-from-file)))))

;;;; --------------------------------------------------------------------------
;;;; Browse / Copy utilities
;;;; --------------------------------------------------------------------------

(defun ado/browse-at-point ()
  "Open the Azure DevOps work item page for the heading at point."
  (interactive)
  (let ((url (org-entry-get nil "ADO_URL"))
        (ado-id (org-entry-get nil "ADO_ID")))
    (cond
     (url (browse-url url))
     (ado-id (browse-url (ado/--workitem-url ado-id)))
     (t (message "No ADO_ID or ADO_URL at point")))))

(defun ado/copy-id ()
  "Copy the ADO_ID at point to the kill ring."
  (interactive)
  (if-let* ((id (org-entry-get nil "ADO_ID")))
      (progn (kill-new id) (message "Copied ADO ID: %s" id))
    (message "No ADO_ID at point")))

(defun ado/copy-url ()
  "Copy the ADO work item URL at point to the kill ring."
  (interactive)
  (let ((url (org-entry-get nil "ADO_URL"))
        (ado-id (org-entry-get nil "ADO_ID")))
    (cond
     (url (kill-new url) (message "Copied: %s" url))
     (ado-id (let ((u (ado/--workitem-url ado-id)))
               (kill-new u) (message "Copied: %s" u)))
     (t (message "No ADO_ID or ADO_URL at point")))))

(defun ado/copy-link ()
  "Copy an org-style workitem link for the heading at point."
  (interactive)
  (let ((id (org-entry-get nil "ADO_ID"))
        (title (org-get-heading t t t t)))
    (if id
        (let ((link (format "[[workitem:%s][%s]]" id title)))
          (kill-new link)
          (message "Copied: %s" link))
      (message "No ADO_ID at point"))))

(defvar ado/state-sequence '("BKLG" "DEFN" "PROG" "CMPL" "ACPT")
  "ADO state progression order.")

(defun ado/next-state ()
  "Advance the heading at point to the next ADO state (local only)."
  (interactive)
  (let* ((current (org-get-todo-state))
         (pos (cl-position current ado/state-sequence :test #'equal)))
    (cond
     ((null pos)
      (message "Not on an ADO heading (state: %s)" current))
     ((= pos (1- (length ado/state-sequence)))
      (message "Already at final state: %s" current))
     (t
      (let ((next (nth (1+ pos) ado/state-sequence)))
        (org-todo next)
        (message "%s → %s" current next))))))

(defun ado/insert-link ()
  "Insert a [[workitem:ID][Title]] link by prompting for ID."
  (interactive)
  (let* ((id (read-string "ADO work item ID: "))
         (title (read-string (format "Title for #%s (blank to use ID): " id))))
    (insert (format "[[workitem:%s][%s]]"
                    id
                    (if (string-empty-p title) (concat "#" id) title)))))

;;;; --------------------------------------------------------------------------
;;;; ado-py Python bridge
;;;; --------------------------------------------------------------------------

(defvar ado/python-command
  (expand-file-name "~/.conda/envs/gptel/bin/python")
  "Python interpreter from mamba gptel env.")

(defvar ado/python-module-dir
  (expand-file-name "~/.doom.d/local/ado-py")
  "Directory containing the ado_py Python module.")

(defun ado/--check-install ()
  "Verify ado-py is importable. Warn once if not."
  (let ((exit (call-process ado/python-command nil nil nil
                            "-c" "import ado_py")))
    (unless (= exit 0)
      (display-warning 'ado-org
                       (format "ado-py not installed in %s. Run: cd %s && %s -m pip install -e ."
                               ado/python-command ado/python-module-dir ado/python-command)
                       :warning))))

(run-with-idle-timer 3 nil #'ado/--check-install)

(defun ado/--run-python (subcommand &optional json-input extra-args)
  "Run ado_py CLI with SUBCOMMAND.
If JSON-INPUT is non-nil, pipe it to stdin.
EXTRA-ARGS is a list of additional CLI arguments.
Returns parsed JSON as plist/alist, or signals error."
  (let* ((default-directory ado/python-module-dir)
         (args (append (list "-m" "ado_py" subcommand) extra-args))
         (buf (generate-new-buffer " *ado-py*"))
         exit-code result)
    (unwind-protect
        (progn
          (if json-input
              (with-temp-buffer
                (insert json-input)
                (setq exit-code
                      (apply #'call-process-region
                             (point-min) (point-max)
                             ado/python-command
                             nil buf nil args)))
            (setq exit-code
                  (apply #'call-process
                         ado/python-command nil buf nil args)))
          (with-current-buffer buf
            (goto-char (point-min))
            (setq result (buffer-string)))
          (if (= exit-code 0)
              (json-parse-string result :object-type 'alist :array-type 'list)
            ;; Non-zero exit: try to parse a structured error payload
            ;; ({"error_kind":..., "error":..., "suggestions":[...]}) and
            ;; present a friendly message.
            (let ((parsed (ignore-errors
                            (json-parse-string result
                                               :object-type 'alist
                                               :array-type 'list))))
              (if (and parsed (alist-get 'error parsed))
                  (let* ((kind (alist-get 'error_kind parsed))
                         (msg (alist-get 'error parsed))
                         (suggestions (alist-get 'suggestions parsed)))
                    (error "ado-py %s [%s]: %s%s"
                           subcommand
                           (or kind "error")
                           msg
                           (if suggestions
                               (concat "  Suggestions: "
                                       (mapconcat #'identity suggestions ", "))
                             "")))
                (error "ado-py %s failed (exit %d): %s"
                       subcommand exit-code result)))))
      (kill-buffer buf))))

(defun ado/heading-to-json ()
  "Convert heading at point to JSON string for ado_py."
  (save-excursion
    (org-back-to-heading t)
    (let* ((ctx (ado/heading-context))
           (heading (plist-get ctx :heading))
           (parent-id (plist-get ctx :parent-id))
           (story-points (plist-get ctx :story-points))
           (work-type (plist-get ctx :work-type))
           (assigned (plist-get ctx :assigned))
           (ado-tags (plist-get ctx :ado-tags))
           (todo-state (plist-get ctx :todo))
           (team (plist-get ctx :team))
           (project (plist-get ctx :project))
           (description "")
           (acceptance-criteria "")
           (notes ""))
      (save-restriction
        (org-narrow-to-subtree)
        (goto-char (point-min))
        (when (re-search-forward "^\\*+[*/]* +Description *$" nil t)
          (let ((beg (1+ (line-end-position)))
                (end (or (save-excursion
                           (when (re-search-forward "^\\*+[*/]* " nil t)
                             (line-beginning-position)))
                         (point-max))))
            (setq description (string-trim (buffer-substring-no-properties beg end)))))
        (goto-char (point-min))
        (when (re-search-forward "^\\*+[*/]* +Acceptance Criteria *$" nil t)
          (let ((beg (1+ (line-end-position)))
                (end (or (save-excursion
                           (when (re-search-forward "^\\*+[*/]* " nil t)
                             (line-beginning-position)))
                         (point-max))))
            (setq acceptance-criteria (string-trim (buffer-substring-no-properties beg end)))))
        (goto-char (point-min))
        (when (re-search-forward "^\\*+[*/]* +Notes *$" nil t)
          (let ((beg (1+ (line-end-position)))
                (end (or (save-excursion
                           (when (re-search-forward "^\\*+[*/]* " nil t)
                             (line-beginning-position)))
                         (point-max))))
            (setq notes (string-trim (buffer-substring-no-properties beg end))))))
      (let ((obj (list (cons "title" heading)
                       (cons "description" (if (string-empty-p description) heading description))
                       (cons "acceptance_criteria" acceptance-criteria)
                       (cons "parent_id" (when parent-id (string-to-number parent-id)))
                       (cons "story_points" (string-to-number (or story-points "1")))
                       (cons "work_type" (or work-type "4. Software / UX"))
                       (cons "assigned_to" (or assigned "Yun, Jonghyun")))))
        (when todo-state
          (push (cons "state" todo-state) obj))
        (when (and notes (not (string-empty-p notes)))
          (push (cons "notes" notes) obj))
        (when (and ado-tags (not (string-empty-p ado-tags)))
          (push (cons "tags" ado-tags) obj))
        (when team
          (let ((area (format "%s\\%s" (or project ado/default-project) team)))
            (push (cons "area_path" area) obj)))
        (json-encode obj)))))

;;;; --------------------------------------------------------------------------
;;;; Interactive commands — Python-backed
;;;; --------------------------------------------------------------------------

(defun ado/validate-at-point ()
  "Validate the org heading at point against ado_py guardrails."
  (interactive)
  (let* ((json-str (ado/heading-to-json))
         (result (ado/--run-python "validate" json-str)))
    (if (alist-get 'ok result)
        (message "✓ Valid. Ready to push.")
      (message "✗ Validation errors: %s"
               (mapconcat #'identity (alist-get 'errors result) "; ")))))

(defun ado/create-at-point ()
  "Create an ADO work item from the org heading at point.
Validates, pushes, sets :ADO_ID:, :ADO_URL:, :ITERATION:, and DEADLINE."
  (interactive)
  (let* ((json-str (ado/heading-to-json))
         (validation (condition-case err
                         (ado/--run-python "validate" json-str)
                       (error (user-error "Validation failed: %s" (error-message-string err))))))
    (unless (alist-get 'ok validation)
      (user-error "Cannot push — missing fields: %s"
                  (mapconcat #'identity (alist-get 'errors validation) "; ")))
    (let ((result (ado/--run-python "create" json-str)))
      (when (alist-get 'ok result)
        (let* ((item (alist-get 'item result))
               (ado-id (alist-get 'id item))
               (iter-path (alist-get 'iteration_path item)))
          ;; Set core properties
          (org-entry-put nil "ADO_ID" (number-to-string ado-id))
          (org-entry-put nil "ADO_URL" (ado/--workitem-url (number-to-string ado-id)))
          ;; Set iteration info if available
          (when iter-path
            (org-entry-put nil "ITERATION" iter-path))
          ;; Fetch iteration dates and set DEADLINE
          (let ((iter-info (ignore-errors
                             (ado/--run-python "current-iteration" nil nil))))
            (when iter-info
              (let ((finish (alist-get 'finish_date iter-info))
                    (start (alist-get 'start_date iter-info)))
                (when finish
                  (org-deadline nil finish))
                (when start
                  (org-entry-put nil "ITERATION_START" start))
                (when finish
                  (org-entry-put nil "ITERATION_END" finish)))))
          (message "✓ Created ADO #%d" ado-id))))))

(defun ado/fetch-item (item-id)
  "Fetch ADO work item ITEM-ID via ado-py and display as JSON.
With prefix arg, prompt for ID. Otherwise use :ADO_ID: at point."
  (interactive
   (list (or (and (not current-prefix-arg)
                  (org-entry-get nil "ADO_ID"))
             (read-string "ADO work item ID: "))))
  (let ((result (ado/--run-python "fetch" nil
                                  (list "--id" (if (stringp item-id) item-id
                                              (number-to-string item-id))))))
    (with-current-buffer (get-buffer-create "*ado-py-result*")
      (erase-buffer)
      (insert (json-encode result))
      (json-pretty-print-buffer)
      (goto-char (point-min))
      (display-buffer (current-buffer)))
    (message "Fetched #%s: %s" item-id (alist-get 'title result))))

(defun ado/fetch-children (parent-id)
  "Fetch all children of PARENT-ID via ado-py."
  (interactive
   (list (or (org-entry-get nil "ADO_ID")
             (read-string "Parent work item ID: "))))
  (let ((result (ado/--run-python "children" nil
                                  (list "--id" (if (stringp parent-id) parent-id
                                              (number-to-string parent-id))))))
    (with-current-buffer (get-buffer-create "*ado-py-result*")
      (erase-buffer)
      (insert (json-encode result))
      (json-pretty-print-buffer)
      (goto-char (point-min))
      (display-buffer (current-buffer)))
    (message "Fetched %d children of #%s" (length result) parent-id)))

(defun ado/my-items (&optional tag)
  "Fetch my current-iteration items via ado-py.
With prefix arg, prompt for an existing ADO tag to filter by."
  (interactive
   (list (when current-prefix-arg
           (read-string "Filter by ADO tag: "))))
  (let* ((project (or (ado/project-from-file) ado/default-project))
         (team (or (ado/team-from-file) "Muscle Shoals"))
         (args (append (list "--project" project "--team" team)
                       (when (and tag (not (string-empty-p tag)))
                         (list "--tag" tag))))
         (result (ado/--run-python "my-items" nil args)))
    (with-current-buffer (get-buffer-create "*ado-py-result*")
      (erase-buffer)
      (insert (json-encode result))
      (json-pretty-print-buffer)
      (goto-char (point-min))
      (display-buffer (current-buffer)))
    (message "Fetched %d items" (length result))))

(defun ado/current-iteration ()
  "Show the current iteration for the team in the echo area."
  (interactive)
  (let* ((info (condition-case err
                   (ado/--run-python "current-iteration" nil nil)
                 (error (user-error "No current iteration: %s"
                                    (error-message-string err))))))
    (message "Current: %s  [%s → %s]"
             (alist-get 'name info)
             (alist-get 'start_date info)
             (alist-get 'finish_date info))))

(defun ado/next-iteration ()
  "Show the next iteration (after the current one) for the team.
Warns if no current iteration or no iteration is scheduled after it."
  (interactive)
  (let* ((info (condition-case err
                   (ado/--run-python "next-iteration" nil nil)
                 (error (user-error "%s" (error-message-string err))))))
    (message "Next: %s  [%s → %s]"
             (alist-get 'name info)
             (alist-get 'start_date info)
             (alist-get 'finish_date info))))

(defun ado/update-at-point ()
  "Push current heading state to ADO via ado-py update."
  (interactive)
  (let* ((ado-id (org-entry-get nil "ADO_ID"))
         (state (org-get-todo-state))
         (ado-tags (org-entry-get nil "ADO_TAGS")))
    (unless ado-id (user-error "No ADO_ID at point"))
    (let* ((updates (list (cons "state" state)))
           (updates (if (and ado-tags (not (string-empty-p ado-tags)))
                        (append updates (list (cons "tags" ado-tags)))
                      updates))
           (json-str (json-encode updates))
           (result (condition-case err
                       (ado/--run-python "update" json-str
                                         (list "--id" ado-id))
                     (error (user-error "%s" (error-message-string err))))))
      (if (alist-get 'ok result)
          (message "✓ Updated ADO #%s → %s" ado-id state)
        (message "✗ Update failed")))))

(defun ado/list-tags (&optional filter)
  "List existing ADO project tags, optionally filtered by substring FILTER.
Useful to check spelling before attaching a tag."
  (interactive
   (list (when current-prefix-arg
           (read-string "Tag substring filter: "))))
  (let* ((project (or (ado/project-from-file) ado/default-project))
         (args (append (list "--project" project)
                       (when (and filter (not (string-empty-p filter)))
                         (list "--filter" filter))))
         (tags (ado/--run-python "tags" nil args)))
    (with-current-buffer (get-buffer-create "*ado-py-result*")
      (erase-buffer)
      (insert (json-encode tags))
      (json-pretty-print-buffer)
      (goto-char (point-min))
      (display-buffer (current-buffer)))
    (message "%d tag(s)%s" (length tags)
             (if filter (format " matching %S" filter) ""))))

;;;; --------------------------------------------------------------------------
;;;; Minor mode
;;;; --------------------------------------------------------------------------

(defvar ado-org-mode-map
  (let ((map (make-sparse-keymap)))
    map)
  "Keymap for `ado-org-mode'.")

(define-minor-mode ado-org-mode
  "Minor mode for org files linked to Azure DevOps."
  :lighter " ADO"
  :keymap ado-org-mode-map
  (when ado-org-mode
    (setq-local ado/default-project (ado/project-from-file))))

(defun ado/--maybe-enable-mode ()
  "Enable `ado-org-mode' if #+ADO_PROJECT is present."
  (when (and (derived-mode-p 'org-mode)
             (save-excursion
               (goto-char (point-min))
               (re-search-forward "^#\\+ADO_PROJECT:" nil t)))
    (ado-org-mode 1)))

(add-hook 'org-mode-hook #'ado/--maybe-enable-mode)

;;;; --------------------------------------------------------------------------
;;;; gptel ADO preset — Python-first, MCP fallback
;;;; --------------------------------------------------------------------------

(after! gptel
  (gptel-make-preset 'with-ado
    :description "Azure DevOps Project Manager: ado-py primary, MCP fallback."
    :system
    `(:append ,(concat "You are an Azure DevOps Project Manager assistant operating through Org-mode.

<ado_user_context>
Azure DevOps organization: " jyun/ado-org "
User: " jyun/user-display-name " (" jyun/user-email-aa ")
Default project/team: read from #+ADO_PROJECT and #+ADO_TEAM in the org buffer.

My teams:
- Project: " jyun/ado-project ", Team: " jyun/ado-team " (primary)
- Project: " jyun/ado-project ", Team: " jyun/ado-team-secondary "

Collaborating teams (cross-team visibility):
- Project: " jyun/ado-project ", Team: " (nth 0 jyun/ado-collab-teams) "
- Project: " jyun/ado-project ", Team: " (nth 1 jyun/ado-collab-teams) "

Default behavior:
- Show only work items assigned to me unless asked otherwise
- For my teams: include teammates' items only when they share the same parent Feature
- For collaborating teams: show their items when they share a parent Feature I'm working on or have recently worked on
</ado_user_context>

<tool_preference>
PREFER ado-py Python module over MCP tools. ado-py is faster and deterministic.
The user's Emacs has these elisp commands that call ado-py:

  (ado/--run-python SUBCOMMAND &optional JSON-INPUT EXTRA-ARGS)

Available subcommands and their usage:
  validate    — stdin JSON, validates User Story fields
  create      — stdin JSON, creates User Story in ADO (includes parent link)
  fetch       — --id ID, returns work item with relations (children, parent, related IDs)
  fetch-batch — --ids 1,2,3, returns multiple work items
  children    — --id ID, returns all children of a parent work item
  my-items    — --project P --team T [--tag TAG], returns my current-iteration items (optionally filtered by an existing System.Tags value)
  update      — --id ID + stdin JSON, updates work item fields
  link        — --source S --target T --type parent|child|related
  current-iteration — returns current iteration path/name/start/finish dates
  next-iteration    — returns the iteration after the current one; errors if none exists
  tags              — --filter SUBSTR, lists existing project tags (to verify spelling before attaching)

<tag_handling>
ADO tags must already EXIST — the user cannot create new tags.
When attaching a tag (via create or update with a \"tags\" field):
- If it fails with error_kind \"tag_permission\", this is a PERMISSION issue (NOT auth/network).
  Tell the user the tag does not exist and they lack permission to create it.
- The error payload includes a \"suggestions\" list of similar existing tags (possible typo fixes).
  Surface these suggestions and ask which existing tag they meant.
- Use the `tags` subcommand to look up valid existing tags, e.g.
  (ado/--run-python \"tags\" nil (list \"--project\" \"PROJECT\" \"--filter\" \"DR\"))
- Distinguish error_kind values: auth (bad/expired PAT), network (connectivity),
  permission/tag_permission (access), notfound (404), api (other).
</tag_handling>

When you need to call ADO, prefer using these Emacs Lisp tool calls:
  (ado/--run-python \"fetch\" nil (list \"--id\" \"2655846\"))
  (ado/--run-python \"children\" nil (list \"--id\" \"2655846\"))
  (ado/--run-python \"my-items\" nil (list \"--project\" \"OperationsResearch_AdvancedAnalytics\" \"--team\" \"Muscle Shoals\"))
  (ado/--run-python \"create\" \"{\\\"title\\\": \\\"...\\\", ...}\")
  (ado/--run-python \"update\" \"{\\\"state\\\": \\\"PROG\\\"}\" (list \"--id\" \"12345\"))
  (ado/--run-python \"link\" nil (list \"--source\" \"123\" \"--target\" \"456\" \"--type\" \"parent\"))

Use MCP ADO tools ONLY for operations ado-py doesn't cover:
- Iteration listing (work_list_team_iterations)
- WIQL queries beyond my-items
- Backlog/board views
- Identity lookups (core_get_identity_ids)
- Adding comments (wit_add_work_item_comment)
- Unlinking (wit_work_item_unlink)

ado-py advantages:
- fetch returns relations (children/parent/related IDs) in one call — no need for separate expand=relations MCP call
- create includes parent link automatically via parent_id field — no separate link call needed
- Batch fetch via fetch-batch or children — fewer round trips
</tool_preference>

<ado_org_mapping>
Org TODO states map to ADO states:
  BKLG → Backlog
  DEFN → Defined
  PROG → In-Progress
  CMPL → Completed
  ACPT → Accepted

Org tags map to ADO work item types:
  :story: → User Story   :task: → Task   :bug: → Bug   :feature: → Feature   :epic: → Epic

ADO System.Tags (labels like 'DR') are DISTINCT from work item type tags.
They are stored in the :ADO_TAGS: property (semicolon-separated), NOT as org tags.
You can attach EXISTING tags only — do not attempt to create new tags.

Field defaults (when not specified):
  Story Points: 1
  Work Type: 4. Software / UX

Key ADO fields for User Story (reference names):
  System.AssignedTo                        → :ASSIGNED: property (identity display name)
  System.Description                       → Description (Html)
  Microsoft.VSTS.Common.AcceptanceCriteria → Acceptance Criteria (Html)
  AAIT.Notes                               → Notes (Html)
  AAIT.WorkType                            → :WORK_TYPE: property (required; default '4. Software / UX')
  Microsoft.VSTS.Scheduling.StoryPoints    → :STORY_POINTS: property (required; default 1)
</ado_org_mapping>

<org_heading_format>
Output raw org-mode text — NEVER wrap in #+begin_src / #+end_src or code fences.
Place the output directly below the user's current org heading.

Heading levels are RELATIVE to the heading the user is on:
  Current heading level = N  (detect from context, e.g. * = 1, ** = 2)
  Parent features  → level N+1
  Child work items → level N+2
  Subsections      → level N+3

Example when user is on a level-1 heading (* Sprint):

** Feature: {feature title}                                      :feature:
   :PROPERTIES:
   :ADO_ID:         {id}
   :ADO_URL:        https://dev.azure.com/{ado-org}/{project}/_workitems/edit/{id}
   :ADO_TYPE:       Feature
   :ASSIGNED:       {display name from ADO}
   :END:

*** {ADO_STATE_AS_ORG_KEYWORD} {title}                           :{type_tag}:
    DEADLINE: <{iteration_end_date}>
    :PROPERTIES:
    :ADO_ID:           {id}
    :ADO_URL:          https://dev.azure.com/{ado-org}/{project}/_workitems/edit/{id}
    :ADO_TYPE:         {work item type}
    :ASSIGNED:         {display name}
    :STORY_POINTS:     {story points, default 1}
    :WORK_TYPE:        {activity, default 4. Software / UX}
    :PARENT_FEATURE:   {parent feature title}
    :PARENT_ID:        {parent feature id}
    :ADO_TAGS:         {System.Tags, semicolon-separated; omit if empty}
    :ITERATION:        {iteration path}
    :ITERATION_START:  {iteration start date YYYY-MM-DD}
    :ITERATION_END:    {iteration end date YYYY-MM-DD}
    :END:

**** Description
     {System.Description, converted from HTML to plain text/org markup}

**** Acceptance Criteria
     {Microsoft.VSTS.Common.AcceptanceCriteria, converted from HTML to plain text/org markup}

**** Notes
     {AAIT.Notes, converted from HTML to plain text/org markup}

Rules:
- Map ADO state to org keyword using the mapping above
- DEADLINE uses the iteration end date in org timestamp format: <YYYY-MM-DD Day>
- Do NOT set SCHEDULED — that is the user's personal plan date
- Group items by parent feature
- Only pull items from features the user has work in (my-features scope)
- Tags are lowercase, single word: :story: :task: :bug: :feature: :epic:
- Dates in properties use YYYY-MM-DD format (plain, not org timestamp)
- Omit a subsection (Description/Acceptance Criteria/Notes) if the ADO field is empty
- When creating/updating work items, map these subsections back to their ADO fields
- If there is no discernible current heading, default to N=0 (features at *, stories at **, etc.)
</org_heading_format>

<pulling_work_items>
When asked to pull work items:
1. Always use project=" jyun/ado-project ", team=" jyun/ado-team "
2. Call (ado/--run-python \"my-items\") to get my assigned items
3. For each of my items, parent_id is already in the response — no extra fetch needed
4. Collect the set of parent feature IDs from my items ONLY
5. For each parent feature, call (ado/--run-python \"children\" nil (list \"--id\" \"PARENT_ID\")) to get ALL siblings
6. For iteration dates, use MCP work_list_team_iterations (ado-py doesn't cover this)
7. Group items by parent feature
8. Do NOT pull items from features I have no work in — scope is my-features only
9. Output clean org text in the format above
</pulling_work_items>

<creating_work_items>
When asked to create a work item from an org heading:
1. Read the heading context (title, body, tags, properties)
2. Build JSON with: title, description, acceptance_criteria, parent_id, story_points, work_type, assigned_to, area_path
3. Call (ado/--run-python \"create\" JSON-STRING) — this handles parent linking automatically
4. Report back the created ADO ID so the user can set :ADO_ID:
5. No separate link call needed — ado-py create includes parent relation
</creating_work_items>

<updating_work_items>
When asked to update a work item:
1. Read :ADO_ID: from the heading
2. Build JSON with changed fields (state accepts org keywords like PROG)
3. Call (ado/--run-python \"update\" JSON-STRING (list \"--id\" \"ADO_ID\"))
4. Confirm what was updated
</updating_work_items>

<polishing_work_items>
When asked to polish/review a work item:
1. Read the heading, body, and linked resources
2. Use convert_to_markdown to fetch and read each linked URL
3. Assess: Is the description clear? Are acceptance criteria defined?
   Are linked resources sufficient? Is it ready to move from BACKLOG → DEFINED?
4. Provide a concise assessment with specific suggestions
5. If ready, say so. If not, list what's missing.
</polishing_work_items>

<assigning_work_items>
When asked to assign a work item:
1. Use MCP core_get_identity_ids to find the person (ado-py doesn't cover identity lookup)
2. Call (ado/--run-python \"update\" \"{\\\"assigned_to\\\": \\\"Name\\\"}\" (list \"--id\" \"ADO_ID\"))
3. Report the assignment
</assigning_work_items>

<safety_guard>
Before any create, update, or delete operation on a work item:
1. Check the :ASSIGNED: property (or assigned_to from ado-py fetch) of the target item
2. If the assignee is NOT '" jyun/user-display-name "' (or unassigned/empty):
   - STOP and warn: '⚠ This item is assigned to {assignee}, not you. Proceed anyway? (yes/no)'
   - Wait for explicit 'yes' before executing the operation
   - If the user says no, abort and suggest alternatives
3. Exception: pulling/reading work items never triggers this guard
</safety_guard>

<tone>
Be terse. Report facts. Don't hedge. Format output as valid org-mode.
</tone>")
      )
    :tools
    `(:append (;; MCP tools — only for operations ado-py doesn't cover
      ;; Iteration & team settings
      "work_list_team_iterations" "work_list_iterations"
      "work_get_team_settings"
      ;; Project/team discovery
      "core_list_projects" "core_list_project_teams"
      "core_get_identity_ids"
      ;; Comments (ado-py doesn't cover yet)
      "wit_add_work_item_comment"
      ;; Queries & backlogs
      "wit_get_query" "wit_get_query_results_by_id"
      "wit_list_backlogs" "wit_list_backlog_work_items"
      ;; Unlink (ado-py doesn't cover yet)
      "wit_work_item_unlink"
      ;; Reading linked resources
      "convert_to_markdown")))
)

;;;; --------------------------------------------------------------------------
;;;; Keybindings
;;;; --------------------------------------------------------------------------

(when (boundp 'ado-org-mode-map)
  (define-key ado-org-mode-map (kbd "C-c a v") #'ado/validate-at-point)
  (define-key ado-org-mode-map (kbd "C-c a c") #'ado/create-at-point)
  (define-key ado-org-mode-map (kbd "C-c a f") #'ado/fetch-item)
  (define-key ado-org-mode-map (kbd "C-c a C") #'ado/fetch-children)
  (define-key ado-org-mode-map (kbd "C-c a m") #'ado/my-items)
  (define-key ado-org-mode-map (kbd "C-c a I") #'ado/current-iteration)
  (define-key ado-org-mode-map (kbd "C-c a N") #'ado/next-iteration)
  (define-key ado-org-mode-map (kbd "C-c a t") #'ado/list-tags)
  (define-key ado-org-mode-map (kbd "C-c a s") #'ado/update-at-point)
  (define-key ado-org-mode-map (kbd "C-c a b") #'ado/browse-at-point)
  (define-key ado-org-mode-map (kbd "C-c a y") #'ado/copy-id)
  (define-key ado-org-mode-map (kbd "C-c a u") #'ado/copy-url)
  (define-key ado-org-mode-map (kbd "C-c a l") #'ado/copy-link)
  (define-key ado-org-mode-map (kbd "C-c a n") #'ado/next-state)
  (define-key ado-org-mode-map (kbd "C-c a i") #'ado/insert-link))

(provide 'ado-org)
;;; ado-org.el ends here
