;;; private/scimax/config.el -*- lexical-binding: t; -*-

;; ;; google-this
;; (use-package google-this
;;   :config
;;   (google-this-mode 1)
;;   ;; (setq google-this-base-url "https://duckduckgo.")
;; ;; (defun google-this-url ()
;; ;;   "URL for google searches.
;; ;;   (concat google-this-base-url google-this-location-suffix "/?q=%s"))
;;   )

;;; scimax
;; (load! "words")                         ;; bibtex search
(load! "scimax-elfeed")                 ;; email elfeed
;; (load! "scimax-hydra")                  ;; my hydra to review
(load! "scimax-autoformat-abbrev")      ;; abbrev
(load! "scimax-yas")      ;; abbrev

;; (use-package! ox-word
  ;; :after ox)

;; (scimax-ivy-yas)
;; (scimax-autoformat-mode)
;; (scimax-toggle-abbrevs)

(after! org
  (load! "scimax-org") ;; org mark-up
  (defun org-inline-math-region-or-point ()
    "Mark the region, word or character at point as inline math.
This function tries to do what you mean:
1. If you select a region, markup the region.
2. If in a word, markup the word.
3. Otherwise wrap the character at point in the markup.
Repeated use of the function slurps the next word into the markup."
    (interactive)
    (org-markup-region-or-point 'math "\\(" "\\)"))
  ;; key bindings
  (bind-keys :map org-mode-map
             ("H--" . org-subscript-region-or-point)
             ("H-=" . org-superscript-region-or-point)
             ("H-i" . org-italics-region-or-point)
             ("H-b" . org-bold-region-or-point)
             ("H-v" . org-verbatim-region-or-point)
             ("H-c" . org-code-region-or-point)
             ("H-u" . org-underline-region-or-point)
             ("H-+" . org-strikethrough-region-or-point)
             ("H-4" . org-latex-math-region-or-point)
             ("H-e" . ivy-insert-org-entity)
             ("H-\"" . org-double-quote-region-or-point)
             ("H-'" . org-single-quote-region-or-point)
             ("H-m" . org-inline-math-region-or-point))
  ;; (add-hook! 'org-mode-hook #'scimax-autoformat-mode)


;;; scimax-org-latex.el
  ;; ** numbering latex equations

  ;; Numbered equations all have (1) as the number for fragments with vanilla
  ;; org-mode. This code injects the correct numbers into the previews so they
  ;; look good.
  (defun scimax-org-renumber-environment (orig-func &rest args)
    "A function to inject numbers in LaTeX fragment previews."
    (let ((results '())
	  (counter -1)
	  (numberp))
      (setq results (loop for (begin .  env) in
			  (org-element-map (org-element-parse-buffer) 'latex-environment
			    (lambda (env)
			      (cons
			       (org-element-property :begin env)
			       (org-element-property :value env))))
			  collect
			  (cond
			   ((and (string-match "\\\\begin{equation}" env)
			         (not (string-match "\\\\tag{" env)))
			    (incf counter)
			    (cons begin counter))
			   ((string-match "\\\\begin{align}" env)
			    (prog2
			        (incf counter)
			        (cons begin counter)
			      (with-temp-buffer
			        (insert env)
			        (goto-char (point-min))
			        ;; \\ is used for a new line. Each one leads to a number
			        (incf counter (count-matches "\\\\$"))
			        ;; unless there are nonumbers.
			        (goto-char (point-min))
			        (decf counter (count-matches "\\nonumber")))))
			   (t
			    (cons begin nil)))))

      (when (setq numberp (cdr (assoc (point) results)))
        (setf (car args)
	      (concat
	       (format "\\setcounter{equation}{%s}\n" numberp)
	       (car args)))))

    (apply orig-func args))


  (defun scimax-toggle-latex-equation-numbering ()
    "Toggle whether LaTeX fragments are numbered."
    (interactive)
    (if (not (get 'scimax-org-renumber-environment 'enabled))
        (progn
	  (advice-add 'org-create-formula-image :around #'scimax-org-renumber-environment)
	  (put 'scimax-org-renumber-environment 'enabled t)
	  (message "Latex numbering enabled"))
      (advice-remove 'org-create-formula-image #'scimax-org-renumber-environment)
      (put 'scimax-org-renumber-environment 'enabled nil)
      (message "Latex numbering disabled.")))

  (add-hook! 'org-mode-hook (lambda () (if (not (get 'scimax-org-renumber-environment 'enabled))
                                      (scimax-toggle-latex-equation-numbering)))))
