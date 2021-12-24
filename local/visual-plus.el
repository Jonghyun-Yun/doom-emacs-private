;;; ../Dropbox/emacs/.doom.d/local/visual-plus.el -*- lexical-binding: t -*-

(when (eq doom-theme 'modus-operandi)
  (use-package! modus-themes
    :init
    ;; Add all your customizations prior to loading the themes
    (setq modus-themes-italic-constructs t
          modus-themes-scale-headings t
          modus-themes-mixed-fonts t
          modus-themes-subtle-line-numbers nil
          modus-themes-intense-markup nil
          modus-themes-success-deuteranopia nil
          modus-themes-tabs-accented nil
          modus-themes-inhibit-reload t ; only applies to `customize-set-variable' and related

          modus-themes-fringes nil      ; {nil,'subtle,'intense}

          ;; Options for `modus-themes-lang-checkers' are either nil (the
          ;; default), or a list of properties that may include any of those
          ;; symbols: `straight-underline', `text-also', `background',
          ;; `intense' OR `faint'.
          modus-themes-lang-checkers nil

          ;; Options for `modus-themes-mode-line' are either nil, or a list
          ;; that can combine any of `3d' OR `moody', `borderless',
          ;; `accented', `padded'.
          modus-themes-mode-line '()

          ;; Options for `modus-themes-syntax' are either nil (the default),
          ;; or a list of properties that may include any of those symbols:
          ;; `faint', `yellow-comments', `green-strings', `alt-syntax'
          modus-themes-syntax '(alt-syntax green-strings)

          ;; Options for `modus-themes-hl-line' are either nil (the default),
          ;; or a list of properties that may include any of those symbols:
          ;; `accented', `underline', `intense'
          ;; modus-themes-hl-line '(accented)
          modus-themes-hl-line nil

          ;; Options for `modus-themes-paren-match' are either nil (the
          ;; default), or a list of properties that may include any of those
          ;; symbols: `bold', `intense', `underline'
          modus-themes-paren-match '(bold intense)

          ;; Options for `modus-themes-links' are either nil (the default),
          ;; or a list of properties that may include any of those symbols:
          ;; `neutral-underline' OR `no-underline', `faint' OR `no-color',
          ;; `bold', `italic', `background'
          modus-themes-links '(neutral-underline background)

          ;; Options for `modus-themes-prompts' are either nil (the
          ;; default), or a list of properties that may include any of those
          ;; symbols: `background', `bold', `gray', `intense', `italic'
          modus-themes-prompts nil

          ;; modus-themes-completions 'opinionated ; {nil,'moderate,'opinionated}
          modus-themes-completions 'opinionated ; {nil,'moderate,'opinionated}

          modus-themes-mail-citations nil ; {nil,'faint,'monochrome}

          ;; Options for `modus-themes-region' are either nil (the default),
          ;; or a list of properties that may include any of those symbols:
          ;; `no-extend', `bg-only', `accented'
          modus-themes-region '(bg-only)

          ;; Options for `modus-themes-diffs': nil, 'desaturated,
          ;; 'bg-only, 'deuteranopia, 'fg-only-deuteranopia
          modus-themes-diffs nil

          modus-themes-org-blocks 'tinted-background

          modus-themes-org-agenda ; this is an alist: read the manual or its doc string
          '((header-block . (variable-pitch scale-title))
            (header-date . (grayscale workaholic bold-today))
            (event . (accented scale-small))
            (scheduled . uniform)
            (habit . traffic-light-deuteranopia))

          modus-themes-headings '((t . (rainbow))) ; this is an alist: read the manual or its doc string
          modus-themes-variable-pitch-ui t
          modus-themes-variable-pitch-headings t)
    ;; Load the theme files before enabling a theme
    (modus-themes-load-themes)
    :config
    (modus-themes-load-operandi)
    ;; :bind ("<f5>" . modus-themes-toggle)
    ))

