;;; gptel-project-skills.el --- Load .github/ skills & chatmodes as gptel presets -*- lexical-binding: t; -*-

;; Auto-discover .github/chatmodes/ and .github/skills/ in the current project.
;;
;; Chatmodes → gptel presets under project/ namespace (replace :system)
;; Skills    → on-demand context files toggled into gptel-context (buffer-local)
;;
;; Usage:
;;   M-x gptel-project-load-skills   — (re)scan current project
;;   M-x gptel-project-apply-skill   — toggle a skill's files into context
;;   Chatmode presets appear as project/<name> in gptel-menu

(require 'cl-lib)

(defvar gptel-project--loaded-presets nil
  "List of chatmode preset symbols registered by the last `gptel-project-load-skills' call.")

(defvar gptel-project--discovered-skills nil
  "Alist of discovered skills: ((NAME . (:desc DESC :files (FILE ...))) ...).")

(defvar gptel-project-agent-file-names '("AGENTS.md" "AGENT.md")
  "File names to look for when discovering always-on agent instruction files.
VS Code Copilot convention: AGENTS.md at workspace root and subfolders.")

(defvar gptel-project--agent-files-cache (make-hash-table :test 'equal)
  "Cache of discovered agent files, keyed by project root path.")

;;; --- YAML frontmatter parser ------------------------------------------------

(defun gptel-project--parse-frontmatter (file)
  "Parse YAML frontmatter from FILE.
Return (ALIST . BODY) where ALIST has string keys and BODY is the
markdown after the closing `---'."
  (with-temp-buffer
    (insert-file-contents file)
    (goto-char (point-min))
    (if (not (looking-at-p "^---[ \t]*$"))
        (cons nil (buffer-string))
      (forward-line 1)
      (let ((fm-start (point))
            fm-end alist body)
        (if (not (re-search-forward "^---[ \t]*$" nil t))
            (cons nil (buffer-string))
          (setq fm-end (match-beginning 0))
          (setq body (buffer-substring-no-properties
                      (min (1+ (match-end 0)) (point-max))
                      (point-max)))
          ;; Minimal YAML key: value parsing (single-line scalars only)
          (goto-char fm-start)
          (while (re-search-forward
                  "^\\([A-Za-z_-]+\\)[ \t]*:[ \t]*\\(.*\\)$" fm-end t)
            (push (cons (match-string 1)
                        (string-trim (match-string 2) "['\"]" "['\"]"))
                  alist))
          (cons (nreverse alist) body))))))

;;; --- Discovery helpers ------------------------------------------------------

(defun gptel-project--root ()
  "Return the project root directory, or nil."
  (or (and (fboundp 'projectile-project-root)
           (ignore-errors (projectile-project-root)))
      (when-let* ((proj (project-current)))
        (if (fboundp 'project-root)
            (project-root proj)
          (car (project-roots proj))))))

(defun gptel-project--find-chatmodes (root)
  "Return list of chatmode .md files under ROOT/.github/chatmodes/."
  (let ((dir (expand-file-name ".github/chatmodes/" root)))
    (when (file-directory-p dir)
      (directory-files dir t "\\.chatmode\\.md\\'" nil))))

(defun gptel-project--find-skills (root)
  "Return alist ((skill-dir . SKILL.md) ...) under ROOT/.github/skills/."
  (let ((dir (expand-file-name ".github/skills/" root))
        result)
    (when (file-directory-p dir)
      (dolist (d (directory-files dir t "\\`[^.]" nil))
        (when (file-directory-p d)
          (let ((skill-md (expand-file-name "SKILL.md" d)))
            (when (file-readable-p skill-md)
              (push (cons d skill-md) result))))))
    (nreverse result)))

(defun gptel-project--skill-references (skill-dir)
  "Return list of reference files under SKILL-DIR/references/."
  (let ((ref-dir (expand-file-name "references/" skill-dir)))
    (when (file-directory-p ref-dir)
      (directory-files ref-dir t "\\.md\\'" nil))))

;;; --- Chatmode preset registration / cleanup ---------------------------------

(defun gptel-project--unload ()
  "Remove all project chatmode presets and clear discovered skills."
  (when gptel-project--loaded-presets
    (setq gptel--known-presets
          (cl-remove-if (lambda (entry)
                          (memq (car entry) gptel-project--loaded-presets))
                        gptel--known-presets))
    (setq gptel-project--loaded-presets nil))
  (setq gptel-project--discovered-skills nil)
  (clrhash gptel-project--agent-files-cache))

