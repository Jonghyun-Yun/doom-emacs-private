;;; ~/.doom.d/autoload/org.el -*- lexical-binding: t; -*-
;;;###if (featurep! :lang org)


;;;###autoload
(defun jyun/format-org-babel ()
  "Runs the active formatter on a whole `org-babel-src-block'."
  (interactive)
  (progn
    (org-edit-special)
    (+format:region (point-min) (point-max))
    (org-edit-src-exit)))


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
(defun +org-move-point-to-heading ()
  (cond ((org-at-heading-p) (org-beginning-of-line))
        (t (org-previous-visible-heading 1))))

;; ;;;###autoload
;; (defun org-protocol-check-filename-for-protocol (fname restoffiles _client)
;;   "Check if `org-protocol-the-protocol' and a valid protocol are used in FNAME.
;; Sub-protocols are registered in `org-protocol-protocol-alist' and
;; `org-protocol-protocol-alist-default'.  This is how the matching is done:

;;   (string-match \"protocol:/+sub-protocol\\\\(://\\\\|\\\\?\\\\)\" ...)

;; protocol and sub-protocol are regexp-quoted.

;; Old-style links such as \"protocol://sub-protocol://param1/param2\" are
;; also recognized.

;; If a matching protocol is found, the protocol is stripped from
;; fname and the result is passed to the protocol function as the
;; first parameter.  The second parameter will be non-nil if FNAME
;; uses key=val&key2=val2-type arguments, or nil if FNAME uses
;; val/val2-type arguments.  If the function returns nil, the
;; filename is removed from the list of filenames passed from
;; emacsclient to the server.  If the function returns a non-nil
;; value, that value is passed to the server as filename.

;; If the handler function is greedy, RESTOFFILES will also be passed to it.

;; CLIENT is ignored."
;;   (let ((sub-protocols (append org-protocol-protocol-alist
;;                                org-protocol-protocol-alist-default)))
;;     (catch 'fname
;;       (let ((the-protocol (concat (regexp-quote org-protocol-the-protocol)
;;                                   ":/+")))
;;         (when (string-match the-protocol fname)
;;           (dolist (prolist sub-protocols)
;;             (let ((proto
;;                    (concat the-protocol
;;                            (regexp-quote (plist-get (cdr prolist) :protocol))
;;                            "\\(:/+\\|\\?\\)")))
;;               (when (string-match proto fname)
;;                 (let* ((func (plist-get (cdr prolist) :function))
;;                        (greedy (plist-get (cdr prolist) :greedy))
;;                        (split (split-string fname proto))
;;                        (result (if greedy restoffiles (cadr split)))
;;                        (new-style (string= (match-string 1 fname) "?")))
;;                   (when (plist-get (cdr prolist) :kill-client)
;;                     (message "Greedy org-protocol handler.  Killing client.")
;;                     (server-edit))
;;                   (when (fboundp func)
;;                     (unless greedy
;;                       (throw 'fname
;;                              (if new-style
;;                                  (funcall func (org-protocol-parse-parameters
;;                                                 result new-style))
;;                                (when org-protocol-warn-about-old-links
;;                                  (warn "Please update your Org Protocol handler \
;; to deal with new-style links."))
;;                                (funcall func result))))
;;                     ;; Greedy protocol handlers are responsible for
;;                     ;; parsing their own filenames.
;;                     (funcall func result)
;;                     (throw 'fname t))))))))
;;       fname)))
