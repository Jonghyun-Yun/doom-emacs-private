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
