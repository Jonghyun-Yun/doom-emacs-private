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

;;;###autoload
;; browse rendered html
(defun browse-rendered-html ()
  (interactive)
  (setq file-to-open (format "file://%s.html" (file-name-sans-extension buffer-file-name)))
  (browse-url file-to-open))

;;;###autoload
;; Ediff the init.example.el and my init.el
(defun ediff-init-files ()
  (interactive)
  (ediff-files (expand-file-name "init.el" doom-private-dir)
               (expand-file-name "init.example.el" user-emacs-directory)))

;;;###autoload
;;; to run jabber.el in emacs 27+
(defun assoc-ignore-case (KEY LIST)
  "This function is obsolete since 22.1;
  use `assoc-string' instead.

  Like `assoc', but ignores differences in case and text representation.
  KEY must be a string. Upper-case and lower-case letters are treated as equal.
  Unibyte strings are converted to multibyte for comparison."
  (assoc-string KEY LIST)
    )

;;;###autoload
(defun my-persp-add-buffer (orig-fun &rest args)
  "Apply a function and and add the opened buffer name to the perspective."
  (progn
    (apply orig-fun args)
    (let ((bname (buffer-name)))
      (persp-add-buffer bname)
      ))
  )

;;;###autoload
(defun my/find-file-in-private-config ()
  "Search for a file in `doom-private-dir' using `find-file-in-project'."
  (interactive)
  ;; (let* ((ffip-project-root "~/.doom.d/"))
  ;; (let* ((ffip-project-root doom-private-dir))
  (let* ((default-directory doom-private-dir))
    (find-file-in-project nil)
    ))

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
(defun thin-all-faces ()
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
       (set-face-attribute face nil :weight 'semi-bold))
     )
   (face-list))
  )

;;;###autoload
(defun thick-all-faces ()
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
       (set-face-attribute face nil :weight 'bold))
     )
   (face-list))
  )

;;;###autoload
(defun jethro/enable-smerge-maybe ()
  "Auto-enable `smerge-mode' when merge conflict is detected."
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^<<<<<<< " nil :noerror)
      (smerge-mode 1))))

;;;###autoload
(defun my-workspace-create (name)
  "Create a new workspace named NAME."
  (interactive (list (read-from-minibuffer "New workspace name: ")))
  ;; (interactive (list nil current-prefix-arg))
  (unless name
    (setq name (format "#%s" (+workspace--generate-id))))
  (condition-case e
      (cond ((+workspace-exists-p name)
             (error "%s already exists" name))
            ((+workspace--protected-p name)
    (error "Can't create a new '%s' workspace" name))
            ;; (clone-p (persp-copy name t))
            (t
             (+workspace-switch name t)
             (+workspace/display)))
    ((debug error) (+workspace-error (cadr e) t))))