(defun gptel-project--register-chatmode (file)
  "Register a gptel preset for chatmode FILE.
Returns the preset symbol."
  (let* ((parsed (gptel-project--parse-frontmatter file))
         (fm     (car parsed))
         (body   (cdr parsed))
         (basename (file-name-nondirectory file))
         ;; "Planning.chatmode.md" → "Planning"
         (name   (replace-regexp-in-string "\\.chatmode\\.md\\'" "" basename))
         (desc   (or (cdr (assoc "description" fm)) name))
         (sym    (intern (format "project/%s" name))))
    (gptel-make-preset sym
      :description (format "[chatmode] %s" desc)
      :system body)
    sym))

;;; --- Skill discovery --------------------------------------------------------

(defun gptel-project--discover-skill (skill-dir skill-md)
  "Discover a skill at SKILL-DIR with SKILL-MD.
Returns (NAME . (:desc DESC :files (FILE ...))) or nil."
  (let* ((parsed (gptel-project--parse-frontmatter skill-md))
         (fm     (car parsed))
         (name   (or (cdr (assoc "name" fm))
                     (file-name-nondirectory
                      (directory-file-name skill-dir))))
         (desc   (or (cdr (assoc "description" fm)) name))
         (refs   (gptel-project--skill-references skill-dir))
         (files  (cons skill-md refs)))
    (cons name (list :desc desc :files files))))

;;; --- Skill context toggle ---------------------------------------------------

(defun gptel-project--skill-files-in-context-p (files)
  "Return non-nil if all FILES are present in buffer-local `gptel-context'."
  (and gptel-context
       (cl-every (lambda (f)
                   (cl-find f gptel-context
                            :test (lambda (path entry)
                                    (cond
                                     ((stringp entry) (string= path entry))
                                     ((consp entry) (string= path (car entry)))
                                     (t nil)))))
                 files)))

