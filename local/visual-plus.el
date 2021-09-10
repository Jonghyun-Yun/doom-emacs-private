;;; ../Dropbox/emacs/.doom.d/local/visual-plus.el -*- lexical-binding: t; -*-

;; (use-package modus-themes
;;   :ensure
;;   :init
;;   ;; Add all your customizations prior to loading the themes
;;   (setq modus-themes-italic-constructs t
;;         modus-themes-completions 'opinionated
;;         modus-themes-variable-pitch-headings t
;;         modus-themes-scale-headings t
;;         modus-themes-variable-pitch-ui t
;;         modus-themes-org-agenda
;;         '((header-block . (variable-pitch scale-title))
;;           (header-date . (grayscale bold-all)))
;;         modus-themes-org-blocks
;;         '(grayscale)
;;         modus-themes-mode-line
;;         '(borderless)
;;         modus-themes-region '(bg-only no-extend))

;;   ;; Load the theme files before enabling a theme
;;   (modus-themes-load-themes)
;;   :config
;;   (modus-themes-load-operandi)
;;   :bind ("<f5>" . modus-themes-toggle))

;; (use-package modus-themes
;;   :ensure                               ; omit this to use the built-in themes
;;   :init
;;   ;; Add all your customizations prior to loading the themes
;;   (setq modus-themes-slanted-constructs t
;;         modus-themes-bold-constructs nil
;;         modus-themes-region 'no-extend)
;;   ;; Load the theme files before enabling a theme (else you get an error).
;;   (modus-themes-load-themes)
;;   :config
;;   ;; Load the theme of your choice:
;;   (modus-themes-load-operandi)
;;   ;; (modus-themes-load-vivendi)
;;   )

(with-eval-after-load 'doom-themes
  ;; Global settings (defaults)
  ;; (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
  ;; doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme doom-theme t)
  ;; (load-theme 'modus-operandi-theme t)
  ;; (load-theme 'modus-vivendi-theme t)

  ;; Enable flashing mode-line on errors
  ;; (doom-themes-visual-bell-config)

  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;; (doom-themes-neotree-config)
  ;; or for treemacs users
  ;; doom-themes package forces treemacs to use a variable-pitch font
  (setq doom-themes-treemacs-enable-variable-pitch t
        treemacs-width 30)
  (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  (doom-themes-treemacs-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; (when (featurep! :ui treemacs)
;;   (add-hook 'dired-mode-hook #'treemacs-icons-dired-mode)
;;   )


;;; doom-modeline
;; https://github.com/seagle0128/doom-modeline
(with-eval-after-load 'doom-modeline
;; The right side of the modeline is cut off
  (setq all-the-icons-scale-factor 1.1)
  ;; (doom-modeline-def-modeline 'main
  ;;                             '(bar matches buffer-info remote-host buffer-position parrot selection-info)
  ;;                             '(misc-info minor-modes checker input-method buffer-encoding major-mode process vcs "  ")) ; <-- added padding here

  ;; How tall the mode-line should be. It's only respected in GUI.
  ;; If the actual char height is larger, it respects the actual height.
  (setq doom-modeline-height 24)

  ;; to see letters instead of the colored circles
  (setq doom-modeline-modal-icon nil)

  ;; https://github.com/seagle0128/doom-modeline/issues/187#issuecomment-507201556
  ;; (defun my-doom-modeline--font-height ()
  ;;   "Calculate the actual char height of the mode-line."
  ;;   (+ (frame-char-height) 2))
  ;; (advice-add #'doom-modeline--font-height :override #'my-doom-modeline--font-height)

  ;; How wide the mode-line bar should be. It's only respected in GUI.
  (setq doom-modeline-bar-width 3)

  ;; The limit of the window width.
  ;; If `window-width' is smaller than the limit, some information won't be displayed.
  (setq doom-modeline-window-width-limit fill-column)

  ;; How to detect the project root.
  ;; The default priority of detection is `ffip' > `projectile' > `project'.
  ;; nil means to use `default-directory'.
  ;; The project management packages have some issues on detecting project root.
  ;; e.g. `projectile' doesn't handle symlink folders well, while `project' is unable
  ;; to hanle sub-projects.
  ;; You can specify one if you encounter the issue.
  (setq doom-modeline-project-detection 'ffip)

  ;; Determines the style used by `doom-modeline-buffer-file-name'.
  ;;
  ;; Given ~/Projects/FOSS/emacs/lisp/comint.el
  ;;   auto => emacs/lisp/comint.el (in a project) or comint.el
  ;;   truncate-upto-project => ~/P/F/emacs/lisp/comint.el
  ;;   truncate-from-project => ~/Projects/FOSS/emacs/l/comint.el
  ;;   truncate-with-project => emacs/l/comint.el
  ;;   truncate-except-project => ~/P/F/emacs/l/comint.el
  ;;   truncate-upto-root => ~/P/F/e/lisp/comint.el
  ;;   truncate-all => ~/P/F/e/l/comint.el
  ;;   relative-from-project => emacs/lisp/comint.el
  ;;   relative-to-project => lisp/comint.el
  ;;   file-name => comint.el
  ;;   buffer-name => comint.el<2> (uniquify buffer name)
  ;;
  ;; If you are experiencing the laggy issue, especially while editing remote files
  ;; with tramp, please try `file-name' style.
  ;; Please refer to https://github.com/bbatsov/projectile/issues/657.
  (setq doom-modeline-buffer-file-name-style 'auto)

  ;; Whether display icons in the mode-line. Respects `all-the-icons-color-icons'.
  ;; While using the server mode in GUI, should set the value explicitly.
  (setq doom-modeline-icon t)

  ;; Whether display the buffer encoding.
  (setq doom-modeline-buffer-encoding nil)

  ;; Whether display perspective name. Non-nil to display in mode-line.
  (setq doom-modeline-persp-name t)

  ;; Whether display the `lsp' state. Non-nil to display in the mode-line.
  (setq doom-modeline-lsp t)

  ;; Whether display mu4e notifications. It requires `mu4e-alert' package.
  (setq doom-modeline-mu4e t)

  ;; Whether display the gnus notifications.
  (setq doom-modeline-gnus nil)

  ;; Whether display the IRC notifications. It requires `circe' or `erc' package.
  (setq doom-modeline-irc nil)

  ;; Whether display the environment version.
  (setq doom-modeline-env-version nil))

;;; evil-cursor
(defun jyun/evil-state-cursors ()
  ;; doom-modeline
  ;; (setq +evil--default-cursor-color (face-attribute 'success :foreground))
  ;; (setq +evil--insert-cursor-color (face-attribute 'font-lock-keyword-face :foreground))
  ;; (setq +evil--emacs-cursor-color (face-attribute 'font-lock-builtin-face :foreground))
  ;; (setq +evil--replace-cursor-color (face-attribute 'error :foreground))
  ;; (setq +evil--visual-cursor-color (face-attribute 'warning :foreground))
  ;; (setq +evil--motion-cursor-color (face-attribute 'font-lock-doc-face :foreground))

  (put 'cursor 'evil-normal-color (face-attribute 'success :foreground))
  (put 'cursor 'evil-insert-color (face-attribute 'font-lock-keyword-face :foreground))
  (put 'cursor 'evil-emacs-color (face-attribute 'font-lock-builtin-face :foreground))
  (put 'cursor 'evil-replace-color (face-attribute 'error :foreground))
  (put 'cursor 'evil-visual-color (face-attribute 'warning :foreground))
  (put 'cursor 'evil-motion-color (face-attribute 'font-lock-doc-face :foreground))

;;; modal icon face color should be found here
  ;; doom-modeline-evil-normal-state
  ;; doom-modeline-evil-insert-state
  ;; doom-modeline-evil-emacs-state
  ;; doom-modeline-evil-replace-state
  ;; doom-modeline-evil-visual-state
  ;; doom-modeline-evil-motion-state
  ;; doom-modeline-evil-operator-state
  )

;; spacemacs evil cursors
(setq
 evil-default-cursor '(+evil-default-cursor-fn box)
 evil-insert-state-cursor '(+evil-insert-cursor-fn (bar . 2))
 evil-emacs-state-cursor '(+evil-emacs-cursor-fn box)
 evil-replace-state-cursor '(+evil-replace-cursor-fn (hbar . 2))
 evil-visual-state-cursor '(+evil-visual-cursor-fn (hbar . 2))
 evil-motion-state-cursor '(+evil-motion-cursor-fn box))

;; (setq +evil--default-cursor-color )
;; (setq +evil--emacs-cursor-color "SkyBlue2")
;; (defvar +evil--insert-cursor-color "chartreuse3")
;; (defvar +evil--replace-cursor-color "chocolate")
;; (defvar +evil--visual-cursor-color "gray")
;; (defvar +evil--motion-cursor-color "plum3")

(put 'cursor 'evil-normal-color "DarkGoldenrod2")
(put 'cursor 'evil-insert-color "SkyBlue2")
(put 'cursor 'evil-emacs-color "chartreuse3")
(put 'cursor 'evil-replace-color "chocolate")
(put 'cursor 'evil-visual-color "gray")
(put 'cursor 'evil-motion-color "plum3")

;; (defun +evil-insert-cursor-fn ()
;;   (evil-set-cursor-color +evil--insert-cursor-color))
;; (defun +evil-replace-cursor-fn ()
;;   (evil-set-cursor-color +evil--replace-cursor-color))
;; (defun +evil-visual-cursor-fn ()
;;   (evil-set-cursor-color +evil--visual-cursor-color))
;; (defun +evil-motion-cursor-fn ()
;;   (evil-set-cursor-color +evil--motion-cursor-color))

(defun +evil-insert-cursor-fn ()
  (evil-set-cursor-color (get 'cursor 'evil-insert-color)))
(defun +evil-replace-cursor-fn ()
  (evil-set-cursor-color (get 'cursor 'evil-replace-color)))
(defun +evil-visual-cursor-fn ()
  (evil-set-cursor-color (get 'cursor 'evil-visual-color)))
(defun +evil-motion-cursor-fn ()
  (evil-set-cursor-color (get 'cursor 'evil-motion-color)))

;; (use-package visual-regexp
;;   :defer t
;;   :commands (vr/replace vr/query-replace)
;;   :config
;;   (define-key global-map (kbd "C-c r") 'vr/replace)
;;   (define-key global-map (kbd "C-c q") 'vr/query-replace)
;;   ;; if you use multiple-cursors, this is for you:
;;   ;; (define-key global-map (kbd "C-c m") 'vr/mc-mark)
;;   )

;;; unicode
(after! unicode-fonts
  ;; fix Hangul fonts for Jamo
  (dolist (unicode-block '("Hangul Compatibility Jamo"
                           "Hangul Jamo"
                           "Hangul Jamo Extended-A"
                           "Hangul Jamo Extended-B"
                           "Hangul Syllables"))
    (push "Sarasa Mono K" (cadr (assoc unicode-block unicode-fonts-block-font-mapping))))
  ;; (push "Noto Sans CJK KR" (cadr (assoc unicode-block unicode-fonts-block-font-mapping))))
  ;; (push "Source Han Sans K" (cadr (assoc unicode-block unicode-fonts-block-font-mapping))))
  ;; (push "Source Han Serif K" (cadr (assoc unicode-block unicode-fonts-block-font-mapping))))
  )

;; Dropbox sync changes hangul encoding to NFD, which results in 한글 자소분리 in dired and other modes
;; https://tt.kollhong.com/79
;; https://nullprogram.com/blog/2014/06/13/
(when IS-MAC
  (use-package! ucs-normalize
    :config
    (set-file-name-coding-system 'utf-8-hfs)))
