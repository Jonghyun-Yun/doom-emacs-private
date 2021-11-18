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

;;;###autoload
(defun +yas/org-src-header-p ()
  "Determine whether `point' is within a src-block header or header-args."
  (pcase (org-element-type (org-element-context))
    ('src-block (< (point) ; before code part of the src-block
                   (save-excursion (goto-char (org-element-property :begin (org-element-context)))
                                   (forward-line 1)
                                   (point))))
    ('inline-src-block (< (point) ; before code part of the inline-src-block
                          (save-excursion (goto-char (org-element-property :begin (org-element-context)))
                                          (search-forward "]{")
                                          (point))))
    ('keyword (string-match-p "^header-args" (org-element-property :value (org-element-context))))))

;;;###autoload
(defun +yas/org-prompt-header-arg (arg question values)
  "Prompt the user to set ARG header property to one of VALUES with QUESTION.
The default value is identified and indicated. If either default is selected,
or no selection is made: nil is returned."
  (let* ((src-block-p (not (looking-back "^#\\+property:[ \t]+header-args:.*" (line-beginning-position))))
         (default
           (or
            (cdr (assoc arg
                        (if src-block-p
                            (nth 2 (org-babel-get-src-block-info t))
                          (org-babel-merge-params
                           org-babel-default-header-args
                           (let ((lang-headers
                                  (intern (concat "org-babel-default-header-args:"
                                                  (+yas/org-src-lang)))))
                             (when (boundp lang-headers) (eval lang-headers t)))))))
            ""))
         default-value)
    (setq values (mapcar
                  (lambda (value)
                    (if (string-match-p (regexp-quote value) default)
                        (setq default-value
                              (concat value " "
                                      (propertize "(default)" 'face 'font-lock-doc-face)))
                      value))
                  values))
    (let ((selection (ivy-read question values :preselect default-value)))
      (unless (or (string-match-p "(default)$" selection)
                  (string= "" selection))
        selection))))

;;;###autoload
(defun +yas/org-src-lang ()
  "Try to find the current language of the src/header at `point'.
Return nil otherwise."
  (let ((context (org-element-context)))
    (pcase (org-element-type context)
      ('src-block (org-element-property :language context))
      ('inline-src-block (org-element-property :language context))
      ('keyword (when (string-match "^header-args:\\([^ ]+\\)" (org-element-property :value context))
                  (match-string 1 (org-element-property :value context)))))))

;;;###autoload
(defun +yas/org-last-src-lang ()
  "Return the language of the last src-block, if it exists."
  (save-excursion
    (beginning-of-line)
    (when (re-search-backward "^[ \t]*#\\+begin_src" nil t)
      (org-element-property :language (org-element-context)))))

;;;###autoload
(defun +yas/org-most-common-no-property-lang ()
  "Find the lang with the most source blocks that has no global header-args, else nil."
  (let (src-langs header-langs)
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "^[ \t]*#\\+begin_src" nil t)
        (push (+yas/org-src-lang) src-langs))
      (goto-char (point-min))
      (while (re-search-forward "^[ \t]*#\\+property: +header-args" nil t)
        (push (+yas/org-src-lang) header-langs)))

    (setq src-langs
          (mapcar #'car
                  ;; sort alist by frequency (desc.)
                  (sort
                   ;; generate alist with form (value . frequency)
                   (cl-loop for (n . m) in (seq-group-by #'identity src-langs)
                            collect (cons n (length m)))
                   (lambda (a b) (> (cdr a) (cdr b))))))

    (car (cl-set-difference src-langs header-langs :test #'string=))))

;;;###autoload
(defun org-syntax-convert-keyword-case-to-lower ()
  "Convert all #+KEYWORDS to #+keywords."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((count 0)
          (case-fold-search nil))
      (while (re-search-forward "^[ \t]*#\\+[A-Z_]+" nil t)
        (unless (s-matches-p "RESULTS" (match-string 0))
          (replace-match (downcase (match-string 0)) t)
          (setq count (1+ count))))
      (message "Replaced %d occurances" count))))