(defun gptel-project--add-skill-to-context (files)
  "Add FILES to buffer-local `gptel-context'."
  (make-local-variable 'gptel-context)
  (dolist (f files)
    (unless (cl-find f gptel-context
                     :test (lambda (path entry)
                             (cond
                              ((stringp entry) (string= path entry))
                              ((consp entry) (string= path (car entry)))
                              (t nil))))
      (push f gptel-context))))

(defun gptel-project--remove-skill-from-context (files)
  "Remove FILES from buffer-local `gptel-context'."
  (when gptel-context
    (setq gptel-context
          (cl-remove-if (lambda (entry)
                          (let ((path (if (consp entry) (car entry) entry)))
                            (and (stringp path)
                                 (member path files))))
                        gptel-context))))

;;; --- AGENTS.md always-on context injection ----------------------------------

(defun gptel-project--discover-agent-files (root)
  "Recursively find all AGENTS.md / AGENT.md files under ROOT.
Returns a list of absolute paths sorted by depth (root-level first)."
  (when (and root (file-directory-p root))
    (let ((cached (gethash root gptel-project--agent-files-cache 'miss)))
      (if (not (eq cached 'miss))
          cached
        (let ((found nil))
          (dolist (name gptel-project-agent-file-names)
            (dolist (f (directory-files-recursively root
                                                    (concat "\\`" (regexp-quote name) "\\'")
                                                    nil t))
              (push f found)))
          ;; Deduplicate and sort by depth (shallowest first)
          (setq found (cl-delete-duplicates found :test #'string=))
          (setq found (sort found
                            (lambda (a b)
                              (< (cl-count ?/ a) (cl-count ?/ b)))))
          (puthash root found gptel-project--agent-files-cache)
          found)))))

(defun gptel-project--inject-agent-context (fsm)
  "Prompt transform: inject all discovered AGENTS.md files into context.
Runs in the prompt temp buffer.  FSM provides the originating buffer."
  (when-let* ((info (gptel-fsm-info fsm))
              (buf  (plist-get info :buffer))
              (root (with-current-buffer buf
                      (gptel-project--root)))
              (files (gptel-project--discover-agent-files root)))
    ;; gptel-context is already buffer-local in the prompt buffer
    (dolist (f files)
      (unless (cl-find f gptel-context
                       :test (lambda (path entry)
                               (cond
                                ((stringp entry) (string= path entry))
                                ((consp entry) (string= path (car entry)))
                                (t nil))))
        (push f gptel-context)))))

;;; --- Public API -------------------------------------------------------------

;;;###autoload
(defun gptel-project-load-skills ()
  "Scan the current project for .github/ skills & chatmodes.
Register chatmodes as gptel presets under the `project/' namespace.
Discover skills for use with `gptel-project-apply-skill'.
Old project presets and skills are cleaned up first."
  (interactive)
  (require 'gptel)
  (gptel-project--unload)
  (if-let* ((root (gptel-project--root)))
      (let (preset-syms skills)
        ;; Chatmodes → presets
        (dolist (f (gptel-project--find-chatmodes root))
          (condition-case err
              (push (gptel-project--register-chatmode f) preset-syms)
            (error (message "gptel-project: failed to load chatmode %s: %s"
                            f (error-message-string err)))))
        ;; Skills → discovered (not presets)
        (dolist (entry (gptel-project--find-skills root))
          (condition-case err
              (when-let* ((skill (gptel-project--discover-skill (car entry) (cdr entry))))
                (push skill skills))
            (error (message "gptel-project: failed to discover skill %s: %s"
                            (cdr entry) (error-message-string err)))))
        (setq gptel-project--loaded-presets (nreverse preset-syms))
        (setq gptel-project--discovered-skills (nreverse skills))
        (message "gptel-project: %d chatmode(s), %d skill(s) from %s"
                 (length gptel-project--loaded-presets)
                 (length gptel-project--discovered-skills)
                 (abbreviate-file-name root)))
    (message "gptel-project: no project root found")))

;;;###autoload
(defun gptel-project-apply-skill (name)
  "Toggle a project skill's files in the current buffer's `gptel-context'.

When called interactively, offer completing-read with skill names
and descriptions.  If the skill is already active (its files are in
context), remove them.  Otherwise, add them."
  (interactive
   (list
    (let* ((skills gptel-project--discovered-skills)
           (names (mapcar #'car skills))
           (max-w (if names (apply #'max (mapcar #'length names)) 0))
           (annotate (lambda (name)
                       (when-let* ((entry (assoc name skills)))
                         (let* ((files (plist-get (cdr entry) :files))
                                (active (gptel-project--skill-files-in-context-p files))
                                (desc (plist-get (cdr entry) :desc)))
                           (concat (make-string (- (+ max-w 2) (length name)) ?\s)
                                   (if active "✓ " "  ")
                                   desc))))))
      (unless skills
        (user-error "No skills discovered. Run `gptel-project-load-skills' first"))
      (completing-read
       "Toggle skill: "
       (lambda (input pred action)
         (if (eq action 'metadata)
             `(metadata (annotation-function . ,annotate))
           (complete-with-action action names input pred)))
       nil t))))
  (let* ((entry (or (assoc name gptel-project--discovered-skills)
                    (user-error "Skill %S not found" name)))
         (files (plist-get (cdr entry) :files))
         (active (gptel-project--skill-files-in-context-p files)))
    (if active
        (progn
          (gptel-project--remove-skill-from-context files)
          (message "Skill [%s] removed from context (%d file(s))" name (length files)))
      (gptel-project--add-skill-to-context files)
      (message "Skill [%s] added to context (%d file(s))" name (length files)))))

;;; --- Auto-load on project switch --------------------------------------------

(defun gptel-project--on-project-switch (&rest _)
  "Hook function: reload project skills when switching projects."
  (when (featurep 'gptel)
    (gptel-project-load-skills)))

;; Doom Emacs: projectile hook
(with-eval-after-load 'projectile
  (add-hook 'projectile-after-switch-project-hook
            #'gptel-project--on-project-switch))

;; Vanilla Emacs 28+: project.el hook
(with-eval-after-load 'project
  (when (boundp 'project-switch-commands)
    (add-hook 'project-switch-hook #'gptel-project--on-project-switch)))

;;; --- AGENTS.md transform registration ----------------------------------------

(defun gptel-project--ensure-agent-transform ()
  "Splice `gptel-project--inject-agent-context' into the transform pipeline.
Inserts just before `gptel--transform-add-context' so agent files
are present when context is serialized."
  (unless (memq 'gptel-project--inject-agent-context
                gptel-prompt-transform-functions)
    (let ((pos (cl-position 'gptel--transform-add-context
                            gptel-prompt-transform-functions)))
      (if pos
          (setq gptel-prompt-transform-functions
                (append (cl-subseq gptel-prompt-transform-functions 0 pos)
                        '(gptel-project--inject-agent-context)
                        (cl-subseq gptel-prompt-transform-functions pos)))
        ;; Fallback: append at end
        (setq gptel-prompt-transform-functions
              (append gptel-prompt-transform-functions
                      '(gptel-project--inject-agent-context)))))))

(with-eval-after-load 'gptel
  (gptel-project--ensure-agent-transform))

(provide 'gptel-project-skills)
;;; gptel-project-skills.el ends here
