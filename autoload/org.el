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
               (user-error "Not in a project directory.")))
      (+org--capture-central-file
       +org-capture-projects-file pname))))

;;; org-roam
;; no numbers in org-roam buffers
;;;###autoload
(defadvice! doom-modeline--buffer-file-name-roam-aware-a (orig-fun)
  :around #'doom-modeline-buffer-file-name ; takes no args
  (if (s-contains-p org-roam-directory (or buffer-file-name ""))
      (replace-regexp-in-string
       "\\(?:^\\|.*/\\)\\([0-9]\\{4\\}\\)\\([0-9]\\{2\\}\\)\\([0-9]\\{2\\}\\)[0-9]*-"
       "🢔(\\1-\\2-\\3) "
       (subst-char-in-string ? ?  buffer-file-name)
       )
    (funcall orig-fun)))

;;;###autoload
(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (push arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                  '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))

;;; org-ref v2 to v3
;;;###autoload
(defun org-ref-convert-cite-v2-to-v3 ()
  "Convert all cite: to cite:&."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((count 0)
          (case-fold-search nil))
      (while (re-search-forward "cite:\\(\\w+\\)" nil t)
        (replace-match "cite:\&\\1" t)
        (setq count (1+ count)))
      (message "Replaced %d occurances" count))))

;;; org latex fragment background
;;;###autoload
(defun jyun/org-latex-set-directory-color ()
  "Set Org LaTeX directory name to default face"
  (interactive)
  (setq org-preview-latex-image-directory
        (concat "ltximg/" (s-replace "#" "HEX" (alist-get 'foreground-color (frame-parameters)))
                ;; (let ((color (color-values (alist-get 'foreground-color (frame-parameters)))))
                ;;   (apply 'concat (mapcar (lambda (x) (concat "_" x)) (mapcar 'int-to-string color)))
                ;;   )
                "/")))
;;;###autoload
(defun jyun/org-latex-update-fragments-color ()
  "Remove Org LaTeX fragment layout, switch directory for face color, turn fragments back on."
  (interactive)
  ;; removes latex overlays in the whole buffer
  (org-remove-latex-fragment-image-overlays)
  ;; background directory switch
  (jyun/org-latex-set-directory-color)
  ;; recreate overlay
  ;; Argument '(16) is same as prefix C-u C-u,
  ;; means create images in the whole buffer instead of just the current section.
  ;; For many new images this will take time.
  (org-toggle-latex-fragment '(16)))

;;; org view output
;;;###autoload
(defun org-view-output-file (&optional org-file-path)
  "Visit buffer open on the first output file (if any) found, using `org-view-output-file-extensions'"
  (interactive)
  (let* ((org-file-path (or org-file-path (buffer-file-name) ""))
         (dir (file-name-directory org-file-path))
         (basename (file-name-base org-file-path))
         (output-file nil))
    (dolist (ext org-view-output-file-extensions)
      (unless output-file
        (when (file-exists-p
               (concat dir basename "." ext))
          (setq output-file (concat dir basename "." ext)))))
    (if output-file
        (if (member (file-name-extension output-file) org-view-external-file-extensions)
            (browse-url output-file)
          (pop-to-buffer (or (find-buffer-visiting output-file)
                             (find-file-noselect output-file))))
      (message "No exported file found"))))

;;; org-bael header
;;;###autoload
(defun jyun/set-org-babel-default-header-args:R ()
  "Locally set `org-babel-default-header-args:R' for R session."
  (let ((sname (concat "*R:" (projectile-project-name) "*")))
    (unless (boundp 'org-babel-default-header-args:R)
      (setq-local org-babel-default-header-args:R '((:export . "code") (:results . "output replace")
                                                    )))
    (setf (alist-get :export org-babel-default-header-args:R) "code")
    (setf (alist-get :results org-babel-default-header-args:R) "output replace")
    (setf (alist-get :session org-babel-default-header-args:R) sname)
    )
  )
