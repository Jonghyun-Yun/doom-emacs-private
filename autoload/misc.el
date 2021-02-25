;;; ~/.doom.d/autoload/misc.el -*- lexical-binding: t; -*-

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


;; browse rendered html
;;;###autoload
(defun jyun/browse-rendered-html ()
  "Open a rendered html file associated with the buffer."
  (interactive)
  (setq file-to-open (format "file://%s.html" (file-name-sans-extension buffer-file-name)))
  (browse-url file-to-open))


;; Ediff the init.example.el and my init.el
;;;###autoload
(defun ediff-init-files ()
  (interactive)
  (ediff-files (expand-file-name "init.el" doom-private-dir)
               (expand-file-name "init.example.el" user-emacs-directory)))


;;; to run jabber.el in emacs 27+
;;;###autoload
(defun assoc-ignore-case (KEY LIST)
  "This function is obsolete since 22.1;
  use `assoc-string' instead.

  Like `assoc', but ignores differences in case and text representation.
  KEY must be a string. Upper-case and lower-case letters are treated as equal.
  Unibyte strings are converted to multibyte for comparison."
  (assoc-string KEY LIST))


;;;###autoload
(defun jyun/persp-add-buffer (orig-fun &rest args)
  "Apply a function and and add the opened buffer name to the perspective."
  (progn
    (apply orig-fun args)
    (let ((bname (buffer-name)))
      (persp-add-buffer bname))))

  

