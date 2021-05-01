;;; ~/.doom.d/autoload/vc.el -*- lexical-binding: t; -*-
;;;###if (featurep! :emacs vc)


;;;###autoload
(defun jyun/magit-push-overleaf (directory)
  "Use Magit to stage files if there are unstaged ones.
Call asynchronous magit processes to commit and push staged files (if exist) to origin"
  (progn
    (unless (featurep 'magit) (require 'magit))
    (let ((default-directory (magit-toplevel directory)))
    (when (or (magit-anything-unstaged-p) (magit-anything-staged-p))
      (magit-with-toplevel
        (magit-stage-1 "--u" magit-buffer-diff-files))
      (let ((message (format "pushing changes %s" (format-time-string "%Y-%m-%d %H:%M:%S %Z"))))
        (magit-run-git-async "commit" "-m" message)
        (magit-run-git-async "push" "origin" "master")
        )))))

;;;###autoload
(defun jyun/magit-pull-overleaf (directory)
  "Run `git pull origin master' using asynchronous magit processes."
  (progn
    (unless (featurep 'magit) (require 'magit))
    (let ((default-directory (magit-toplevel directory)))
    (magit-run-git-async "pull" "origin" "master"))
  ))

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
      )
    )
