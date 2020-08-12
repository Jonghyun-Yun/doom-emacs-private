;;; ../Dropbox/emacs/.doom.d/autoload/elfeed.el -*- lexical-binding: t; -*-

(defvar +my-elfeed-workspace-name "*elfeed*"
  "TODO")
(defvar +my-elfeed--old-wconf nil)

(add-hook 'elfeed-search-mode-hook #'+my-elfeed-init-h)

;;;###autoload
(defun my-elfeed ()
  (interactive)
  (if (featurep! :ui workspaces)
      (+workspace-switch +my-elfeed-workspace-name t)
    (setq +my-elfeed--old-wconf (current-window-configuration))
    (delete-other-windows)
    (switch-to-buffer (doom-fallback-buffer)))
  (elfeed)
  )

;;
;; Hooks

;;;###autoload
(defun +my-elfeed-init-h ()
  (add-hook 'kill-buffer-hook #'+my-elfeed-kill-elfeed-h nil t))

;;;###autoload
(defun +my-elfeed-kill-elfeed-h ()
  ;; (prolusion-mail-hide)
  (cond
   ((and (featurep! :ui workspaces) (+workspace-exists-p +my-elfeed-workspace-name))
    (+workspace/delete +my-elfeed-workspace-name))

   (+my-elfeed--old-wconf
    (set-window-configuration +my-elfeed--old-wconf)
    (setq +my-elfeed--old-wconf nil))))