;;;###autoload
(defun jyun/find-file-in-private-config ()
  "Search for a file in `doom-private-dir' using `find-file-in-project'."
  (interactive)
  ;; (let* ((ffip-project-root "~/.doom.d/"))
  ;; (let* ((ffip-project-root doom-private-dir))
  (let* ((default-directory doom-private-dir))
    (find-file-in-project nil)))


;;;###autoload
(defun spacemacs/jabber-connect-hook (jc)
  (jabber-send-presence "" "Online" 10)
  (jabber-whitespace-ping-start)
  ;; Disable the minibuffer getting jabber messages when active
  ;; See http://www.emacswiki.org/JabberEl
  (define-jabber-alert echo "Show a message in the echo area"
    (lambda (msg &optional title)
      (unless (minibuffer-prompt)
        (message "%s" (or title msg))))))

;;;###autoload
(defun jyun/thin-all-faces ()
  "Change all faces to be lighter."
  (mapc
   (lambda (face)
     (when (eq (face-attribute face :weight) 'light)
       (set-face-attribute face nil :weight 'extra-light))
     (when (eq (face-attribute face :weight) 'semi-light)
       (set-face-attribute face nil :weight 'light))
     (when (eq (face-attribute face :weight) 'normal)
       (set-face-attribute face nil :weight 'semi-light))
     (when (eq (face-attribute face :weight) 'semi-bold)
       (set-face-attribute face nil :weight 'normal))
     (when (eq (face-attribute face :weight) 'bold)
       (set-face-attribute face nil :weight 'semi-bold)))

   (face-list)))


;;;###autoload
(defun jyun/thick-all-faces ()
  "Change all faces to be bolder."
  (mapc
   (lambda (face)
     (when (eq (face-attribute face :weight) 'extra-light)
       (set-face-attribute face nil :weight 'light))
     (when (eq (face-attribute face :weight) 'light)
       (set-face-attribute face nil :weight 'semi-light))
     (when (eq (face-attribute face :weight) 'semi-light)
       (set-face-attribute face nil :weight 'normal))
     (when (eq (face-attribute face :weight) 'normal)
       (set-face-attribute face nil :weight 'semi-bold))
     (when (eq (face-attribute face :weight) 'semi-bold)
       (set-face-attribute face nil :weight 'bold)))

   (face-list)))


;;;###autoload
(defun jyun/thin-variable-pitch-faces ()
  "Change variable pitch faces to be lighter."
  ;; (setq variable-pitch-faces nil)
  (let ((variable-pitch-faces nil)
        (all-faces (face-list)))
    (dolist (face all-faces)
      (unless (memq face mixed-pitch-fixed-pitch-faces)
        (add-to-list 'variable-pitch-faces face))))
  (mapc
   (lambda (face)
     (when (eq (face-attribute face :weight) 'light)
       (set-face-attribute face nil :weight 'extra-light))
     (when (eq (face-attribute face :weight) 'semi-light)
       (set-face-attribute face nil :weight 'light))
     (when (eq (face-attribute face :weight) 'normal)
       (set-face-attribute face nil :weight 'semi-light))
     (when (eq (face-attribute face :weight) 'semi-bold)
       (set-face-attribute face nil :weight 'normal))
     (when (eq (face-attribute face :weight) 'bold)
       (set-face-attribute face nil :weight 'semi-bold)))

   (face-list)))


;;;###autoload
(defun jyun/find-variable-pitch-faces ()
  "Create a list named `variable-pitch-faces'."
  (setq variable-pitch-faces nil)
  (let ((all-faces (face-list)))
    (dolist (face all-faces)
      (unless (memq face mixed-pitch-fixed-pitch-faces)
        (add-to-list 'variable-pitch-faces face)))))


;;;###autoload
(defun jethro/enable-smerge-maybe ()
  "Auto-enable `smerge-mode' when merge conflict is detected."
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^<<<<<<< " nil :noerror)
      (smerge-mode 1))))

;;;###autoload
(defun jyun/workspace-create ()
  "Create a new workspace after read `name' from a minibuffer."
  (interactive)
  (let ((name (read-from-minibuffer "New workspace name: ")))
    (+workspace/new name)
    ))

;;;###autoload
(defun jyun/org-present-hide ()
  "Hide comments, drawers and tags."
  (save-excursion
    ;; hide all comments
    (goto-char (point-min))
    (while (re-search-forward
            "^[ \t]*#\\(\\+\\(author\\|title\\|date\\):\\)?.*\n"
            nil t)
      (cond
       ((and (match-string 2)
             (save-match-data
               (string-match (regexp-opt '("title" "author" "date"))
                             (match-string 2)))))
       ((and (match-string 2)
             (save-match-data
               (string-match org-babel-results-keyword (match-string 2))))
        ;; This pulls back the end of the hidden overlay by one to
        ;; avoid hiding image results of code blocks.  I'm not sure
        ;; why this is required, or why images start on the preceding
        ;; newline, but not knowing why doesn't make it less true.
        (+org-present--make-invisible (match-beginning 0) (1- (match-end 0))))
       (t (+org-present--make-invisible (match-beginning 0) (1- (match-end 0))))))
    ;; hide tags
    (when +org-present-hide-tags
      (goto-char (point-min))
      (while (re-search-forward
              (org-re "^\\*+.*?\\([ \t]+:[[:alnum:]_@#%:]+:\\)[ \r\n]")
              nil t)
        (+org-present--make-invisible (match-beginning 1) (match-end 1))))
    ;; hide properties
    (when +org-present-hide-properties
      (goto-char (point-min))
      (while (re-search-forward org-drawer-regexp nil t)
        (let ((beg (match-beginning 0))
              (end (re-search-forward
                    "^[ \t]*:END:[ \r\n]*"
                    (save-excursion (outline-next-heading) (point)) t)))
          (+org-present--make-invisible beg end))))))
;; (dolist (el '("title" "author" "date"))
;;   (goto-char (point-min))
;;   (when (re-search-forward (format "^\\(#\\+%s:[ \t]*\\)[ \t]*\\(.*\\)$" el) nil t)
;;     (+org-present--make-invisible (match-beginning 1) (match-end 1))
;;     (push (make-overlay (match-beginning 2) (match-end 2)) +org-present--overlays)
;;     ))


;;;###autoload
(defun jyun/org-present-latex-preview ()
"Render LaTeX fragments in a buffer. The size of image is determned by `+org-present-format-latex-scale'."
  (interactive)
  (condition-case ex
      (let ((org-format-latex-options
             (plist-put (copy-tree org-format-latex-options)
                        :scale +org-present-format-latex-scale)))
        (org-preview-latex-fragment '(16)))
    ('error
     (message "Unable to imagify latex [%s]" ex))))

;;;###autoload
(defun jyun/magit-update-overleaf ()
  "Use Magit to stage files if there are unstaged ones.
Run a shellscript to commit and push staged files (if exist) to Overleaf.
 Assign a name to a shell command output buffer."
  (interactive)
  (progn
    (unless (featurep 'find-file-in-project) (require 'find-file-in-project))
    (when (or (magit-anything-unstaged-p) (magit-anything-staged-p))
      (magit-with-toplevel
        (magit-stage-1 "--u" magit-buffer-diff-files))
      (message "Asynchronously pushing changes to Overleaf...")
      (async-shell-command (format "sh %supdate-overleaf.sh" (ffip-project-root))
                     (format "*overleaf: %s*" (projectile-project-name)))
      ;; (message "Done!")
      )
    ))

;;;###autoload
(defun jyun/format-org-babel ()
  "Runs the active formatter on a whole `org-babel-src-block'."
  (interactive)
  (progn
    (org-edit-special)
    (+format:region (point-min) (point-max))
    (org-edit-src-exit)))

;;;###autoload
(defun jyun/doom-modeline-height ()
  "Cut doom-modeline paddings to reduce its height."
  (let ((height doom-modeline-height))
    (set-face-attribute 'mode-line nil :height (* 10 height))
    (set-face-attribute 'mode-line-inactive nil :height (* 10 height))
    (doom/reset-font-size)
    ))

;;;###autoload
(defun jyun/mu4e-html2text (msg)
  "My html2text function; shows short message inline, show
long messages in some external browser (see `browse-url-generic-program')."
  (let ((html (or (mu4e-message-field msg :body-html) "")))
    (if (> (length html) 50000)
        (progn
          (mu4e-action-view-in-browser msg)
          "[Viewing message in external browser]")
      (mu4e-shr2text msg))))
