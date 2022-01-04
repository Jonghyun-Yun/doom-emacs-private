;;; ../Dropbox/emacs/.doom.d/snippets/latex-mode/.yas-setup.el -*- lexical-binding: t; -*-

;;;###autoload
(defun jyun/cdlatex-insert-filename ()
  "Insert a file name, with completion.
The path to the file will be relative to the current directory if the file
is in the current directory or a subdirectory.  Otherwise, the link will
be as completed in the minibuffer (i.e. normally relative to the users
HOME directory)."
  (interactive)
  (let ((file (read-file-name "File: " nil "")))
    (let ((pwd (file-name-as-directory (expand-file-name "."))))
      (cond
       ((string-match (concat "^" (regexp-quote pwd) "\\(.+\\)")
                      (expand-file-name file))
        (message (match-string 1 (expand-file-name file))))
       (t (message (expand-file-name file))))))
  )
