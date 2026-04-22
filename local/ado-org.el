;;; ado-org.el --- Org-mode ↔ Azure DevOps via gptel MCP -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Bridge between Org-mode headings and Azure DevOps work items.
;; Uses gptel with Azure DevOps MCP tools for bidirectional sync.
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
;;;; Org link types (stolen from org-azuredevops, adapted for our org)
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
     ;; Full: org/project/repo/id
     ((>= nparts 4)
      (let ((org (mapconcat #'identity (butlast parts 2) "/"))
            (repo (nth (- nparts 2) parts))
            (id (car (last parts))))
        (format "https://dev.azure.com/%s/_git/%s/pullrequest/%s" org repo id)))
     ;; repo/id
     ((= nparts 2)
      (let ((repo (car parts))
            (id (cadr parts))
            (project (or (ado/project-from-file) ado/default-project)))
        (format "https://dev.azure.com/%s/%s/_git/%s/pullrequest/%s"
                ado/org-name project repo id)))
     ;; bare id — need a repo context, just link to project
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

;; workitem:12345  or  workitem:org/project:12345
(org-link-set-parameters
 "workitem"
 :follow (lambda (path) (browse-url (ado/--workitem-url (car (last (split-string path ":"))))))
 :export (lambda (path description format _plist)
           (ado/--export-link "Work Item" (ado/--workitem-url (car (last (split-string path ":"))))
                              description format)))

;; pr:42  or  pr:myrepo/42
(org-link-set-parameters
 "pr"
 :follow (lambda (path) (browse-url (ado/--pr-url path)))
 :export (lambda (path description format _plist)
           (ado/--export-link "PR" (ado/--pr-url path) description format)))

;; build:12345
(org-link-set-parameters
 "build"
 :follow (lambda (path) (browse-url (ado/--build-url path)))
 :export (lambda (path description format _plist)
           (ado/--export-link "Build" (ado/--build-url path) description format)))

;; pipeline:42
(org-link-set-parameters
 "pipeline"
 :follow (lambda (path) (browse-url (ado/--pipeline-url path)))
 :export (lambda (path description format _plist)
           (ado/--export-link "Pipeline" (ado/--pipeline-url path) description format)))

;;;; --------------------------------------------------------------------------
;;;; ADO TODO keywords
;;;; --------------------------------------------------------------------------

(after! org
  ;; Add ADO state sequence alongside existing keywords.
  ;; Existing: (sequence "TODO" "NEXT" "|" "DONE")
  ;;           (sequence "WAIT" "IDEA" "|" "HOLD" "KILL")
  ;; New:
  (add-to-list 'org-todo-keywords
               '(sequence "BKLG(b)" "DEFN(f)" "PROG(p!)" "|" "CMPL(o!)" "ACPT(a!)")
               t) ; append

  ;; Faces for ADO states (cl-union prevents duplicates on re-eval)
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
  "Read #+GITHUB_REPO from current buffer.
Expected format: owner/repo (e.g. AAInternal/topml).
Returns nil if the keyword is absent."
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
           (iteration (org-entry-get nil "ITERATION"))
           (deadline (org-entry-get nil "DEADLINE"))
           ;; Get body text (between property drawer and next heading)
           (body (org-agenda-get-some-entry-text
                  (point-marker) most-positive-fixnum))
           ;; Extract links from the body
           (links '()))
      ;; Collect org links from the subtree
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
            :iteration iteration
            :deadline deadline
            :body body
            :links (nreverse links)
            :project (ado/project-from-file)
            :team (ado/team-from-file)
            :github-repo (ado/github-repo-from-file)))))

;;;; --------------------------------------------------------------------------
;;;; Browse ADO at point (uses link infrastructure above)
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

;;;; --------------------------------------------------------------------------
;;;; Utility commands (stolen from org-jira patterns)
;;;; --------------------------------------------------------------------------

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
  "Copy an org-style workitem link for the heading at point.
Result: [[workitem:12345][Title]]"
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
  "Advance the heading at point to the next ADO state.
Pure elisp — only changes the org TODO keyword, does NOT push to ADO.
Use `ado/update-at-point' to sync to ADO afterwards."
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
;;;; Minor mode: ado-org-mode
;;;; --------------------------------------------------------------------------

(defvar ado-org-mode-map
  (let ((map (make-sparse-keymap)))
    map)
  "Keymap for `ado-org-mode'.")

