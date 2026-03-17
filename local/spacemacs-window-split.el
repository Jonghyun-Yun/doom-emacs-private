;;; ../Dropbox/emacs/.doom.d/local/spacemacs-window-spilt.el -*- lexical-binding: t; -*-

(defun spacemacs--window-split-splittable-windows ()
  (seq-remove
   (lambda (window)
     ;; TODO: find a way to identify unsplittable side windows reliably!
     nil)
   (spacemacs--window-split-non-ignored-windows)))

(defun spacemacs--window-split-non-ignored-windows ()
  "Determines the list of windows to be deleted."
  (seq-filter
   (lambda (window)
     (let* ((name (buffer-name (window-buffer window)))
            (prefixes-matching
             (seq-filter
              (lambda (prefix) (string-prefix-p prefix name))
              spacemacs-window-split-ignore-prefixes)))
       (not prefixes-matching)))
   (window-list (selected-frame))))

(defun spacemacs/window-split-default-delete ()
  "Deletes other windows, except a list of excluded ones."
  (if spacemacs-window-split-ignore-prefixes
      (let* ((deletable (spacemacs--window-split-non-ignored-windows))
             (splittable (spacemacs--window-split-splittable-windows)))
        (when splittable
          (let* ((selected (car splittable))
                 (to-delete (delq selected deletable)))
            (select-window selected)
            (dolist (window to-delete) (delete-window window)))))
    (delete-other-windows)))