;;; doom-theme
(setq doom-themes-padded-modeline nil
       doom-themes-treemacs-theme "doom-colors")
(setq doom-themes-treemacs-enable-variable-pitch t
      doom-themes-treemacs-line-spacing 1
      doom-themes-treemacs-bitmap-indicator-width 2)
(defface jyun/treemacs-face
  '((t (:family "Roboto Consensed" :height 0.9)))
  "A face to display file/diretory in treemacs."
  :group 'basic-faces)
(setq doom-themes-treemacs-variable-pitch-face 'jyun/treemacs-face)

;;; doom-modeline
;; https://github.com/seagle0128/doom-modeline
(with-eval-after-load 'doom-modeline
  ;; (set-face-attribute 'mode-line nil :family "Noto Sans")
  ;; (set-face-attribute 'mode-line-inactive nil :family "Noto Sans")
  (set-face-attribute 'mode-line nil :inherit 'variable-pitch :height 0.9)
  (set-face-attribute 'mode-line-inactive nil :inherit 'variable-pitch :height 0.9)

  ;; The right side of the modeline is cut off
  (setq all-the-icons-scale-factor 1.1)
  ;; (doom-modeline-def-modeline 'main
  ;;                             '(bar matches buffer-info remote-host buffer-position parrot selection-info)
  ;;                             '(misc-info minor-modes checker input-method buffer-encoding major-mode process vcs "  ")) ; <-- added padding here

  ;; How tall the mode-line should be. It's only respected in GUI.
  ;; If the actual char height is larger, it respects the actual height.
  (setq doom-modeline-height 20)

  ;; to see letters instead of the colored circles
  (setq doom-modeline-modal-icon nil)

  ;; https://github.com/seagle0128/doom-modeline/issues/187#issuecomment-507201556
  ;; (defun my-doom-modeline--font-height ()
  ;;   "Calculate the actual char height of the mode-line."
  ;;   (+ (frame-char-height) 2))
  ;; (advice-add #'doom-modeline--font-height :override #'my-doom-modeline--font-height)

  ;; How wide the mode-line bar should be. It's only respected in GUI.
  (setq doom-modeline-bar-width 2)

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
  (setq doom-modeline-icon nil)

  ;; Whether display the icon for the buffer state. It respects `doom-modeline-icon'.
  (setq doom-modeline-buffer-state-icon nil)

  ;; Whether display the buffer encoding.
  (setq doom-modeline-buffer-encoding nil)

  ;; Whether display the workspace name. Non-nil to display in the mode-line.
  (setq doom-modeline-workspace-name nil)

  ;; Whether display perspective name. Non-nil to display in mode-line.
  (setq doom-modeline-persp-name t)

  ;; If non nil the perspective name is displayed alongside a folder icon.
  (setq doom-modeline-persp-icon nil)

  ;; Whether display the `lsp' state. Non-nil to display in the mode-line.
  (setq doom-modeline-lsp nil)

  ;; Whether display mu4e notifications. It requires `mu4e-alert' package.
  (setq doom-modeline-mu4e nil)
  ;; also enable the start of mu4e-alert
  ;; (mu4e-alert-enable-mode-line-display)

  ;; Whether display the gnus notifications.
  (setq doom-modeline-gnus nil)

  ;; Whether display the IRC notifications. It requires `circe' or `erc' package.
  (setq doom-modeline-irc nil)

  ;; Whether display the environment version.
  (setq doom-modeline-env-version nil))

;;; evil-cursor
;; (defun jyun/evil-state-cursors ()
;;   ;; doom-modeline
;;   ;; (setq +evil--default-cursor-color (face-attribute 'success :foreground))
;;   ;; (setq +evil--insert-cursor-color (face-attribute 'font-lock-keyword-face :foreground))
;;   ;; (setq +evil--emacs-cursor-color (face-attribute 'font-lock-builtin-face :foreground))
;;   ;; (setq +evil--replace-cursor-color (face-attribute 'error :foreground))
;;   ;; (setq +evil--visual-cursor-color (face-attribute 'warning :foreground))
;;   ;; (setq +evil--motion-cursor-color (face-attribute 'font-lock-doc-face :foreground))

;;   (put 'cursor 'evil-normal-color (face-attribute 'success :foreground))
;;   (put 'cursor 'evil-insert-color (face-attribute 'font-lock-keyword-face :foreground))
;;   (put 'cursor 'evil-emacs-color (face-attribute 'font-lock-builtin-face :foreground))
;;   (put 'cursor 'evil-replace-color (face-attribute 'error :foreground))
;;   (put 'cursor 'evil-visual-color (face-attribute 'warning :foreground))
;;   (put 'cursor 'evil-motion-color (face-attribute 'font-lock-doc-face :foreground))

;; ;;; modal icon face color should be found here
;;   ;; doom-modeline-evil-normal-state
;;   ;; doom-modeline-evil-insert-state
;;   ;; doom-modeline-evil-emacs-state
;;   ;; doom-modeline-evil-replace-state
;;   ;; doom-modeline-evil-visual-state
;;   ;; doom-modeline-evil-motion-state
;;   ;; doom-modeline-evil-operator-state
;;   )

;; spacemacs evil cursors
;; (setq
;;  evil-default-cursor '(+evil-default-cursor-fn box)
;;  evil-insert-state-cursor '(+evil-insert-cursor-fn (bar . 2))
;;  evil-emacs-state-cursor '(+evil-emacs-cursor-fn box)
;;  evil-replace-state-cursor '(+evil-replace-cursor-fn (hbar . 2))
;;  evil-visual-state-cursor '(+evil-visual-cursor-fn (hbar . 2))
;;  evil-motion-state-cursor '(+evil-motion-cursor-fn box))

;; (progn
;;   (put 'cursor 'evil-normal-color "DarkGoldenrod2")
;;   (put 'cursor 'evil-insert-color "chartreuse3")
;;   (put 'cursor 'evil-emacs-color "SkyBlue2")
;;   (put 'cursor 'evil-replace-color "chocolate")
;;   (put 'cursor 'evil-visual-color "gray50")
;;   (put 'cursor 'evil-motion-color "plum3")
;;   )

;; (after! doom-modeline
;;   ;; (set-face-attribute 'doom-modeline-buffer-modified nil :foreground nil :inherit 'error)
;;   (custom-set-faces! '(doom-modeline-buffer-modified :inherit (error bold)))
;;   (set-face-attribute 'doom-modeline-evil-normal-state nil :foreground (get 'cursor 'evil-normal-color))
;;   (set-face-attribute 'doom-modeline-evil-insert-state nil :foreground (get 'cursor 'evil-insert-color))
;;   (set-face-attribute 'doom-modeline-evil-emacs-state nil :foreground (get 'cursor 'evil-emacs-color))
;;   (set-face-attribute 'doom-modeline-evil-replace-state nil :foreground (get 'cursor 'evil-replace-color))
;;   (set-face-attribute 'doom-modeline-evil-visual-state nil :foreground (get 'cursor 'evil-visual-color))
;;   (set-face-attribute 'doom-modeline-evil-motion-state nil :foreground (get 'cursor 'evil-motion-color)))

;; (defun +evil-insert-cursor-fn ()
;;   (evil-set-cursor-color (get 'cursor 'evil-insert-color)))
;; (defun +evil-replace-cursor-fn ()
;;   (evil-set-cursor-color (get 'cursor 'evil-replace-color)))
;; (defun +evil-visual-cursor-fn ()
;;   (evil-set-cursor-color (get 'cursor 'evil-visual-color)))
;; (defun +evil-motion-cursor-fn ()
;;   (evil-set-cursor-color (get 'cursor 'evil-motion-color)))

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