(define-minor-mode ado-org-mode
  "Minor mode for org files linked to Azure DevOps.
Activated automatically when #+ADO_PROJECT is present."
  :lighter " ADO"
  :keymap ado-org-mode-map
  (when ado-org-mode
    ;; Cache project for link functions
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
;;;; gptel ADO preset
;;;; --------------------------------------------------------------------------

(after! gptel
  (gptel-make-preset 'with-ado
    :description "Azure DevOps Project Manager: create, update, pull, polish work items via MCP."
    :parents 'base-policies
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

<ado_org_mapping>
Org TODO states map to ADO states:
  BKLG → Backlog
  DEFN → Defined
  PROG → In-Progress
  CMPL → Completed
  ACPT → Accepted

Org tags map to ADO work item types:
  :story: → User Story   :task: → Task   :bug: → Bug   :feature: → Feature   :epic: → Epic

Field defaults (when not specified):
  Story Points: 1
  Work Type (Activity): 4. Software / UX

Key ADO fields for User Story (reference names):
  System.AssignedTo                        → :ASSIGNED: property (identity display name)
  System.Description                       → Description (Html)
  Microsoft.VSTS.Common.AcceptanceCriteria → Acceptance Criteria (Html)
  AAIT.Notes                               → Notes (Html)
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
2. Use wit_my_work_items to get MY assigned items in the current iteration
3. For each of my items, use wit_get_work_item with expand=relations to find parent feature IDs
4. Collect the set of parent feature IDs from my items ONLY
5. For each parent feature, fetch ALL child work items (teammates' items) under it
6. Get iteration details from work_list_team_iterations for start/end dates
7. Group items by parent feature
8. Do NOT pull items from features I have no work in — scope is my-features only
9. Output clean org text in the format above
</pulling_work_items>

<creating_work_items>
When asked to create a work item from an org heading:
1. Read the heading context (title, body, tags, properties)
2. Determine work item type from tag or ADO_TYPE property or #+ADO_WIT
3. Set System.AreaPath to match the team:
   - Read #+ADO_TEAM from the buffer (e.g. '" jyun/ado-team "')
   - Set System.AreaPath = '{project}\\{team}' (e.g. '" jyun/ado-project "\\\\" jyun/ado-team "')
   - If no #+ADO_TEAM is set, omit AreaPath and let ADO use the default
4. Set System.AssignedTo:
   - If :ASSIGNED: property exists on the heading, use that value
   - Otherwise default to '" jyun/user-display-name "' (current user)
   - Only omit assignment if explicitly told "unassigned"
5. Use wit_create_work_item with appropriate fields
6. Report back the created ADO ID so the user can set :ADO_ID:
7. If a :PARENT_ID: is specified, use wit_work_items_link to set parent
</creating_work_items>

<updating_work_items>
When asked to update a work item:
1. Read :ADO_ID: from the heading
2. Map org TODO state to ADO state
3. Use wit_update_work_item to push changes
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
1. Use core_get_identity_ids to find the person
2. Use wit_update_work_item to set System.AssignedTo
3. Report the assignment
</assigning_work_items>

<safety_guard>
Before any create, update, or delete operation on a work item:
1. Check the :ASSIGNED: property (or System.AssignedTo from ADO) of the target item
2. If the assignee is NOT '" jyun/user-display-name "' (or unassigned/empty):
   - STOP and warn: '⚠ This item is assigned to {assignee}, not you. Proceed anyway? (yes/no)'
   - Wait for explicit 'yes' before executing the operation
   - If the user says no, abort and suggest alternatives
3. This applies to: wit_create_work_item (when assigning to someone else),
   wit_update_work_item, wit_update_work_items_batch, wit_work_items_link,
   wit_work_item_unlink, wit_add_work_item_comment (warn but don't block comments)
4. Exception: pulling/reading work items never triggers this guard
</safety_guard>

<tone>
Be terse. Report facts. Don't hedge. Format output as valid org-mode.
</tone>")
    :tools
    '(:append (;; Work item read
      "wit_get_work_item" "wit_get_work_items_batch_by_ids" "wit_my_work_items"
      "wit_get_work_items_for_iteration"
      "wit_list_work_item_comments" "wit_list_work_item_revisions"
      "wit_get_work_item_type"
      ;; Work item write
      "wit_create_work_item" "wit_update_work_item" "wit_add_child_work_items"
      "wit_work_items_link" "wit_work_item_unlink"
      "wit_add_work_item_comment" "wit_update_work_items_batch"
      ;; Queries & backlogs
      "wit_get_query" "wit_get_query_results_by_id"
      "wit_list_backlogs" "wit_list_backlog_work_items"
      ;; Iteration & team
      "work_list_team_iterations" "work_list_iterations"
      "work_get_team_settings"
      "core_list_projects" "core_list_project_teams"
      "core_get_identity_ids"
      ;; Reading linked resources
      "convert_to_markdown"))))

(provide 'ado-org)
;;; ado-org.el ends here
