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

;; (setq doom-font (font-spec :family "Source Code Pro" :size 22 :weight 'semi-light)
      ;; doom-variable-pitch-font (font-spec :family "Source Serif Pro")
      ;; doom-serif-font (font-spec :family "Source Serif Pro")
      ;; )

;; "Iosevka SS05" ;; Monospace, Fira Mono Style
;; "Iosevka SS08" ;; Monospace, Pragmata Pro Style
;; "Iosevka SS09" ;; Monospace, Source Code Pro Style
;; "Iosevka SS13" ;; Monospace, Lucida Style

(setq
 doom-font (font-spec :family "Iosevka SS13" :size 24 :weight 'light)
 doom-variable-pitch-font (font-spec :family "Iosevka Sparkle" :weight 'light)
 doom-unicode-font (font-spec :family "Sarasa Mono K" :weight 'light)
 doom-big-font (font-spec :family "Iosevka SS13" :size 28 :weight 'light)
 )

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-solarized-light)

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

 (let ((default-directory (expand-file-name "packages" doom-private-dir)))
   (normal-top-level-add-subdirs-to-load-path))

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
  (setq doom-themes-treemacs-enable-variable-pitch nil)
  (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  (doom-themes-treemacs-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config)
  )

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
  )

;; disable flycheck by default
(after! flycheck
  (remove-hook 'doom-first-buffer-hook #'global-flycheck-mode)
  )

;; make-frame doesn't create a new persp
(after! persp-mode
  (remove-hook 'after-make-frame-functions #'persp-init-new-frame)
  )

(setq
 ;; persp-add-buffer-on-after-change-major-mode 'free
 ;; persp-add-buffer-on-after-change-major-mode-filter-functions nil
 persp-nil-name "main")

(after! projectile
  (projectile-add-known-project "~/Dropbox/research/lsjm-art")
  (projectile-add-known-project "~/Dropbox/utsw-projects/HITS-CLIP")
  (projectile-add-known-project "~/OneDrive/research/lapf")
  (projectile-add-known-project "~/research/s.ham/RAS")
  )

;; https://github.com/hlissner/doom-emacs/issues/1317#issuecomment-483884401
;; (remove-hook 'ivy-mode-hook #'ivy-rich-mode)

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

(after! spell-fu
  (setq spell-fu-idle-delay 0.5)
  ;; (global-spell-fu-mode -1)

  ;; (add-hook 'org-mode-hook
  ;;           (lambda ()
  ;;             (setq spell-fu-faces-exclude
  ;;                   '(
  ;;                     org-property-drawer-re
  ;;                     org-ref-cite-re
  ;;                     org-ref-ref-re
  ;;                     org-ref-label-re
  ;;                     org-latex-math-environments-re
  ;;                     "\\`[ 	]*\\\\begin{\\(?:align*\\|equation*\\|eqnarray*\\)\\*?}"
  ;;                     font-lock-comment-face
  ;;                     ))
  ;;             (spell-fu-mode)))

  (setf (alist-get 'org-mode +spell-excluded-faces-alist)
        '(
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

  (setf (alist-get 'latex-mode +spell-excluded-faces-alist)
        '(
          font-lock-function-name-face
          font-lock-variable-name-face
          font-lock-keyword-face
          font-lock-constant-face
          font-lock-comment-face
          font-latex-math-face
          font-latex-sedate-face
          ;; font-latex-verbatim-face
          ;; font-latex-warning-face
          ))
  )

(load! "bindings")

(after! mu4e
  (load! "lisp/mu4e-plus"))

(load! "lisp/latex-plus")
;; (setq +latex-viewers '(skim pdf-tools))
(setq +latex-viewers '(pdf-tools skim))

(after! ess
  (load! "lisp/ess-plus")
  (evil-set-initial-state 'inferior-ess-mode 'emacs)
  )

(after! ess-mode
  (setq ess-r-smart-operators t)
  )

(load! "lisp/org-plus")
;; (evil-set-initial-state 'org-agenda-mode 'emacs)
;; (load! "lisp/stan-config") ;; :private stan module

;; passwords to be accessible
(use-package! pass)

(after! plantuml-mode
  (setq plantuml-jar-path "/usr/local/Cellar/plantuml/*/libexec/plantuml.jar"
        org-plantuml-jar-path plantuml-jar-path)
  )
;; prevent some cases of Emacs flickering
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

;; maximize frame at startup
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; Backups & Autosave
;; (auto-save-visited-mode +1)
(setq auto-save-default t
      create-lockfiles t
      make-backup-files nil)

;; no accumulating drafts
(add-hook 'mu4e-compose-mode-hook #'(lambda () (auto-save-visited-mode -1)))

(setq company-idle-delay nil
      company-tooltip-limit 10
      ;; company-box-enable-icon nil ;;disable all-the-icons
      )

;; Switch to the new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;; (setq trash-directory "~/.Trash/")

(after! org
  ;; background color for org-latex
  ;; (+org-refresh-latex-background-h)
  (setq
   org-fontify-quote-and-verse-blocks nil
   org-fontify-whole-heading-line nil
   org-ellipsis " ▼ "
   org-journal-encrypt-journal t
   ;; (remove-hook 'org-mode-hook #'org-superstar-mode)
   ;; (when (featurep! :lang org +pretty)
   ;; org-superstar-headline-bullets-list '("♠" "♥" "♦" "♣" "◉" "▶" "✚" "✸"))
   ;; org-hide-leading-stars t
   ;; org-startup-indented nil

   org-indent-indentation-per-level 1
   org-adapt-indentation nil

   ;; tag indent
   org-tags-column -77

   ;; org export global setting
   org-export-with-toc nil
   ;; custom_id -> \label
   ;; org-latex-prefer-user-labels t
   org-log-done 'time
   ;; latex highlight
   org-highlight-latex-and-related '(native)
   ;; don't ask to follow elisp link
   org-confirm-elisp-link-function nil
   )
  ;; (setq org-insert-heading-respect-content nil)

  (setq org-preview-latex-image-directory "ltximg/"
        ;; org-archive-location ".archive/%s::"
        )
  ;; default attach folder
  ;; (after! org-attach
  ;;   (setq
  ;;    org-attach-id-dir "data/"))

  ;; visual-mode tab binds back to org-cycle
  (remove-hook 'org-tab-first-hook #'+org-yas-expand-maybe-h)

  ;; insert-mode tab binds back to org-cycle
  (remove-hook 'org-tab-first-hook #'+org-indent-maybe-h)
   )

;; https://gitlab.com/oer/org-re-reveal-ref/-/blob/master/org-re-reveal-ref.el
;; it changes some of org-ref custom variables
(use-package! org-re-reveal-ref
  :after org-re-reveal
  )

;; Set LaTeX preview image size for Org and LaTeX buffers.
(after! preview
  ;; latex-preview size
  (setq preview-scale 1.5)
  ;; (set 'preview-scale-function 1.75)
  )

;; (after! org
  ;; org-latex-preview size
  ;; (setq org-format-latex-options
  ;;       (list :foreground 'default
  ;;             :background 'default
  ;;             :scale 1.5
  ;;             :html-foreground "Black"
  ;;             :html-background "Transparent"
  ;;             :html-scale 1.0
  ;;             :matchers '("begin" "$1" "$" "$$" "\\(" "\\[")))
  ;; (plist-put org-format-latex-options :scale 1.5) ; larger previews
  ;; )

(with-eval-after-load 'org-roam
  (setq org-roam-graph-viewer "/Applications/Firefox.app/Contents/MacOS/firefox-bin")
  ;; (setq org-roam-graph-executable "neato")
  ;; (setq org-roam-graph-extra-config '(("overlap" . "false")))
  )

;; ad-hoc fixes: hangul in dired-mode
;; https://www.emacswiki.org/emacs/CarbonEmacsPackage#CarbonEmacs
;; seems to work for emacs 22 and 23
;; (require 'utf-8m)
;; (set-file-name-coding-system 'utf-8m)

;; Dropbox sync changes hangul encoding to NFD, which results in 한글 자소분리 in dired and other modes
;; https://tt.kollhong.com/79
;; https://nullprogram.com/blog/2014/06/13/
(when IS-MAC
  (use-package! ucs-normalize
    :config
    (set-file-name-coding-system 'utf-8-hfs)
    )
  )

;; ;; improve slow scrolling?
;; (use-package! hl-line+
;;   :config
;;   (hl-line-when-idle-interval 0.5)
;;   (toggle-hl-line-when-idle 1))

(setq garbage-collection-messages nil)
;;; Fewer garbage collection
;; Number of bytes of consing between garbage collections.
;; (defun set-gc-cons-threshold-normal (mb)
;;   "Set gc-cons-threshold in MB"
;;   (setq gc-cons-threshold (round (* mb 1000 1000))))
;; (add-hook 'after-init-hook #'(lambda () (set-gc-cons-threshold-normal 0.8)))

;; no need: gcmh: https://github.com/emacsmirror/gcmh
;; (add-hook 'focus-out-hook #'garbage-collect)

;; no key stroke for exiting INSERT mode: doom default jk
(setq evil-escape-key-sequence "jk"
      evil-escape-delay 0.1)

;; emacs-mode shift can be used for C-SPC
;; didn't know it exists
;; (setq shift-select-mode t)

(with-eval-after-load 'alert
  ;; calendar notification
  ;; (setq alert-default-style 'osx-notifier)
  (setq alert-default-style 'notifier)
  )

(with-eval-after-load 'deft
  (setq deft-extensions '("org" "md" "txt")
        deft-directory org-directory
        ;; include subdirectories
        deft-recursive t))

(with-eval-after-load 'which-key
  ;; Allow C-h to trigger which-key before it is done automatically
  ;; (setq which-key-show-early-on-C-h t)
  ;; make sure which-key doesn't show normally but refreshes quickly after it is
  ;; triggered.
  (setq which-key-idle-delay 1) ;; with 800kb garbage-collection
  ;; (setq which-key-idle-secondary-delay 0.05)
  ;; (which-key-mode)
)

;; (with-eval-after-load 'pdf-tools
;;   ;; Pdf tools dark/light theme
;;   (add-hook 'pdf-tools-enabled-hook 'pdf-view-midnight-minor-mode)

;;   ;; cursor visibility
;;   (add-hook 'pdf-view-mode-hook
;;             (lambda ()
;;               (set (make-local-variable
;;                     'evil-evilified-state-cursor)
;;                    (list nil))))
;; )

;; ;; epub osx dictionary
;; (defun my-nov-mode-map ()
;;   (define-key nov-mode-map "s" 'osx-dictionary-search-pointer)
;;   t)
;; (add-hook 'nov-mode-hook 'my-nov-mode-map)

;; (evil-set-initial-state 'elfeed-search-mode 'emacs)
;; (evil-set-initial-state 'elfeed-shoe-mode 'emacs)

;; ;; savehist-mode history length
;; (setq history-length 1000)
;; (put 'minibuffer-history 'history-length 50)
;; (put 'evil-ex-history 'history-length 50)
;; (put 'kill-ring 'history-length 25)

;; (setq save-place-forget-unreadable-files t) ;; emacs is slow to exit after enabling saveplace

;; (setq recentf-auto-cleanup 300)         ;; long recentf slow down emacs
;; disable recentf-cleanup on Emacs start, because it can cause
;; problems with remote files
;; (setq recentf-auto-cleanup 'never)

;; Delete duplicated entries in autosaves of minibuffer history
;; (setq history-delete-duplicates t)

;; ;; https://github.com/kaz-yos/emacs/blob/master/init.d/500_recentf-related.el
;; (setq recentf-max-saved-items 300)
;; (setq recentf-max-menu-items 15)
;; (setq recentf-exclude '("recentf_.*$"
;;                         ;; ".*/elpa/.*"
;;                         ".*\\.maildir.*"
;;                         "/var/folders/.*"
;;                         ".*company-statistics.*"))


;; ;; speed up comint
;; (setq gud-gdb-command-name "gdb --annotate=1"
;;       large-file-warning-threshold nil
;;       line-move-visual nil)

;; set korean keyboard layout
;; C-\ to switch input-method
(setq default-input-method "korean-hangul390")

;; Other options
;; replace highlighted text with what I type
;; (delete-selection-mode 1)

(setq display-time-24hr-format t
      mouse-autoselect-window nil
      ;; indicate-unused-lines nil
      ;; spacemacs value of parameters
      scroll-conservatively 0
      )
(blink-cursor-mode t)
;; (display-time-mode t)
;; (add-hook 'before-save-hook 'time-stamp)

;; (global-set-key [C-wheel-up]  'ignore)
;; (global-set-key [C-wheel-down] 'ignore)

;; ;; custom variables
;; (setq lsp-prefer-flymake nil
;;       lsp-enable-file-watchers nil)

(use-package matlab-mode
  :defer t
  ;; :init
  ;; (add-hook 'matlab-mode-hook 'prog-mode-hooks)
  :config
  ;; matlab
  (setq matlab-return-add-semicolon t
        matlab-shell-ask-MATLAB-for-completions t
        matlab-shell-command-switches '("-nodesktop" "-nosplash"))

  ;; ;; set column for matlab m file buffer
  ;; (add-hook 'matlab-mode-hook
  ;;           (lambda ()
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

(setq! +biblio-pdf-library-dir "~/Zotero/storage/"
       +biblio-default-bibliography-files '("~/Zotero/myref.bib")
       +biblio-notes-path "~/org/refnotes.org"
       ;; org-ref-notes-directory +biblio-notes-path
       ;; org-ref-notes-directory "~/org/"
       )


;; (setq reftex-default-bibliography '("~/Zotero/myref.bib"))

;; ;; open zotero pdf in org-ref
;; (after! org-ref
;;   (setq org-ref-default-bibliography "~/Zotero/myref.bib"
;;         org-ref-pdf-directory "~/Zotero/storage/"
;;         org-ref-bibliography-notes "~/org/refnotes.org"
;;         ;; org-ref-notes-function #'org-ref-notes-function-many-files
;;         ;; org-ref-notes-function #'org-ref-notes-function-one-file
;;         )
;;   )

;; (after! bibtex-completion
;;   (setq bibtex-completion-library-path "~/Zotero/storage/"
;;         bibtex-completion-bibliography org-ref-default-bibliography
;;         bibtex-completion-notes-path org-ref-bibliography-notes
;;         bibtex-completion-pdf-field "file"
;;         bibtex-completion-find-additional-pdfs t)
;;   )

;; (setq bibtex-completion-pdf-open-function 'org-open-file)

;;; doom-modeline
;;; https://github.com/seagle0128/doom-modeline
(with-eval-after-load 'doom-modeline
  ;; How tall the mode-line should be. It's only respected in GUI.
  ;; If the actual char height is larger, it respects the actual height.
  (setq doom-modeline-height 20)

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
  (setq doom-modeline-env-version nil)
  )

;; Hangout
(use-package jabber
  :defer t
  :init
  (add-hook 'jabber-post-connect-hooks 'spacemacs/jabber-connect-hook)
  :config
  ;; password encrypted in ~/.authinfo.gpg
  ;; https://www.masteringemacs.org/article/keeping-secrets-in-emacs-gnupg-auth-sources
  (setq jabber-account-list '(("jonghyun.yun@gmail.com"
                             (:network-server . "talk.google.com")
                             (:connection-type . starttls)
                             )))
  ;; (jabber-connect-all)
  ;; (jabber-keepalive-start)
  )

(after! paradox
  (setq paradox-github-token (password-store-get "paradox/github-token"))
  )

(with-eval-after-load 'notmuch
  (setq +notmuch-sync-backend 'mbsync
        +notmuch-sync-command "mbsync -a"
        +notmuch-mail-folder "~/.mail/")
  )

;; The text-scaling level for writeroom-mode
(after! writeroom-mode
  (setq +zen-text-scale 1.2)
  )

(after! org-msg
  (setq org-msg-options
        (concat org-msg-options " num:nil tex:dvipng ^:{} \\n:t")
        org-msg-startup "hidestars indent inlineimages")
  )

;; OS X ls not working with --quoting-style=literal
(after! fd-dired
  (when IS-MAC
    (setq fd-dired-ls-option '("| xargs -0 gls -ld --quoting-style=literal" . "-ld"))
    )
  )

(after! cdlatex
  (setq cdlatex-math-symbol-alist
        '((?: ("\\cdots" "\\ldots"))
          )
        )
  )

(after! ace-window
  (setq aw-scope 'global))

(after! elfeed
  (setq elfeed-search-title-max-width 100
        elfeed-search-title-min-width 20)
  )

(use-package elfeed-score
  :after elfeed
  :init
  (setq elfeed-score-score-file (expand-file-name "elfeed.score" doom-private-dir))
  :config
  (progn
    (elfeed-score-enable)
    (define-key elfeed-search-mode-map "=" elfeed-score-map)
    ;; scores displayed in the search buffer
    (setq elfeed-search-print-entry-function #'elfeed-score-print-entry)
    ))

;; ibuffer and R buffers need to be manually added
(advice-add 'ibuffer :around #'my-persp-add-buffer)
(advice-add 'R :around #'my-persp-add-buffer)

;; for doom-modeline
(use-package! find-file-in-project
  :general (
            [remap projectile-find-file] #'find-file-in-project
            [remap doom/find-file-in-private-config] #'my/find-file-in-private-config)
  :config
  (setq ffip-use-rust-fd t)
  ;; use ffip to find file in private config
  ;; (advice-add 'doom/find-file-in-private-config :around #'my/find-file-in-private-config)
  )

;; (after! org
;; (plist-put org-format-latex-options :matchers '("begin" "$1" "$" "$$" "\\(" "\\[")) ;; drop "$"
;; )

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook #'highlight-parentheses-mode)

;; (custom-set-faces!
;;   '(aw-leading-char-face
;;     :foreground "white" :background "red"
;;     :weight bold :height 2.5 :box (:line-width 10 :color "red"))
;;   )

  ;; '(rainbow-delimiters-depth-1-face ((,class :foreground ,keyword)))
  ;; '(rainbow-delimiters-depth-2-face ((,class :foreground ,func)))
  ;; '(rainbow-delimiters-depth-3-face ((,class :foreground ,str)))
  ;; '(rainbow-delimiters-depth-4-face ((,class :foreground ,green)))
  ;; '(rainbow-delimiters-depth-5-face ((,class :foreground ,yellow)))
  ;; '(rainbow-delimiters-depth-6-face ((,class :foreground ,keyword)))
  ;; '(rainbow-delimiters-depth-7-face ((,class :foreground ,func)))
  ;; '(rainbow-delimiters-depth-8-face ((,class :foreground ,str)))
  ;; '(rainbow-delimiters-mismatched-face ((,class :foreground ,err :overline t)))
  ;; '(rainbow-delimiters-unmatched-face ((,class :foreground ,err :overline t)))
