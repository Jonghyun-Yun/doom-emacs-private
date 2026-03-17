;;; ../Dropbox/emacs/.doom.d/local/font-face-plus.el -*- lexical-binding: t; -*-


;; ;; thinning all faces
;;;; (after! doom-modeline
;;;;   (add-hook! '(doom-load-theme-hook window-setup-hook)
;;;;              ;; #'jyun/doom-modeline-height
;;;;              ;; #'jyun/thin-all-faces
;;;;              ;; #'jyun/evil-state-cursors
;;;;              ))
;;;;
;;;; ;;;; mixed-pitch-mode
;;;; ;; (add-hook 'doom-init-ui-hook #'init-mixed-pitch-h)
;;;;
;;;;
;;;; (when (modulep! :ui zen)
;;;;   (add-to-list '+zen-mixed-pitch-modes 'latex-mode)
;;;;   (setq +zen-text-scale 0.8) ;; The text-scaling level for writeroom-mode
;;;;   )
;;;;
;;;; ;;;; outline faces
;;;; ;; (custom-set-faces!
;;;; ;;   '(outline-1 :weight semi-bold :height 1.25)
;;;; ;;   '(outline-2 :weight semi-bold :height 1.15)
;;;; ;;   '(outline-3 :weight semi-bold :height 1.12)
;;;; ;;   '(outline-4 :weight semi-bold :height 1.09)
;;;; ;;   '(outline-5 :weight semi-bold :height 1.06)
;;;; ;;   '(outline-6 :weight semi-bold :height 1.03)
;;;; ;;   '(outline-8 :weight semi-bold)
;;;; ;;   '(outline-9 :weight semi-bold))
;;;; ;; (custom-set-faces!
;;;; ;;   '(outline-1 :inherit 'variable-pitch :weight light :height 1.5)
;;;; ;;   '(outline-2 :inherit 'variable-pitch :weight light :height 1.3)
;;;; ;;   '(outline-3 :weight light :height 1.2)
;;;; ;;   '(outline-4 :weight regular :height 1.1)
;;;; ;;   '(outline-5 :weight regular :height 1.05)
;;;; ;;   '(outline-6 :weight semi-bold :height 1.05)
;;;; ;;   '(outline-7 :weight semi-bold :height 1.05)
;;;; ;;   '(outline-8 :weight semi-bold :height 1.05)
;;;; ;; org-title
;;;; ;; (custom-set-faces!
;;;; ;;   '(org-document-title :height 1.2))
;;;; ;; deadlines in the error face when they're passed.
;;;; ;; (setq org-agenda-deadline-faces
;;;; ;;       '((1.001 . error)
;;;; ;;         (1.0 . org-warning)
;;;; ;;         (0.5 . org-upcoming-deadline)
;;;; ;;         (0.0 . org-upcoming-distant-deadline)))
;;;;
