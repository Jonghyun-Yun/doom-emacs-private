;;; ~/.doom.d/lisp/idle.el -*- lexical-binding: t; -*-


;;;###autoload
(defun auto-require-packages (packages)
  (let* ((reqs (cl-remove-if #'featurep packages))
         (req (pop reqs)))
    (when req
      (message "Loading %s" req)
      (require req)
      (when reqs
        (run-with-idle-timer 2 nil #'auto-require-packages reqs)))))


;;;###autoload
(defun auto-load-files (files)
  (let ((file (pop files)))
    (when file
      (message "Loading %s" file)
      (find-file-noselect file)
      (when files
        (run-with-idle-timer 2 nil #'auto-load-files files)))))

;; abuse idle timers in a thread to reduce blocking
(make-thread
 (lambda ()
   (run-with-idle-timer 10 nil #'auto-require-packages
                        '(org mu4e evil-org org-capture
                              ;; org-roam
                              org-protocol org-attach org-download ox
                             latex auctex-latexmk evil-tex
                             org-ref bibtex bibtex-completion reftex ivy-bibtex biblio elfeed
                             pdf-tools writeroom-mode langtool
                             magit
                             conda elisp-mode ess ess-site
                             flycheck lsp-mode
                             org-agenda
                             ;; org-super-agenda
                             org-gcal calfw
                             find-file-in-project hydra
                             counsel counsel-projectile yasnippet company ibuffer
                             persp-mode evil-mc
                             eshell jabber undo-fu spell-fu
                             wordnut osx-dictionary mixed-pitch centered-window
                             ivy-prescient
                             ))
                        ))
