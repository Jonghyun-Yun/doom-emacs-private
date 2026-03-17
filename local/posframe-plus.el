;;; ../Dropbox/emacs/.doom.d/local/posframe-plus.el -*- lexical-binding: t; -*-

;;; posframe
;; (use-package! transient-posframe
;;   :config
;;   (transient-posframe-mode))
;; (use-package! company-posframe
;;   :hook (company-mode . company-posframe-mode)
;;   :config
;;   (remove-hook 'company-mode-hook #'company-box-mode)
;;   )

;;;; hydra-posframe
(use-package! hydra-posframe
  :after hydra
  :if IS-GUI
  :config
  (hydra-posframe-mode 1)
  ;; :hook (after-init . hydra-posframe-enable)
  (setq hydra-posframe-parameters
        '((left-fringe . 8)
          (right-fringe . 8)))
  ;; (setq hydra-posframe-poshandler 'posframe-poshandler-frame-bottom-center)
  ;; (setq hydra-posframe-poshandler 'posframe-poshandler-frame-bottom-left-corner)
  (setq hydra-posframe-poshandler 'posframe-poshandler-frame-top-right-corner))

;;;; which-key-posframe
(use-package! which-key-posframe
  :after which-key
  :if IS-GUI
  :config
  (which-key-posframe-mode 1)
  ;; (setq which-key-posframe-poshandler 'posframe-poshandler-frame-bottom-center)
  (setq which-key-posframe-poshandler 'posframe-poshandler-frame-top-left-corner)
  ;; (setq which-key-posframe-poshandler 'posframe-poshandler-frame-top-right-corner)
  (setq which-key-posframe-parameters
        '((left-fringe . 8)
          (right-fringe . 8)))
  ;; fix wrong `height'
  (defun which-key-posframe--show-buffer (act-popup-dim)
  "Show which-key buffer when popup type is posframe.
                  Argument ACT-POPUP-DIM includes the dimension, (height . width)
                  of the buffer text to be displayed in the popup"
  (when (posframe-workable-p)
    (save-window-excursion
      (posframe-show
       which-key--buffer
       :font which-key-posframe-font
       :position (point)
       :poshandler which-key-posframe-poshandler
       :background-color (face-attribute 'which-key-posframe :background nil t)
       :foreground-color (face-attribute 'which-key-posframe :foreground nil t)
       ;; :height (+ 1 (car act-popup-dim))
       :width (cdr act-popup-dim)
       :internal-border-width which-key-posframe-border-width
       :internal-border-color (face-attribute 'which-key-posframe-border :background nil t)
       :override-parameters which-key-posframe-parameters)))))

;;;; vertigo posframe
;; (use-package! vertico-posframe
;;   :after vertico
;;   :if IS-GUI
;;   :config
;;   (vertico-posframe-mode 1)
;;   (setq vertico-posframe-poshandler #'posframe-poshandler-frame-bottom-center)
;;   ;; (setq vertico-posframe-poshandler #'posframe-poshandler-frame-top-center)
;;   (setq vertico-posframe-parameters
;;         '((left-fringe . 8)
;;           (right-fringe . 8))))

;; (after! vertico-posframe
;;   (setq vertico-posframe-poshandler #'posframe-poshandler-frame-bottom-center)
;;   ;; (setq vertico-posframe-parameters
;;   ;;       '((left-fringe . 8)
;;   ;;         (right-fringe . 8)))
;;   )
