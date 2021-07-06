;;; ../Dropbox/emacs/.doom.d/autoload/ui.el -*- lexical-binding: t; -*-


;;;###autoload
(defun jyun/thin-all-faces ()
  "Change all faces to be lighter."
  (mapc
   (lambda (face)
     (when (eq (face-attribute face :weight) 'light)
       (set-face-attribute face nil :weight 'extra-light))
     (when (eq (face-attribute face :weight) 'semi-light)
       (set-face-attribute face nil :weight 'light))
     (when (eq (face-attribute face :weight) 'normal)
       (set-face-attribute face nil :weight 'semi-light))
     (when (eq (face-attribute face :weight) 'semi-bold)
       (set-face-attribute face nil :weight 'normal))
     (when (eq (face-attribute face :weight) 'bold)
       (set-face-attribute face nil :weight 'semi-bold)))

   (face-list)))


;;;###autoload
(defun jyun/thick-all-faces ()
  "Change all faces to be bolder."
  (mapc
   (lambda (face)
     (when (eq (face-attribute face :weight) 'extra-light)
       (set-face-attribute face nil :weight 'light))
     (when (eq (face-attribute face :weight) 'light)
       (set-face-attribute face nil :weight 'semi-light))
     (when (eq (face-attribute face :weight) 'semi-light)
       (set-face-attribute face nil :weight 'normal))
     (when (eq (face-attribute face :weight) 'normal)
       (set-face-attribute face nil :weight 'semi-bold))
     (when (eq (face-attribute face :weight) 'semi-bold)
       (set-face-attribute face nil :weight 'bold)))

   (face-list)))


;;;###autoload
(defun jyun/thin-variable-pitch-faces ()
  "Change variable pitch faces to be lighter."
  ;; (setq variable-pitch-faces nil)
  (let ((variable-pitch-faces nil)
        (all-faces (face-list)))
    (dolist (face all-faces)
      (unless (memq face mixed-pitch-fixed-pitch-faces)

        (push 'variable-pitch-faces face)))
  (mapc
   (lambda (face)
     (when (eq (face-attribute face :weight) 'light)
       (set-face-attribute face nil :weight 'extra-light))
     (when (eq (face-attribute face :weight) 'semi-light)
       (set-face-attribute face nil :weight 'light))
     (when (eq (face-attribute face :weight) 'normal)
       (set-face-attribute face nil :weight 'semi-light))
     (when (eq (face-attribute face :weight) 'semi-bold)
       (set-face-attribute face nil :weight 'normal))
     (when (eq (face-attribute face :weight) 'bold)
       (set-face-attribute face nil :weight 'semi-bold)))

   variable-pitch-faces)))


;;;###autoload
(defun jyun/find-variable-pitch-faces ()
  "Create a list named `variable-pitch-faces'."
  (setq variable-pitch-faces nil)
  (let ((all-faces (face-list)))
    (dolist (face all-faces)
      (unless (memq face mixed-pitch-fixed-pitch-faces)
        (add-to-list 'variable-pitch-faces face)))))


;;;###autoload
(defun jyun/doom-modeline-height ()
  "Cut doom-modeline paddings to reduce its height."
  (let ((height doom-modeline-height))
    (set-face-attribute 'mode-line nil :height (* 10 height))
    (set-face-attribute 'mode-line-inactive nil :height (* 10 height))
    ;; (doom/reset-font-size)
    )
  )
