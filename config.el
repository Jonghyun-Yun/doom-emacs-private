;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Jonghyun Yun"
      user-mail-address "jonghyun.yun@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; "Iosevka SS05" ;; Monospace, Fira Mono Style
;; "Iosevka SS08" ;; Monospace, Pragmata Pro Style
;; "Iosevka SS09" ;; Monospace, Source Code Pro Style
;; "Iosevka SS13" ;; Monospace, Lucida Style

;; (setq
;;  doom-font (font-spec :family "Iosevka SS08" :size 28 :weight 'light :width 'expanded)
;;  doom-variable-pitch-font (font-spec :family "Iosevka Sparkle" :weight 'light :width 'expanded)
;;  ;; doom-unicode-font (font-spec :family "Sarasa Mono K" :weight 'light :width 'expanded)
;;  )

;; (setq
;;  doom-font (font-spec :family "Iosevka SS08" :size 24 :weight 'light)
;;  doom-big-font (font-spec :family "Iosevka SS08" :size 36 :weight 'light)
;;  ;; doom-variable-pitch-font (font-spec :family "Iosevka Etoile" :weight 'light)
;;  doom-variable-pitch-font (font-spec :family "Iosevka Aile" :weight 'light)
;;  doom-unicode-font (font-spec :family "Sarasa Mono K" :weight 'light)
;;  doom-serif-font (font-spec :family "Iosevka Slab" :weight 'light))

(setq
 doom-font (font-spec :family "JetBrains Mono" :size 24 :weight 'light)
 doom-big-font (font-spec :family "JetBrains Mono" :size 36 :weight 'light)
 ;; doom-font (font-spec :family "Fira Code" :size 24 :weight 'light)
 ;; doom-big-font (font-spec :family "Fira Code" :size 36 :weight 'light)
 doom-variable-pitch-font (font-spec :family "Overpass" :size 24 :weight 'light)
 doom-unicode-font (font-spec :family "JuliaMono" :weight 'light)
 doom-serif-font (font-spec :family "IBM Plex Mono" :weight 'light)
 )

(setq variable-pitch-serif-font (font-spec :family "Alegreya" :size 27))
;; (setq variable-pitch-serif-font (font-spec :family "Libre Baskerville" :size 23))
;; (setq variable-pitch-serif-font (font-spec :family "Libertinus Serif" :size 27))

;; missing out on the following Alegreya ligatures:
(set-char-table-range composition-function-table ?f '(["\\(?:ff?[fijlt]\\)" 0 font-shape-gstring]))
(set-char-table-range composition-function-table ?T '(["\\(?:Th\\)" 0 font-shape-gstring]))

;; (setq
;;  doom-font (font-spec :family "Fira Code" :size 24 :weight 'light)
;;  doom-variable-pitch-font (font-spec :family "FiraGO" :weight 'light)
;;  doom-unicode-font (font-spec :family "Noto Serif CJK KR" :weight 'light)
;;  )

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-nord-light)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;; (lambda ()
;;   (let ((default-directory (expand-file-name "packages" doom-private-dir)))
;;     (normal-top-level-add-subdirs-to-load-path))
;;   )

;; ;; ;; ox-hugo looks for `ox-ravel' during the incremental org loading
;; (add-hook 'after-init-hook #'(lambda ()
;;                                (load (expand-file-name "packages/ox-ravel/ox-ravel" doom-private-dir))
;;                                ))

;; (load! "lisp/idle")

(with-eval-after-load 'doom-themes
  :config
  ;; Global settings (defaults)
  ;; (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
  ;; doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; (load-theme doom-theme t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

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

;; disable flycheck by default
(remove-hook 'doom-first-buffer-hook #'global-flycheck-mode)

;; make-frame doesn't create a new persp
;;   (remove-hook 'after-make-frame-functions #'persp-init-new-frame)
;; (setq persp-add-buffer-on-after-change-major-mode 'free
;; persp-add-buffer-on-after-change-major-mode-filter-functions nil
;; persp-nil-name "main")
;; )

(after! projectile
  (projectile-add-known-project "~/Dropbox/research/lsjm-art")
  (projectile-add-known-project "~/Dropbox/utsw-projects/HITS-CLIP")
  (projectile-add-known-project "~/OneDrive/research/lapf")
  ;; (projectile-add-known-project "~/research/s.ham/RAS")
  (projectile-add-known-project "~/research/mj.jeon")
  )

;; emacs 27.2 riksy local variables
;; old tricks stopped working. risky variables are ignored, and dunno how to make them safe...
;; instead I can safely eval risky variables...
(setq enable-local-eval t)
;; (add-to-list 'safe-local-eval-forms '(add-hook 'after-save-hook #'jyun/magit-stage-commit-push-origin-master))
;; (add-to-list 'safe-local-eval-forms '(add-hook 'after-save-hook #'jyun/push-overleaf))
;; (add-to-list 'safe-local-eval-forms
;;              '(add-hook 'projectile-after-switch-project-hook (lambda () (jyun/magit-pull-overleaf overleaf-directory))))
;; (add-to-list 'safe-local-eval-forms '(add-hook 'after-save-hook (lambda () (jyun/magit-push-overleaf overleaf-directory))))
;; (add-to-list 'safe-local-eval-forms '(setq overleaf-directory (ffip-project-root)))

(setq safe-local-eval-forms
      (append safe-local-eval-forms
              '((setq overleaf-directory (ffip-project-root))
                (add-hook 'projectile-after-switch-project-hook (lambda () (jyun/magit-pull-overleaf overleaf-directory)))
                (add-hook 'after-save-hook (lambda () (jyun/magit-push-overleaf overleaf-directory)))
                )))

;; https://github.com/hlissner/doom-emacs/issues/1317#issuecomment-483884401
;; (remove-hook 'ivy-mode-hook #'ivy-rich-mode)
;; (setq ivy-height 15)

(setq ispell-program-name "hunspell"
      ispell-check-comments nil
      ispell-hunspell-dict-paths-alist
      '(
        ("en_US" "/Users/yunj/Library/Spelling/en_US.aff")
        ("ko" "/Users/yunj/Library/Spelling/ko.aff")
        ("en_US-med" "/Users/yunj/Library/Spelling/en_US-med.aff"))
      ispell-hunspell-dictionary-alist
      '(
        ("ko_KR"
         "[가-힣]"
         "[^가-힣]"
         "[0-9a-zA-Z]" nil
         ("-d" "ko"))
        ("en_US"
         "[[:alpha:]]"
         "[^[:alpha:]]"
         "['.0-9’-]" t
         ;; "[']" t
         ("-d" "en_US,en_US-med")
         nil utf-8))
      ispell-dictionary-alist ispell-hunspell-dictionary-alist)
;; (ispell-set-spellchecker-params) ; Initialize variables and dicts alists
(setq ispell-local-dictionary "en_US")
(setq ispell-personal-dictionary "/Users/yunj/.hunspell_en_US")
;; (setq ispell-personal-dictionary "/Users/yunj/.aspell.en.pws")

(require 'spell-fu) ;; otherwise error b/c `+spell/previous-error' is not defined.
(setq spell-fu-idle-delay 0.5)
;; (global-spell-fu-mode -1)

;; I need these lists for langtool!
(setf (alist-get 'org-mode +spell-excluded-faces-alist)
      '(
        org-level-1
        org-document-info
        org-list-dt
        org-block
        org-block-begin-line
        org-block-end-line
        org-code
        org-date
        org-formula
        org-latex-and-related
        org-link
        org-meta-line
        org-property-value
        org-ref-cite-face
        org-special-keyword
        org-tag
        org-todo
        org-todo-keyword-done
        org-todo-keyword-habt
        org-todo-keyword-kill
        org-todo-keyword-outd
        org-todo-keyword-todo
        org-todo-keyword-wait
        org-verbatim
        org-property-drawer-re
        org-ref-cite-re
        org-ref-ref-re
        org-ref-label-re
        org-latex-math-environments-re
        "\\`[ 	]*\\\\begin{\\(?:align*\\|equation*\\|eqnarray*\\)\\*?}"
        font-lock-comment-face
        ))

(setf (alist-get 'LaTeX-mode +spell-excluded-faces-alist)
      '(
        font-lock-function-name-face
        font-lock-variable-name-face
        font-lock-keyword-face
        font-lock-constant-face
        font-lock-comment-face
        font-latex-math-face
        font-latex-sedate-face))
;; font-latex-verbatim-face
;; font-latex-warning-face

(with-eval-after-load 'hydra
  (load! "lisp/hydra-plus"))

(load! "bindings")

(load! "lisp/mu4e-plus")
;; no accumulating drafts
(add-hook 'mu4e-compose-mode-hook #'(lambda () (auto-save-visited-mode -1)))
(after! org-msg
  (setq org-msg-options
        (concat org-msg-options " num:nil tex:dvipng ^:{} \\n:t")
        org-msg-startup "hidestars indent inlineimages"
        org-msg-default-alternatives '(text html)
        org-msg-convert-citation t
        ;; msg auto completion
        org-msg-greeting-fmt "\nHi *%s*,\n\n"
        org-msg-recipient-names '(("jonghyun.yun@gmail.com" . "Jonghyun"))
        org-msg-greeting-name-limit 3
        org-msg-signature "

 Cheers,

 #+begin_signature
 -- *Jonghyun* \\\\
 #+end_signature")
  )

(load! "lisp/latex-plus")
;; (setq +latex-viewers '(skim pdf-tools))
(setq +latex-viewers '(pdf-tools skim))
;; (add-hook! 'LaTeX-mode-hook #'(lambda () (cdlatex-mode 1)))
(setq TeX-command-extra-options "-shell-escape")

;; ;; trying to turn off `rainbow-delimiters-mode'. not working..
;; (add-hook! 'LaTeX-mode-hook #'(lambda () (rainbow-delimiters-mode -1)))
;; (remove-hook 'TeX-update-style-hook #'rainbow-delimiters-mode)

(after! cdlatex
  (setq cdlatex-math-symbol-alist
        '((?: ("\\cdots" "\\ldots"))
          )
        ))

(load! "lisp/ess-plus")

(with-eval-after-load 'ess
  ;; disable assignment fix (= to <-)
  ;; https://github.com/jimhester/lintr
  (setq flycheck-lintr-linters
        "with_defaults(line_length_linter(120), assignment_linter = NULL, object_name_linter = NULL)")

  (evil-set-initial-state 'inferior-ess-r-mode 'emacs)
  (setq ess-assign-list '(" <- " " = " " -> ")
        ess-r-smart-operators t)
  ;; ess-assign
  (defvar ess-assign-key "\M--"
    "Call `ess-insert-assign'.")

  (with-eval-after-load 'ess-r-mode
    (define-key ess-r-mode-map ess-assign-key #'ess-insert-assign))
  ;; (add-hook 'inferior-ess-r-mode-hook
  ;;           #'(lambda () (define-key inferior-ess-r-mode-map ess-assign-key #'ess-insert-assign)))
  )

;; (evil-set-initial-state 'org-agenda-mode 'emacs)
;; (load! "lisp/stan-config") ;; :private stan module

;; passwords to be accessible
(use-package! pass)

;; information for debugging authentication in *Messages* buffer
;; (setq auth-source-debug t)

(after! plantuml-mode
  (setq plantuml-jar-path "/usr/local/Cellar/plantuml/*/libexec/plantuml.jar"
        org-plantuml-jar-path plantuml-jar-path))

;; prevent some cases of Emacs flickering
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

;;; maximize frame at startup
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
;; OS X native full screen
;; (add-to-list 'initial-frame-alist '(fullscreen . fullscreen))

;; Backups & Autosave
;; (auto-save-visited-mode +1)
(setq auto-save-default t
      create-lockfiles t
      make-backup-files nil
      truncate-string-ellipsis "…"               ; Unicode ellispis are nicer than "...", and also save /precious/ space
      yas-triggers-in-field t ;snippets inside snippets
      )

(setq company-idle-delay nil
      company-tooltip-limit 10
      ;; company-box-enable-icon nil ;;disable all-the-icons
      )

;;; org-mode
(after! org
  ;; (remove-hook 'org-mode-hook #'org-superstar-mode)
  (when (featurep! :lang org +pretty)
    ;; org-superstar-headline-bullets-list '("♠" "♥" "♦" "♣" "◉" "▶" "✚" "✸")
    (setq org-superstar-headline-bullets-list '("♠" "♡" "♦" "♧")
          org-superstar-remove-leading-stars nil
          ))

  ;; background color for org-latex
  ;; (+org-refresh-latex-background-h)
  (setq
   org-export-in-background t                  ; async export by default

   org-fontify-quote-and-verse-blocks nil
   org-fontify-whole-heading-line nil

   org-journal-encrypt-journal t
   ;; org-hide-leading-stars t
   ;; org-startup-indented nil

   ;; org-ellipsis " ▾ "
   ;; org-ellipsis " ▼ "
   org-ellipsis "  ⏷  "
   org-indent-indentation-per-level 1
   org-adapt-indentation nil

   ;; tag indent
   ;; org-tags-column -77

   ;; org export global setting
   org-export-with-toc nil
   ;; custom_id -> \label
   ;; org-latex-prefer-user-labels t
   org-log-done 'time
   ;; latex highlight
   ;; org-highlight-latex-and-related '(native)
   ;; don't ask to follow elisp link
   org-confirm-elisp-link-function nil
   )

  (setq org-highlight-latex-and-related '(native script entities))
  (add-to-list 'org-src-block-faces '("latex" (:inherit default :extend t)))
  ;; (setq org-format-latex-options
  ;;       (plist-put org-format-latex-options :background "Transparent"))

  ;; (setq org-insert-heading-respect-content nil)

  ;; cdltaex will ignore inline math $...$
  ;; (plist-put org-format-latex-options :matchers '("begin" "$1" "$" "$$" "\\(" "\\[")) ;; drop "$"

  (setq org-preview-latex-image-directory "ltximg/"
        ;; org-archive-location ".archive/%s::"
        )

  (defvar jyun/org-latex-preview-scale 1.5
    "A scaling factor for the size of images created from LaTeX fragments.")
  (plist-put org-format-latex-options :scale jyun/org-latex-preview-scale)

  ;; default attach folder
  ;; (after! org-attach
  ;;   (setq
  ;;    org-attach-id-dir "data/"))

  ;; visual-mode tab binds back to org-cycle
  (remove-hook 'org-tab-first-hook #'+org-yas-expand-maybe-h)

  ;; insert-mode tab binds back to org-cycle
  (remove-hook 'org-tab-first-hook #'+org-indent-maybe-h)
  )

(add-hook 'org-mode-hook (defun jyun/org-mode-hook-collection ()
                           (progn
                             ;; (rainbow-delimiters-mode-disable)
                             (setq-local langtool-ignore-fonts
                                         (alist-get 'org-mode +spell-excluded-faces-alist))
                             )))

(after! ox
  (setq org-beamer-theme "[progressbar=foot]metropolis"
        org-beamer-frame-level 4
        org-latex-tables-booktabs t
        ))

(load! "lisp/org-plus")
(load! "lisp/ligature")

;; Set LaTeX preview image size for Org and LaTeX buffers.
(after! preview
  ;; latex-preview size
  (setq preview-scale 1.5)
  ;; (set 'preview-scale-function 1.75)
  )

(with-eval-after-load 'org-roam
  (setq org-roam-graph-viewer "/Applications/Firefox.app/Contents/MacOS/firefox-bin"
        +org-roam-open-buffer-on-find-file nil)
  ;; (setq org-roam-graph-executable "neato")
  ;; (setq org-roam-graph-extra-config '(("overlap" . "false")))
  )

;; Dropbox sync changes hangul encoding to NFD, which results in 한글 자소분리 in dired and other modes
;; https://tt.kollhong.com/79
;; https://nullprogram.com/blog/2014/06/13/
(when IS-MAC
  (use-package! ucs-normalize
    :config
    (set-file-name-coding-system 'utf-8-hfs)))

;; ;; improve slow scrolling?
;; (use-package! hl-line+
;;   :config
;;   (hl-line-when-idle-interval 0.5)
;;   (toggle-hl-line-when-idle 1))

;; no need: gcmh: https://github.com/emacsmirror/gcmh
;; (add-hook 'focus-out-hook #'garbage-collect)
(setq garbage-collection-messages nil)

;; no key stroke for exiting INSERT mode: doom default jk
(setq evil-escape-key-sequence "jk"
      evil-escape-delay 0.1)
;; to escape from emacs state
(key-chord-mode 1)
(key-chord-define evil-emacs-state-map evil-escape-key-sequence 'evil-escape)

;; set korean keyboard layout
;; C-\ to switch input-method
(setq default-input-method "korean-hangul390")
(global-set-key (kbd "s-j s-k") 'evil-escape)
(global-set-key (kbd "s-j k") 'evil-escape)
;; (key-chord-define-global "45" 'evil-escape)

;; emacs-mode shift can be used for C-SPC
;; didn't know it exists
;; (setq shift-select-mode t)

(with-eval-after-load 'alert
  ;; calendar notification
  ;; (setq alert-default-style 'osx-notifier)
  (setq alert-default-style 'notifier))


(with-eval-after-load 'deft
  (setq deft-extensions '("org" "md" "txt")
        deft-directory org-directory
        ;; include subdirectories
        deft-recursive t))

;; (setq which-key-allow-multiple-replacements t)

(with-eval-after-load 'which-key
  ;; Allow C-h to trigger which-key before it is done automatically
  ;; (setq which-key-show-early-on-C-h t)
  ;; make sure which-key doesn't show normally but refreshes quickly after it is
  ;; triggered.
  (setq which-key-idle-delay 1) ;; with 800kb garbage-collection
  ;; (setq which-key-idle-secondary-delay 0.05)
  ;; (which-key-mode)
  ;; (define-key which-key-mode-map (kbd "C-h") 'which-key-C-h-dispatch)
  (pushnew!
   which-key-replacement-alist
   '(("" . "\\`+?evil[-:]?\\(?:a-\\)?\\(.*\\)") . (nil . "◂\\1"))
   '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . "◃\\1"))
   )
  )


;; (evil-set-initial-state 'elfeed-search-mode 'emacs)
;; (evil-set-initial-state 'elfeed-shoe-mode 'emacs)

;; (setq save-place-forget-unreadable-files t) ;; emacs is slow to exit after enabling saveplace

;; disable recentf-cleanup on Emacs start, because it can cause
;; problems with remote files
;; (setq recentf-auto-cleanup 'never)
;; (setq recentf-auto-cleanup 300)         ;; long recentf slow down emacs

;; Delete duplicated entries in autosaves of minibuffer history
;; (setq history-delete-duplicates t)

;; ;; https://github.com/kaz-yos/emacs/blob/master/init.d/500_recentf-related.el
;; (setq recentf-max-saved-items 300)
;; (setq recentf-max-menu-items 15)
(setq recentf-exclude '("recentf_.*$"
                        ;; ".*/elpa/.*"
                        ".*\\.maildir.*"
                        "/var/folders/.*"
                        ".*company-statistics.*"))

;; ;; speed up comint
;; (setq gud-gdb-command-name "gdb --annotate=1"
;;       large-file-warning-threshold nil
;;       line-move-visual nil)

;; Other options
;; replace highlighted text with what I type
;; (delete-selection-mode 1)

(setq display-time-24hr-format t
      mouse-autoselect-window nil
      ;; indicate-unused-lines nil
      ;; spacemacs value of parameters
      scroll-conservatively 0)
(setq display-time-format "%R %a %b %d"
      display-time-default-load-average nil
      display-time-world-list
      '(("America/Los_Angeles" "Seattle")
        ("America/New_York" "New York")
        ("Europe/London" "London")
        ;; ("Pacific/Auckland" "Auckland")
        ("Asia/Seoul" "Seoul"))
      display-time-world-time-format "%a %b %d %Y %R %Z")
(display-time-mode 1)
(blink-cursor-mode 1)
;; (display-battery-mode 1)


;; (add-hook 'before-save-hook 'time-stamp)

;; (global-set-key [C-wheel-up]  'ignore)
;; (global-set-key [C-wheel-down] 'ignore)

;; custom variables
;; (setq
;; lsp-prefer-flymake nil
;; lsp-enable-file-watchers nil
;; lsp-ui-sideline-enable nil
;; lsp-enable-symbol-highlighting nil
;; )
;; (with-eval-after-load 'lsp-mode
;;   (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.ccls-cache\\'")
;;   )

(use-package matlab-mode
  :defer t
  :commands
  (matlab-shell)
  :mode ("\\.m\\'" . matlab-mode)
  ;; :init
  ;; (add-hook 'matlab-mode-hook 'prog-mode-hooks)
  :config
  ;; matlab
  (setq matlab-return-add-semicolon t
        matlab-shell-ask-MATLAB-for-completions t
        matlab-shell-command-switches '("-nodesktop" "-nosplash"))

  ;; ;; set column for matlab m file buffer
  ;; (add-hook 'matlab-mode-hook
  ;;           #'(lambda ()
  ;;             (set-fill-column 100)))

  ;; (load! "lisp/matlab-plus")
  ;; (bind-keys :prefix-map matlab-mode-map
  ;;            :prefix ""
  ;;            ("[key]" . command))
  ;; :bind (:map matlab-mode-map
  ;;        ;; ("C-c C-l" . matlab-shell-run-line)
  ;;        ;; ("C-M-x" . matlab-shell-run-region-or-paragraph-and-step)
  ;;        ;; ("C-c C-n" . matlab-shell-run-line-and-step)
  ;;        ;; ("C-c C-z" . matlab-show-matlab-shell-buffer)
  ;;        )
  )

;;; bibtex
(setq! +biblio-pdf-library-dir "~/Zotero/storage/"
       +biblio-default-bibliography-files '("~/Zotero/myref.bib")
       ;; a single file for one long note / directory for many note files
       +biblio-notes-path "~/org/refnotes.org"
       ;; org-ref-notes-directory "~/org/"
       )
(unless (featurep! :private biblio +roam-bibtex)
  ;; error when org-ref-notes-directory is nil and no roam-bibtex is loaded
  (setq org-ref-notes-directory +biblio-notes-path)
  )

;; (setq reftex-default-bibliography '("~/Zotero/myref.bib"))

;; ;; open zotero pdf in org-ref
;; (eval-after-load 'org-ref
;;   (setq org-ref-default-bibliography "~/Zotero/myref.bib"
;;         org-ref-pdf-directory "~/Zotero/storage/"
;;         org-ref-bibliography-notes "~/org/refnotes.org"
;;         ;; org-ref-notes-function #'org-ref-notes-function-many-files
;;         ;; org-ref-notes-function #'org-ref-notes-function-one-file
;;         )
;;   )

;; (eval-after-load 'bibtex-completion
;;   (setq bibtex-completion-library-path "~/Zotero/storage/"
;;         bibtex-completion-bibliography org-ref-default-bibliography
;;         bibtex-completion-notes-path org-ref-bibliography-notes
;;         bibtex-completion-pdf-field "file"
;;         bibtex-completion-find-additional-pdfs t)
;;   )

;; (setq bibtex-completion-pdf-open-function 'org-open-file)

;;; ui, window mangement
;; Switch to the new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;; (require 'golden-ratio)

;; replace it to update all cursor colors
(remove-hook 'doom-load-theme-hook '+evil-update-cursor-color-h)

;; ;; thinning all faces
(add-hook! 'doom-load-theme-hook
           ;; #'jyun/thin-all-faces
           #'jyun/doom-modeline-height
           #'jyun/evil-state-cursors
           )

(add-hook! 'window-setup-hook
           ;; #'jyun/thin-all-faces
           ;; #'jyun/evil-state-cursors
           #'jyun/doom-modeline-height)

;; (add-hook! 'org-load-hook
;;            #'jyun/thin-all-faces)

;;; doom-modeline
;; https://github.com/seagle0128/doom-modeline
(with-eval-after-load 'doom-modeline
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


;; Hangout
(use-package jabber
  :defer t
  :commands (jabber-connect-all
             jabber-connect)
  :init
  (add-hook 'jabber-post-connect-hooks 'spacemacs/jabber-connect-hook)
  :config
  ;; https://www.masteringemacs.org/article/keeping-secrets-in-emacs-gnupg-auth-sources
  ;; password encrypted in ~/doom-emacs/.local/etc/authinfo.gpg
  ;; machine gmail.com login jonghyun.yun port xmpp password *******
  ;; or I can use =pass=
  ;; see https://github.com/DamienCassou/auth-source-pass
  ;; pass insert jonghyun.yun@gmail.com:xmpp
  (setq jabber-account-list '(("jonghyun.yun@gmail.com"
                               (:network-server . "talk.google.com")
                               (:connection-type . starttls))))

  ;; (jabber-connect-all)
  ;; (jabber-keepalive-start)
  (evil-set-initial-state 'jabber-chat-mode 'insert))


;; (eval-after-load 'paradox
;;   (setq paradox-github-token (password-store-get "paradox/github-token"))
;;   )

;; (with-eval-after-load 'notmuch
;;   (setq +notmuch-sync-backend 'mbsync
;;         +notmuch-sync-command "mbsync -a"
;;         +notmuch-mail-folder "~/.mail/")
;;   )

(add-to-list '+zen-mixed-pitch-modes 'latex-mode)
(setq +zen-text-scale 0.8 ;; The text-scaling level for writeroom-mode
      aw-scope 'global
      doom-scratch-intial-major-mode 'lisp-interaction-mode
      omnisharp-server-executable-path "/usr/local/bin/omnisharp")


;; OS X ls not working with --quoting-style=literal
(after! fd-dired
  (when IS-MAC
    (setq fd-dired-ls-option '("| xargs -0 gls -ld --quoting-style=literal" . "-ld"))
    )
  )

;;; elfeed
(after! elfeed
  (setq elfeed-search-title-max-width 100
        elfeed-search-title-min-width 20)
  (run-at-time nil (* 8 60 60) #'elfeed-update)
  )

(use-package elfeed-score
  :defer t
  :after elfeed
  :init
  (setq elfeed-score-score-file (expand-file-name "elfeed.score" doom-private-dir))
  :config
  (progn
    (elfeed-score-enable)
    (define-key elfeed-search-mode-map "=" elfeed-score-map)
    ;; scores displayed in the search buffer
    (setq elfeed-search-print-entry-function #'elfeed-score-print-entry)))


;; ibuffer and R buffers need to be manually added
(advice-add 'ibuffer :around #'jyun/persp-add-buffer)
(advice-add 'R :around #'jyun/persp-add-buffer)

;; for doom-modeline
(use-package! find-file-in-project
  :defer t
  :commands
  (find-file-in-project
   find-file-in-current-directory-by-selected)
  :general (
            [remap projectile-find-file] #'find-file-in-project
            [remap doom/find-file-in-private-config] #'jyun/find-file-in-private-config)
  :init
  (map! :leader "SPC" #'find-file-in-project-by-selected)
  :config
  (setq ffip-use-rust-fd t)
  ;; use ffip to find file in private config
  ;; (advice-add 'doom/find-file-in-private-config :around #'jyun/find-file-in-private-config)
  )

;; (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
;; (add-hook 'prog-mode-hook #'highlight-parentheses-mode)

(with-eval-after-load 'conda
  (setq conda-anaconda-home "/opt/intel/oneapi/intelpython/latest"
        conda-env-home-directory "/Users/yunj/.conda")
  ;; (conda-env-initialize-interactive-shells)
  ;; (conda-env-initialize-eshell)
  )

;; set this variable again after lsp
;; otherwise the default evn-home will be used
(when (featurep! :tools debugger +lsp)
  (with-eval-after-load 'lsp-mode
    (setq conda-env-home-directory "/Users/yunj/.conda")
    ))

;; (setq conda-env-autoactivate-mode t)

;; align tables containing variable-pitch font, CJK characters and images
;; (add-hook 'org-mode-hook #'valign-mode)


;; ;; Github flavored markdown exporter
;; (eval-after-load 'ox
;;   '(require 'ox-gfm nil t))
(use-package ox-gfm
  :defer t
  :after ox)

;;; presentation
(with-eval-after-load 'org-tree-slide
  (defvar +org-present-hide-properties t
    "Whether to hide property draws in `org-tree-slide'.")
  (defvar +org-present-hide-tags t
    "Whether to hide tags in `org-tree-slide'.")
  (defvar +org-present-format-latex-scale 2.5
    "A local variable to be used as `org-latex-preview-scale' in `org-tree-slide'.")
  (setq org-tree-slide-header nil
        org-tree-slide-skip-outline-level 5
        org-tree-slide-heading-emphasis nil
        +org-present-text-scale 3)

  ;; (remove-hook 'org-tree-slide-mode-hook
  ;;              #'+org-present-hide-blocks-h
  ;;              #'+org-present-prettify-slide-h

  ;; `jyun/org-present-hide' needs some functions in `contrib-present.el'
  ;; these functions are not autoloaded.
  (load (expand-file-name "modules/lang/org/autoload/contrib-present" doom-emacs-dir))
  (add-hook! 'org-tree-slide-mode-hook
             #'jyun/org-present-hide
             #'jyun/org-present-mixed-pitch-setup
             )
  (defun jyun/org-present-mixed-pitch-setup ()
    "Visual enchancement for `org-tree-slide'. `mixed-pitch-mode'
or `mixed-pitch-serif-mode' can be called afterward."
    (progn
      (require 'mixed-pitch)
      (setq-local
       ;; visual-fill-column-width 60
       ;; org-adapt-indentation nil
       org-fontify-quote-and-verse-blocks t
       org-fontify-whole-heading-line t
       org-hide-emphasis-markers t
       mixed-pitch-set-height nil
       )
      (when (featurep 'org-superstar)
        (setq-local org-superstar-headline-bullets-list '("🙘" "🙙" "🙚" "🙛")
                    ;; org-superstar-headline-bullets-list '("🙐" "🙑" "🙒" "🙓" "🙔" "🙕" "🙖" "🙗")
                    org-superstar-remove-leading-stars t)
        (org-superstar-restart))
      ))

  ;; cause errors in navigating slides
  (advice-remove 'org-tree-slide--display-tree-with-narrow #'+org-present--narrow-to-subtree-a)
  )

;;; string-inflection
(use-package string-inflection
  :defer t
  :commands
  (my-hydra-string-inflection/body)
  :init
  (progn
    (defhydra my-hydra-string-inflection
      (:hint nil)
      "
[_i_] cycle"
      ("i" string-inflection-all-cycle)
      )
    (map!
     :leader
     (:prefix ("zi" . "inflection")
      "c" 'string-inflection-lower-camelcase
      "C" 'string-inflection-camelcase
      :desc "String Inflection Hydra" "i" 'my-hydra-string-inflection/body
      "-" 'string-inflection-kebab-case
      "k" 'string-inflection-kebab-case
      "_" 'string-inflection-underscore
      "u" 'string-inflection-underscore
      "U" 'string-inflection-upcase))))

;;; org-roam
(with-eval-after-load 'org-roam
  (setq org-roam-dailies-capture-templates
        '(("d" "default" entry
           #'org-roam-capture--get-point
           "* %?"
           :file-name "daily/%<%Y-%m-%d_%A>"
           :head "#+TITLE: %<%Y-%m-%d %A>\n\n[[roam:%<%Y-%m %B>]]\n\n")))
  )

;; this should work, and it actually bind keys
;; but it cannot override default binding's description
;; (map! :leader "nrd" #'org-roam-dailies-map)

;; ;; skim to org-roam-bibtex integration
;; ;; org-id is not generated
;; ;; org-roam-capture error (due to outdated package) -> updated
;; ;; more than 2 attachment -> error
;; (with-eval-after-load 'org-capture
;;     (add-to-list 'org-capture-templates
;;                  '("RSA" "Skim Annotation" entry
;;                    (file+function yunj/skim-orb-notes +reference/org-move-point-to-capture-skim-annotation)
;;                    "* %^{Note for...}
;;    :PROPERTIES:
;;    :CREATED: %U
;;    :CITE: cite:%(+reference/skim-get-bibtex-key)
;;    :SKIM_NOTE: %(+reference/skim-get-annotation)
;;    :SKIM_PAGE: %(+reference/get-skim-page-number)
;;    :END:
;;    %i \n%?"))
;;     )

;; ;;;###autoload
;; (defun yunj/skim-orb-notes ()
;;   (progn
;;     (orb-notes-fn (+reference/skim-get-bibtex-key))
;;     (let ((bname (buffer-file-name)))
;;       (kill-this-buffer)
;;       bname)))

;;; *languagetool
;; (setq langtool-bin "languagetool")
(setq langtool-language-tool-server-jar "/usr/local/Cellar/languagetool/*/libexec/languagetool-server.jar")
;; (setq langtool-http-server-host "localhost"
;;       langtool-http-server-port 8081)

;; these exculeded faces are in lists for spell-fu
(add-hook 'markdown-mode-hook (defun langtool-markdown-ignore-fonts ()
                                (setq-local langtool-ignore-fonts
                                            (alist-get 'markdown-mode +spell-excluded-faces-alist))))
(add-hook 'LaTeX-mode-hook (defun langtool-LaTeX-ignore-fonts ()
                             (setq-local langtool-ignore-fonts
                                         (alist-get 'LaTeX-mode +spell-excluded-faces-alist))))

;; (byte-recompile-directory (expand-file-name "~/.doom.d/") 0) ;
;; (byte-compile-file (expand-file-name "modules/private/reference/autoload/applescript.el" doom-private-dir))
;; (shell-command "find ~/.doom.d/ -type f -name \"*.elc\" -delete")

;;; printer
(setq pdf-misc-print-program "lpr"
      pdf-misc-print-program-args nil)

(defun jyun/evil-state-cursors ()
  ;; doom-modeline
  (setq +evil--default-cursor-color (face-attribute 'success :foreground))
  (setq +evil--insert-cursor-color (face-attribute 'font-lock-keyword-face :foreground))
  (setq +evil--emacs-cursor-color (face-attribute 'font-lock-builtin-face :foreground))
  (setq +evil--replace-cursor-color (face-attribute 'error :foreground))
  (setq +evil--visual-cursor-color (face-attribute 'warning :foreground))
  (setq +evil--motion-cursor-color (face-attribute 'font-lock-doc-face :foreground))

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

(setq +evil--default-cursor-color "DarkGoldenrod2")
(setq +evil--emacs-cursor-color "SkyBlue2")
(defvar +evil--insert-cursor-color "chartreuse3")
(defvar +evil--replace-cursor-color "chocolate")
(defvar +evil--visual-cursor-color "gray")
(defvar +evil--motion-cursor-color "plum3")

(defun +evil-insert-cursor-fn ()
  (evil-set-cursor-color +evil--insert-cursor-color))
(defun +evil-replace-cursor-fn ()
  (evil-set-cursor-color +evil--replace-cursor-color))
(defun +evil-visual-cursor-fn ()
  (evil-set-cursor-color +evil--visual-cursor-color))
(defun +evil-motion-cursor-fn ()
  (evil-set-cursor-color +evil--motion-cursor-color))

;; (use-package visual-regexp
;;   :defer t
;;   :commands (vr/replace vr/query-replace)
;;   :config
;;   (define-key global-map (kbd "C-c r") 'vr/replace)
;;   (define-key global-map (kbd "C-c q") 'vr/query-replace)
;;   ;; if you use multiple-cursors, this is for you:
;;   ;; (define-key global-map (kbd "C-c m") 'vr/mc-mark)
;;   )

(use-package! info-colors
  :commands (info-colors-fontify-node))
(add-hook 'Info-selection-hook 'info-colors-fontify-node)
;; (add-hook 'Info-mode-hook #'mixed-pitch-mode)

(use-package abbrev
  :init
  (setq-default abbrev-mode t)
  ;; a hook funtion that sets the abbrev-table to org-mode-abbrev-table
  ;; whenever the major mode is a text mode
  (defun tec/set-text-mode-abbrev-table ()
    (if (derived-mode-p 'text-mode)
        (setq local-abbrev-table org-mode-abbrev-table)))
  :commands abbrev-mode
  :hook
  (abbrev-mode . tec/set-text-mode-abbrev-table)
  :config
  (setq abbrev-file-name (expand-file-name "abbrev.el" doom-private-dir))
  (setq save-abbrevs 'silently))

;; (after! company
;;   (setq company-idle-delay nil
;;         company-minimum-prefix-length 2)
;;   (add-hook 'evil-normal-state-entry-hook #'company-abort)) ;; make aborting less annoying

;; company memory
(setq-default history-length 1000)
(setq-default prescient-history-length 1000)
