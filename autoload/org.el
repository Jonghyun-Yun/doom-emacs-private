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

;;;###autoload
(defun jyun/get-heading ()
  "Get org-heading of a current section."
  (interactive)
  (let ((heading (nth 4 (org-heading-components))))
                 (print heading)))

;;;###autoload
(defun jyun/insert-src-block-name (name)
  "Go to a named source-code block."
  (interactive
   (let ((completion-ignore-case t)
	 (case-fold-search t)
	 (all-block-names (org-babel-src-block-names)))
     (list (completing-read
	    "source-block name: " all-block-names nil t
	    (let* ((context (org-element-context))
		   (type (org-element-type context))
		   (noweb-ref
		    (and (memq type '(inline-src-block src-block))
			 (org-in-regexp (org-babel-noweb-wrap)))))
	      (cond
	       (noweb-ref
		(buffer-substring
		 (+ (car noweb-ref) (length org-babel-noweb-wrap-start))
		 (- (cdr noweb-ref) (length org-babel-noweb-wrap-end))))
	       ((memq type '(babel-call inline-babel-call)) ;#+CALL:
		(org-element-property :call context))
	       ((car (org-element-property :results context))) ;#+RESULTS:
	       ((let ((symbol (thing-at-point 'symbol))) ;Symbol.
		  (and symbol
		       (member-ignore-case symbol all-block-names)
		       symbol)))
	       (t "")))))))
  (insert (concat "<<" name ">>\n"))
  )

;;;###autoload
(defadvice! jyun/org-capture-central-project-todo-file ()
  :override #'+org-capture-central-project-todo-file
  "Stop `org-capture' if not in project dir."
  (let ((pname (projectile-project-name)))
    (catch 'out-proj
      (when (string= pname "-")
        (throw 'out-proj
               (message "Not in a project directory.")))
    (+org--capture-central-file
     +org-capture-projects-file pname))))
