;;; ~/.doom.d/autoload/jyun.el -*- lexical-binding: t; -*-


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


;; ;;;###autoload
;; (defun jyun/workspace-create ()
;;   "Create a new workspace after read `name' from a minibuffer."
;;   (interactive)
;;   (let ((name (read-from-minibuffer "New workspace name: ")))
;;     (+workspace/new name)
;;     ))


;;;###autoload
(defun jyun/persp-add-buffer (orig-fun &rest args)
  "Apply a function and and add the opened buffer name to the perspective."
  (progn
    (apply orig-fun args)
    (let ((bname (buffer-name)))
      (persp-add-buffer bname))))