(defvar spacemacs-window-split-ignore-prefixes nil
  "Prefixes for windows that are not deleted when changing split layout.

 You can add an entry here by using the following:
 (add-to-list 'spacemacs-window-split-ignore-prefixes \"Buffer prefix\")")

(defvar spacemacs-window-split-delete-function
  'spacemacs/window-split-default-delete
  "Function used to delete other windows when changing layout.

 Used as a callback by the following functions:
   - spacemacs/window-split-grid
   - spacemacs/window-split-triple-columns
   - spacemacs/window-split-double-columns
   - spacemacs/window-split-single-column

 Possible values:
   - 'spacemacs/window-split-default-delete (default)
   - 'delete-other-windows
   - 'treemacs-delete-other-windows (when using the treemacs package)
   - a lambda: (lambda () (delete-other-windows))
   - a custom function:
     (defun my-delete-other-windows () (delete-other-windows))
     (setq spacemacs-window-split-delete-function 'my-delete-other-windows)")

(defun spacemacs/window-split-grid-2by4 (&optional purge)
  "Set the layout to a 2x4 grid.

 Uses the funcion defined in `spacemacs-window-split-delete-function'
 as a means to remove windows.

 When called with a prefix argument, it uses `delete-other-windows'
 as a means to remove windows, regardless of the value in
 `spacemacs-window-split-delete-function'."
  (interactive "P")
  (if purge
      (let ((ignore-window-parameters t))
        (delete-other-windows))
    (funcall spacemacs-window-split-delete-function))
  (if (spacemacs--window-split-splittable-windows)
      (let* ((previous-files (seq-filter #'buffer-file-name
                                         (delq (current-buffer) (buffer-list))))
             (second (split-window-right))
             (third (split-window-right))
             (fourth (split-window-right))
             (fifth (split-window-below))
             (sixth (split-window second nil 'below))
             (seventh (split-window third nil 'below))
             (eighth (split-window fourth nil 'below)))
        (set-window-buffer second (or (car previous-files) (dired-jump)))
        (set-window-buffer third (or (cadr previous-files) "*doom:scratch*"))
        (set-window-buffer fourth (or (caddr previous-files) "*doom:scratch*"))
        (set-window-buffer fifth (or (cadddr previous-files) "*doom:scratch*"))
        (set-window-buffer sixth (or (car (cddddr previous-files)) "*doom:scratch*"))
        (set-window-buffer seventh (or (car (cdr (cddddr previous-files))) "*doom:scratch*"))
        (set-window-buffer eighth (or (car (cdr (cdr (cddddr previous-files)))) "*doom:scratch*"))
        (balance-windows))
    (message "There are no main windows available to split!")))

(defun spacemacs/window-split-grid-2by3 (&optional purge)
  "Set the layout to a 2x3 grid.

 Uses the funcion defined in `spacemacs-window-split-delete-function'
 as a means to remove windows.

 When called with a prefix argument, it uses `delete-other-windows'
 as a means to remove windows, regardless of the value in
 `spacemacs-window-split-delete-function'."
  (interactive "P")
  (if purge
      (let ((ignore-window-parameters t))
        (delete-other-windows))
    (funcall spacemacs-window-split-delete-function))
  (if (spacemacs--window-split-splittable-windows)
      (let* ((previous-files (seq-filter #'buffer-file-name
                                         (delq (current-buffer) (buffer-list))))
             (second (split-window-right))
             (third (split-window-right))
             (fourth (split-window-below))
             (fifth (split-window second nil 'below))
             (sixth (split-window third nil 'below)))
        (set-window-buffer second (or (car previous-files) (dired-jump)))
        (set-window-buffer third (or (cadr previous-files) "*doom:scratch*"))
        (set-window-buffer fourth (or (caddr previous-files) "*doom:scratch*"))
        (set-window-buffer fifth (or (cadddr previous-files) "*doom:scratch*"))
        (set-window-buffer sixth (or (car (cddddr previous-files)) "*doom:scratch*"))
        (balance-windows))
    (message "There are no main windows available to split!")))

(defun spacemacs/window-split-grid (&optional purge)
  "Set the layout to a 2x2 grid.

 Uses the funcion defined in `spacemacs-window-split-delete-function'
 as a means to remove windows.

 When called with a prefix argument, it uses `delete-other-windows'
 as a means to remove windows, regardless of the value in
 `spacemacs-window-split-delete-function'."
  (interactive "P")
  (if purge
      (let ((ignore-window-parameters t))
        (delete-other-windows))
    (funcall spacemacs-window-split-delete-function))
  (if (spacemacs--window-split-splittable-windows)
      (let* ((previous-files (seq-filter #'buffer-file-name
                                         (delq (current-buffer) (buffer-list))))
             (second (split-window-below))
             (third (split-window-right))
             (fourth (split-window second nil 'right)))
        (set-window-buffer third (or (car previous-files) "*scratch*"))
        (set-window-buffer second (or (cadr previous-files) "*scratch*"))
        (set-window-buffer fourth (or (caddr previous-files) "*scratch*"))
        (balance-windows))
    (message "There are no main windows available to split!")))

(defun spacemacs/window-split-triple-columns (&optional purge)
  "Set the layout to triple columns.

 Uses the funcion defined in `spacemacs-window-split-delete-function'
 as a means to remove windows.

 When called with a prefix argument, it uses `delete-other-windows'
 as a means to remove windows, regardless of the value in
 `spacemacs-window-split-delete-function'."
  (interactive "P")
  (if purge
      (let ((ignore-window-parameters t))
        (delete-other-windows))
    (funcall spacemacs-window-split-delete-function))
  (if (spacemacs--window-split-splittable-windows)
      (let* ((previous-files (seq-filter #'buffer-file-name
                                         (delq (current-buffer) (buffer-list))))
             (second (split-window-right))
             (third (split-window second nil 'right)))
        (set-window-buffer second (or (car previous-files) "*scratch*"))
        (set-window-buffer third (or (cadr previous-files) "*scratch*"))
        (balance-windows))
    (message "There are no main windows available to split!")))

(defun spacemacs/window-split-double-columns (&optional purge)
  "Set the layout to double columns.

 Uses the funcion defined in `spacemacs-window-split-delete-function'
 as a means to remove windows.

 When called with a prefix argument, it uses `delete-other-windows'
 as a means to remove windows, regardless of the value in
 `spacemacs-window-split-delete-function'."
  (interactive "P")
  (if purge
      (let ((ignore-window-parameters t))
        (delete-other-windows))
    (funcall spacemacs-window-split-delete-function))
  (if (spacemacs--window-split-splittable-windows)
      (let* ((previous-files (seq-filter #'buffer-file-name
                                         (delq (current-buffer) (buffer-list)))))
        (set-window-buffer (split-window-right)
                           (or (car previous-files) "*scratch*"))
        (balance-windows))
    (message "There are no main windows available to split!")))

(defun spacemacs/window-split-single-column (&optional purge)
  "Set the layout to single column.

 Uses the funcion defined in `spacemacs-window-split-delete-function'
 as a means to remove windows.

 When called with a prefix argument, it uses `delete-other-windows'
 as a means to remove windows, regardless of the value in
 `spacemacs-window-split-delete-function'."
  (interactive "P")
  (if purge
      (let ((ignore-window-parameters t))
        (delete-other-windows))
    (funcall spacemacs-window-split-delete-function))
  (balance-windows))
