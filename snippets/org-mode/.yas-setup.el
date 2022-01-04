(require 'yasnippet)

(defvar scimax-installed-bibliography-styles
  (when (executable-find "kpsewhich")
    (mapcar 'file-name-nondirectory
	    (mapcar 'file-name-sans-extension
		    (-flatten
		     (mapcar (lambda (path)
			       (setq path (replace-regexp-in-string "!" "" path))
			       ;; [2019-08-21 Wed] I added a check to only do
			       ;; absolute paths. BSTINPUTS may contain "."
			       ;; which might be a problem depending on when
			       ;; this variable is defined, e.g. if it is in
			       ;; your home, maybe it would search a lot of
			       ;; directories. I don't see this, but issue #300
			       ;; https://github.com/jkitchin/scimax/issues/300
			       ;; inspired this addition.
			       (when (and (not (file-symlink-p path))
					  (file-name-absolute-p path)
					  (file-directory-p path)
					  ;; you probably do not want to do this
					  ;; in your home path
					  (not (string= (expand-file-name "~/") path)))
				 ;; I am not super sure if this should be
				 ;; recursive. I find more styles when it is
				 ;; recursive.
				 (f-entries path (lambda (f) (f-ext? f "bst")) t)))
			     (split-string
			      ;; https://tex.stackexchange.com/questions/431948/get-a-list-of-installed-bibliography-styles-with-kpsewhich?noredirect=1#comment1082436_431948
			      (shell-command-to-string "kpsewhich -expand-path '$BSTINPUTS'")
			      ":"))))))
  "List of installed bibliography styles.")


(defvar scimax-installed-latex-packages nil
  "List of known installed packages.")

;; We start this async so it probably gets done by the time we need it. This is
;; slow, so we don't want to do it on each time. This approach seems more
;; reliable than looking for sty files using kpsewhich like I did for the
;; bibliography styles
(when (and (null scimax-installed-latex-packages)
	   (executable-find "tlmgr"))
  (require 'async)
  (async-start
   `(lambda ()
      (require 'cl)
      (mapcar
       (lambda (s)
	 (second (split-string (first (split-string s ":")) " ")))
       (cl-loop for line in (process-lines ,(executable-find "tlmgr")  "info" "--only-installed")
		if (and (stringp line) (string= "i" (substring line 0 1)))
		collect line)))

   (lambda (result)
     (setq scimax-installed-latex-packages result))))

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

(defun +yas/org-src-lang ()
  "Try to find the current language of the src/header at `point'.
Return nil otherwise."
  (let ((context (org-element-context)))
    (pcase (org-element-type context)
      ('src-block (org-element-property :language context))
      ('inline-src-block (org-element-property :language context))
      ('keyword (when (string-match "^header-args:\\([^ ]+\\)" (org-element-property :value context))
                  (match-string 1 (org-element-property :value context)))))))

(defun +yas/org-last-src-lang ()
  "Return the language of the last src-block, if it exists."
  (save-excursion
    (beginning-of-line)
    (when (re-search-backward "^[ \t]*#\\+begin_src" nil t)
      (org-element-property :language (org-element-context)))))

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