;;; ~/.doom.d/autoload/vc.el -*- lexical-binding: t; -*-
;;;###if (featurep! :emacs vc)


;;;###autoload
(defun jyun/magit-stage-commit-push-origin-master (&optional proj)
  "Use Magit to stage files if there are unstaged ones.
Call asynchronous magit processes to commit and push staged files (if exist) to origin"
  (progn
    (unless (featurep 'magit) (require 'magit))
    (let ((default-directory (if proj proj default-directory)))
    (when (or (magit-anything-unstaged-p) (magit-anything-staged-p))
      (magit-with-toplevel
        (magit-stage-1 "--u" magit-buffer-diff-files))
      (let ((message (format "pushing changes %s" (format-time-string "%Y-%m-%d %H:%M:%S %Z"))))
        (magit-run-git-async "commit" "-m" message)
        (magit-run-git-async "push" "origin" "master")
        )))))

;;;###autoload
(defun jyun/magit-pull-origin-master ()
  "Run `git pull origin master' using asynchronous magit processes."
  (progn
    (unless (featurep 'magit) (require 'magit))
    (magit-run-git-async "pull" "origin" "master"))
  )

;;;###autoload
(defun jethro/enable-smerge-maybe ()
  "Auto-enable `smerge-mode' when merge conflict is detected."
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^<<<<<<< " nil :noerror)
      (smerge-mode 1))))


;; Ediff the init.example.el and my init.el
;;;###autoload
(defun ediff-init-files ()
  (interactive)
  (ediff-files (expand-file-name "init.el" doom-private-dir)
               (expand-file-name "init.example.el" user-emacs-directory)))


;;;###autoload
(defun jyun/magit-update-overleaf (&optional proj)
  "Use Magit to stage files if there are unstaged ones.
Run a shellscript to commit and push staged files (if exist) to Overleaf.
 Assign a name to a shell command output buffer."
  (interactive)
  (progn
    (unless (featurep 'find-file-in-project) (require 'find-file-in-project))
    (when (or (magit-anything-unstaged-p) (magit-anything-staged-p))
      ;; stage all unstage files
      ;; (magit-with-toplevel
      ;;   (magit-stage-1 "--u" magit-buffer-diff-files))
      (message "Asynchronously pushing changes to Overleaf...")
      (async-shell-command (format "sh %supdate-overleaf.sh" (if proj proj (ffip-project-root)))
                           (format "*overleaf: %s*" (projectile-project-name))
                           (format "*overleaf error: %s*" (projectile-project-name)))
      ;; (message "Done!")
      )
    ))
