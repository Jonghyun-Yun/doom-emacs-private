;;; ~/.doom.d/autoload/vc.el -*- lexical-binding: t; -*-
;;;###if (featurep! :emacs vc)


;;;###autoload
(defun jyun/magit-update-overleaf ()
  "Use Magit to stage files if there are unstaged ones.
Run a shellscript to commit and push staged files (if exist) to Overleaf.
 Assign a name to a shell command output buffer."
  (interactive)
  (progn
    (unless (featurep 'find-file-in-project) (require 'find-file-in-project))
    (when (or (magit-anything-unstaged-p) (magit-anything-staged-p))
      (magit-with-toplevel
        (magit-stage-1 "--u" magit-buffer-diff-files))
      (message "Asynchronously pushing changes to Overleaf...")
      (async-shell-command (format "sh %supdate-overleaf.sh" (ffip-project-root))
                     (format "*overleaf: %s*" (projectile-project-name)))
      ;; (message "Done!")
      )
    ))


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
