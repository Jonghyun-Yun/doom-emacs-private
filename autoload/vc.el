;;; ~/.doom.d/autoload/vc.el -*- lexical-binding: t; -*-
;;;###if (modulep! :emacs vc)

;; Ediff the init.example.el and my init.el
;;;###autoload
(defun ediff-init-files ()
  (interactive)
  (ediff-files (expand-file-name "init.el" doom-private-dir)
               (expand-file-name "init.example.el" user-emacs-directory)))


;;;###autoload
(defun jyun/pull-overleaf ()
  " Run a shellscript to pull files from Overleaf.
 Assign a name to a shell command output buffer."
  (interactive)
  (progn
    (unless (featurep 'find-file-in-project) (require 'find-file-in-project))
      (message "Asynchronously pulling from Overleaf...")
      (async-shell-command (format "sh %spull-overleaf.sh" (ffip-project-root))
                           (format "*overleaf: %s*" (projectile-project-name))
                           (format "*overleaf error: %s*" (projectile-project-name)))
      ;; (message "Done!")
      )
    )

;;;###autoload
(defun jyun/push-overleaf ()
  " Run a shellscript to commit and push staged files to Overleaf.
 Assign a name to a shell command output buffer."
  (interactive)
  (progn
    (unless (featurep 'find-file-in-project) (require 'find-file-in-project))
      (message "Asynchronously pushing changes to Overleaf...")
      (async-shell-command (format "sh %spush-overleaf.sh" (ffip-project-root))
                           (format "*overleaf: %s*" (projectile-project-name))
                           (format "*overleaf error: %s*" (projectile-project-name)))
      ;; (message "Done!")
      ))

;;;###autoload
(defun jyun/fetch-doom-emacs ()
  "See `magit-status', and run `git fetch --all' using magit processes."
  (interactive)
  (let ((default-directory (magit-toplevel doom-emacs-dir)))
    (magit-status)
    (magit-run-git-async "fetch" "--all")))
