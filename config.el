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
(setq doom-theme 'doom-one-light)

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

;; passwords to be accessible
;; (use-package! pass)

;; org -> latex -> md -> docx
;; to properly generate cross references
;; https://github.com/lierdakil/pandoc-crossref
(use-package! md-word
  :load-path "local/"
  :after ox
  :config
  (after! ox-pandoc
    (add-to-list 'org-pandoc-valid-options 'citeproc))
  )

;;; load lisp
(with-eval-after-load 'hydra
  (load! "local/hydra-plus"))
(load! "bindings")
(load! "local/mu4e-plus")
(load! "local/org-plus")
;; ;; (when (featurep! :ui ligatures +extra)
;; ;;   (load! "local/ligature"))
(load! "local/ess-plus")
(load! "local/latex-plus")
(load! "local/visual-plus")

(after! projectile
  (projectile-add-known-project "~/Dropbox/research/lsjm-art")
  (projectile-add-known-project "~/Dropbox/utsw-projects/HITS-CLIP")
  (projectile-add-known-project "~/OneDrive/research/lapf")
  ;; (projectile-add-known-project "~/research/s.ham/RAS")
  (projectile-add-known-project "~/research/mj.jeon")
  )

;; riksy local variables
;; old tricks stopped working. risky variables are ignored (doom updates)
;; instead I can safely eval risky variables...
(setq enable-local-eval t)
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

;;; LaTeX
;; (setq +latex-viewers '(skim pdf-tools))
(setq +latex-viewers '(pdf-tools skim))
;; (add-hook! 'LaTeX-mode-hook #'(lambda () (cdlatex-mode 1)))
(setq TeX-command-extra-options "-shell-escape")

;; Set LaTeX preview image size for Org and LaTeX buffers.
(after! preview
  ;; latex-preview size
  (setq preview-scale 1.5)
  ;; (set 'preview-scale-function 1.75)
  )

;; ;; trying to turn off `rainbow-delimiters-mode'. not working..
;; (add-hook! 'LaTeX-mode-hook #'(lambda () (rainbow-delimiters-mode -1)))
;; (remove-hook 'TeX-update-style-hook #'rainbow-delimiters-mode)

(after! cdlatex
  (setq cdlatex-math-symbol-alist
        '((?: ("\\cdots" "\\ldots"))
          )
        ))

;;; ess
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

;;; plantuml
;; jar configuration needs for math typesetting.
;; version is pinned (brew pin plantuml)
(after! plantuml-mode
  (setq plantuml-jar-path "/usr/local/Cellar/plantuml/1.2021.4/libexec/plantuml.jar"
        plantuml-default-exec-mode 'jar
        org-plantuml-jar-path plantuml-jar-path)
  )

;; prevent some cases of Emacs flickering
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

;;; maximize frame at startup
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
;; OS X native full screen
;; (add-to-list 'initial-frame-alist '(fullscreen . fullscreen))

;;; Backups & Autosave
;; (auto-save-visited-mode +1)
(setq auto-save-default t
      create-lockfiles t
      make-backup-files nil
      ; truncate-string-ellipsis "…"      ; Unicode ellispis are nicer than "...", and also save /precious/ space
      yas-triggers-in-field t           ; snippets inside snippets. some need this
      )

;;; company
(after! company
  (setq company-idle-delay 2
        company-minimum-prefix-length 2
        company-tooltip-limit 10
        ;; company-box-enable-icon nil ; disable all-the-icons
        ))

;; company memory
(setq-default history-length 500)
(setq-default prescient-history-length 500)

;;; org-mode
(after! org
  ;; rendering when not at point
  ;; (use-package! org-fragtog
  ;; :hook (org-mode . org-fragtog-mode))

  (when (featurep! :lang org +pretty)
    (remove-hook 'org-mode-hook 'org-superstar-mode) ; manually turn it on!
    (setq org-superstar-headline-bullets-list '("♠" "♡" "♦" "♧")
          org-superstar-remove-leading-stars nil
          ))

  ;; background color for org-latex
  ;; (+org-refresh-latex-background-h)
  (setq
   ;; org-export-in-background t                  ; async export by default

   org-fontify-quote-and-verse-blocks nil
   org-fontify-whole-heading-line nil
   org-hide-leading-stars nil
   org-startup-indented t
   org-ellipsis " ▼ "

   org-journal-encrypt-journal t

   org-indent-indentation-per-level 1
   org-adapt-indentation nil

   ;; tag indent
   ;; org-tags-column -77

   org-log-done 'time
   ;; don't ask to follow elisp link
   org-confirm-elisp-link-function nil

   ;; org export global setting
   org-export-with-toc nil
   org-export-with-tags nil)

  ;; (setq org-insert-heading-respect-content nil)

  ;; default attach folder
  ;; (after! org-attach
  ;;   (setq
  ;;    org-attach-id-dir "data/"))

  ;; visual-mode tab binds back to org-cycle
  (remove-hook 'org-tab-first-hook #'+org-yas-expand-maybe-h)

  ;; insert-mode tab binds back to org-cycle
  (remove-hook 'org-tab-first-hook #'+org-indent-maybe-h)
  )

;;;; org-latex
(after! org
  ;; adjust background colors of org-latex fragments
  ;; call it manually!
  ;; (add-hook! 'org-mode-hook #'my/org-latex-set-directory-name-to-background)
  ;; (add-hook! 'doom-load-theme-hook #'my/org-latex-set-directory-name-to-background)

  (setq org-highlight-latex-and-related '(native script entities))
  (setq org-format-latex-options
        (plist-put org-format-latex-options :background
                   ;; "Transparent"
                   'default
                   )
        )
  (add-to-list 'org-src-block-faces '("latex" (:inherit default :extend t)))

  ;; cdltaex will ignore inline math $...$
  ;; (plist-put org-format-latex-options :matchers '("begin" "$1" "$" "$$" "\\(" "\\[")) ;; drop "$"

  (setq org-preview-latex-image-directory "ltximg/"
        ;; org-archive-location ".archive/%s::"
        )

  (defvar jyun/org-latex-preview-scale 1.5
    "A scaling factor for the size of images created from LaTeX fragments.")
  (defun jyun/org-latex-set-options ()
    (plist-put org-format-latex-options :scale jyun/org-latex-preview-scale))

  ;; set default org-latex-preview size
  (jyun/org-latex-set-options)
  )

;;;; org-pretty
;; align tables containing variable-pitch font, CJK characters and images
;; (add-hook 'org-mode-hook #'valign-mode)

;; (use-package! org-pretty-table
;;   :commands (org-pretty-table-mode global-org-pretty-table-mode))

;; (evil-set-initial-state 'org-agenda-mode 'emacs)

;;; ox
(after! ox
  (setq org-beamer-theme "[progressbar=foot]metropolis"
        org-beamer-frame-level 4
        org-latex-tables-booktabs nil
        ))
;; ;; Github flavored markdown exporter
;; (eval-after-load 'ox
;;   '(require 'ox-gfm nil t))
(use-package ox-gfm
  :defer t
  :after ox)

;;; org-roam
(with-eval-after-load 'org-roam
  (setq org-roam-graph-viewer "/Applications/Firefox.app/Contents/MacOS/firefox-bin"
        +org-roam-open-buffer-on-find-file nil)
  ;; (setq org-roam-graph-executable "neato")
  ;; (setq org-roam-graph-extra-config '(("overlap" . "false")))
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

;;; misc
(setq mac-right-option-modifier 'hyper)
;; (setq mac-right-command-modifier 'hyper)
;; (setq mac-right-option-modifier 'super)

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

;;;; which-key
(with-eval-after-load 'which-key
  ;; Allow C-h to trigger which-key before it is done automatically
  ;; (setq which-key-show-early-on-C-h t)
  ;; make sure which-key doesn't show normally but refreshes quickly after it is
  ;; triggered.
  (setq which-key-idle-delay 1) ;; with 800kb garbage-collection
  ;; (setq which-key-idle-secondary-delay 0.05)
  ;; (which-key-mode)
  ;; (define-key which-key-mode-map (kbd "C-h") 'which-key-C-h-dispatch)
  ;; (setq which-key-allow-multiple-replacements t)
  (pushnew!
   which-key-replacement-alist
   '(("" . "\\`+?evil[-:\\/]?\\(?:a-\\)?\\(.*\\)") . (nil . "◂\\1"))
   '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . "◃\\1"))
   )
  ;; why I want this??
  ;; (setq which-key-replacement-alist nil )
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

;; disable flycheck by default
(remove-hook 'doom-first-buffer-hook #'global-flycheck-mode)
;; replace it to update all cursor colors
;; (remove-hook 'doom-load-theme-hook '+evil-update-cursor-color-h)

;; overide the cursor color hook
(defun +evil-update-cursor-color-h ()
  (jyun/evil-state-cursors))

;; ;; thinning all faces
(add-hook! 'doom-load-theme-hook
           ;; #'jyun/thin-all-faces
           #'jyun/doom-modeline-height
           ;; #'jyun/evil-state-cursors
           )

(add-hook! 'window-setup-hook
           ;; #'jyun/thin-all-faces
           ;; #'jyun/evil-state-cursors
           #'jyun/doom-modeline-height)

;;; Hangout
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

(setq
 aw-scope 'global
 doom-scratch-intial-major-mode 'lisp-interaction-mode
 omnisharp-server-executable-path "/usr/local/bin/omnisharp")


;; OS X ls not working with --quoting-style=literal
(after! fd-dired
  (when IS-MAC
    (setq fd-dired-ls-option '("| xargs -0 gls -ld --quoting-style=literal" . "-ld"))
    )
  )

;; ibuffer and R buffers need to be manually added
(advice-add 'ibuffer :around #'jyun/persp-add-buffer)
(advice-add 'R :around #'jyun/persp-add-buffer)

;;; mixed pitch + zen
(add-to-list '+zen-mixed-pitch-modes 'latex-mode)
(setq +zen-text-scale 0.8) ;; The text-scaling level for writeroom-mode

;;; ffip
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

;;; prog-mode
;; (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
;; (add-hook 'prog-mode-hook #'highlight-parentheses-mode)

;;;; lsp
;; (setq
;; lsp-prefer-flymake nil
;; lsp-enable-file-watchers nil
;; lsp-ui-sideline-enable nil
;; lsp-enable-symbol-highlighting nil
;; )
;; (with-eval-after-load 'lsp-mode
;;   (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.ccls-cache\\'")
;;   )

;;;; matlab
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

  ;; (load! "local/matlab-plus")
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

;;;; conda
;; (with-eval-after-load 'conda
;;   ;; (require 'conda)
;;   (setq-default conda-anaconda-home "/opt/intel/oneapi/intelpython/latest"
;;                 conda-env-home-directory "/Users/yunj/.conda"
;;         )
;;   ;; (conda-env-initialize-interactive-shells)
;;   ;; (conda-env-initialize-eshell)
;;   )
;; (setq conda-env-autoactivate-mode t)

;;;; debugging
;; set this variable again after lsp
;; otherwise the default evn-home will be used
;; (when (featurep! :tools debugger +lsp)
;;   (with-eval-after-load 'lsp-mode
;;     (setq conda-env-home-directory "/Users/yunj/.conda")
;;     ))

;; information for debugging authentication in *Messages* buffer
;; (setq auth-source-debug t)

;;; languagetool
;; (setq langtool-bin "languagetool")
(setq langtool-language-tool-server-jar "/usr/local/Cellar/languagetool/5.3/libexec/languagetool-server.jar")
;; (setq langtool-http-server-host "localhost"
;;       langtool-http-server-port 8081)

;; (byte-recompile-directory (expand-file-name "~/.doom.d/") 0) ;
;; (byte-compile-file (expand-file-name "modules/private/reference/autoload/applescript.el" doom-private-dir))
;; (shell-command "find ~/.doom.d/ -type f -name \"*.elc\" -delete")

;;; printer
(setq pdf-misc-print-program "lpr"
      pdf-misc-print-program-args nil)

;;; abbrev
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
  (setq abbrev-file-name (expand-file-name "abbrev.el" doom-private-dir)
        save-abbrevs 'silently))

;;; online lookup
(setq +lookup-provider-url-alist
      (append +lookup-provider-url-alist
              '(("Google Scholar"       "http://scholar.google.com/scholar?q=%s")
                ("Crossref"             "http://search.crossref.org/?q=%s")
                ("PubMed"               "http://www.ncbi.nlm.nih.gov/pubmed/?term=%s")
                ("arXiv"                "https://arxiv.org/search/?query=%s&searchtype=all&abstracts=show&order=-announced_date_first&size=50")
                ("Semantic Scholar"     "https://www.semanticscholar.org/search?q=%s")
                ("Dictionary.com"       "http://dictionary.reference.com/browse/%s?s=t")
                ("Thesaurus.com"        "http://www.thesaurus.com/browse/%s")
                ("Merriam-Webster"      "https://www.merriam-webster.com/dictionary/%s")
                )))


;; (map! :map mu4e-view-mode-map
;;       :nme "H-c" #'(lambda ()
;;                    (interactive)
;;                    (let* ((mu4e-subject (mu4e-message-field-at-point :subject)))
;;                      (setq jyun/target-mu4e-subject mu4e-subject)
;;                      (org-capture nil "ATE"))))

(use-package! lexic
  :commands lexic-search lexic-list-dictionary
  :config
  (setq lexic-dictionary-path  (expand-file-name "~/Dropbox/emacs/stardict/dic/"))
  (map! :map lexic-mode-map
        :n "q" #'lexic-return-from-lexic
        :nv "RET" #'lexic-search-word-at-point
        :n "a" #'outline-show-all
        :n "h" (cmd! (outline-hide-sublevels 3))
        :n "o" #'lexic-toggle-entry
        :n "n" #'lexic-next-entry
        :n "N" (cmd! (lexic-next-entry t))
        :n "p" #'lexic-previous-entry
        :n "P" (cmd! (lexic-previous-entry t))
        :n "E" (cmd! (lexic-return-from-lexic) ; expand
                     (switch-to-buffer (lexic-get-buffer)))
        :n "M" (cmd! (lexic-return-from-lexic) ; minimise
                     (lexic-goto-lexic))
        :n "C-p" #'lexic-search-history-backwards
        :n "C-n" #'lexic-search-history-forwards
        :n "/" (cmd! (call-interactively #'lexic-search))))

;;; elfeed
;; (evil-set-initial-state 'elfeed-search-mode 'emacs)
;; (evil-set-initial-state 'elfeed-show-mode 'emacs)

(after! elfeed
  (run-at-time nil (* 8 60 60) #'elfeed-update)
  (setq elfeed-search-title-max-width 100
        elfeed-search-title-min-width 20
        elfeed-search-filter "@2-week-ago"
        elfeed-show-entry-switch #'pop-to-buffer
        elfeed-show-entry-delete #'+rss/delete-pane))

(use-package elfeed-score
  :after elfeed
  :init
  (setq elfeed-score-score-file (expand-file-name "elfeed.score" doom-private-dir))
  :config
  (progn
    (elfeed-score-enable)
    (define-key elfeed-search-mode-map "=" elfeed-score-map)
    ;; scores displayed in the search buffer
    (setq elfeed-search-print-entry-function #'elfeed-score-print-entry)))

;;; get pdf from elfeed entry
;; https://tecosaur.github.io/emacs-config/config.html
(after! elfeed-show
  (require 'url)

  (defvar elfeed-pdf-dir
    (expand-file-name "pdfs/"
                      (file-name-directory (directory-file-name elfeed-enclosure-default-dir))))

  (defvar elfeed-link-pdfs
    '(("https://www.jstatsoft.org/index.php/jss/article/view/v0\\([^/]+\\)" . "https://www.jstatsoft.org/index.php/jss/article/view/v0\\1/v\\1.pdf")
      ("http://arxiv.org/abs/\\([^/]+\\)" . "https://arxiv.org/pdf/\\1.pdf"))
    "List of alists of the form (REGEX-FOR-LINK . FORM-FOR-PDF)")

  (defun elfeed-show-pdf (entry)
    (interactive
     (list (or elfeed-show-entry (elfeed-search-selected :ignore-region))))
    (let ((link (elfeed-entry-link entry))
          (feed-name (plist-get (elfeed-feed-meta (elfeed-entry-feed entry)) :title))
          (title (elfeed-entry-title entry))
          (file-view-function
           (lambda (f)
             (when elfeed-show-entry
               (elfeed-kill-buffer))
             (pop-to-buffer (find-file-noselect f))))
          pdf)

      (let ((file (expand-file-name
                   (concat (subst-char-in-string ?/ ?, title) ".pdf")
                   (expand-file-name (subst-char-in-string ?/ ?, feed-name)
                                     elfeed-pdf-dir))))
        (if (file-exists-p file)
            (funcall file-view-function file)
          (dolist (link-pdf elfeed-link-pdfs)
            (when (and (string-match-p (car link-pdf) link)
                       (not pdf))
              (setq pdf (replace-regexp-in-string (car link-pdf) (cdr link-pdf) link))))
          (if (not pdf)
              (message "No associated PDF for entry")
            (message "Fetching %s" pdf)
            (unless (file-exists-p (file-name-directory file))
              (make-directory (file-name-directory file) t))
            (url-copy-file pdf file)
            (funcall file-view-function file))))))
  )

;;; org-roam-server
 (use-package org-roam-server
   ;; :after (org-roam server)
   :defer t
   :config
   (setq org-roam-server-host "127.0.0.1"
         org-roam-server-port 8080
         org-roam-server-authenticate nil
         org-roam-server-export-inline-images t
         ;; org-roam-server-serve-files nil
         ;; org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
         ;; org-roam-server-network-poll t
         ;; org-roam-server-network-arrows nil
         org-roam-server-network-label-truncate t
         org-roam-server-network-label-truncate-length 60
         org-roam-server-network-label-wrap-length 20)
   :init
   (defun org-roam-server-open ()
     "Ensure the server is active, then open the roam graph."
     (interactive)
     (progn
       (if org-roam-server-mode t (org-roam-server-mode 1))
       (browse-url (format "http://localhost:%d" org-roam-server-port))))
   (map!
    :leader "nrs" #'org-roam-server-open))


;;; org-roam
(after! org-roam
  (setq org-roam-graph-executable
        ;; "circo"
        ;; "neato"
        ;; "twopi"
        ;; "circo"
        "fdp"
        ;; "sfdp"
        ;; "patchwork"
        ;; "osage"
        )
  (setq org-roam-graph-node-extra-config
        '(("shape"      . "underline")
          ("style"      . "rounded,filled")
          ("fillcolor"  . "#EEEEEE")
          ("color"      . "#C9C9C9")
          ("fontcolor"  . "#111111")
          ("fontname"   . "Overpass")))

  (setq +org-roam-graph--html-template
        (replace-regexp-in-string "%\\([^s]\\)" "%%\\1"
                                  (f-read-text (concat doom-private-dir "misc/org-roam-template.html"))))

  (defadvice! +org-roam-graph--build-html (&optional node-query callback)
    "Generate a graph showing the relations between nodes in NODE-QUERY. HTML style."
    :override #'org-roam-graph--build
    (unless (stringp org-roam-graph-executable)
      (user-error "`org-roam-graph-executable' is not a string"))
    (unless (executable-find org-roam-graph-executable)
      (user-error (concat "Cannot find executable %s to generate the graph.  "
                          "Please adjust `org-roam-graph-executable'")
                  org-roam-graph-executable))
    (let* ((node-query (or node-query
                           `[:select [file title] :from titles
                             ,@(org-roam-graph--expand-matcher 'file t)]))
           (graph      (org-roam-graph--dot node-query))
           (temp-dot   (make-temp-file "graph." nil ".dot" graph))
           (temp-graph (make-temp-file "graph." nil ".svg"))
           (temp-html  (make-temp-file "graph." nil ".html")))
      (org-roam-message "building graph")
      (make-process
       :name "*org-roam-graph--build-process*"
       :buffer "*org-roam-graph--build-process*"
       :command `(,org-roam-graph-executable ,temp-dot "-Tsvg" "-o" ,temp-graph)
       :sentinel (progn
                   (lambda (process _event)
                     (when (= 0 (process-exit-status process))
                       (write-region (format +org-roam-graph--html-template (f-read-text temp-graph)) nil temp-html)
                       (when callback
                         (funcall callback temp-html))))))))

  ;; no numbers in org-roam buffers
  (defadvice! doom-modeline--buffer-file-name-roam-aware-a (orig-fun)
    :around #'doom-modeline-buffer-file-name ; takes no args
    (if (s-contains-p org-roam-directory (or buffer-file-name ""))
        (replace-regexp-in-string
         "\\(?:^\\|.*/\\)\\([0-9]\\{4\\}\\)\\([0-9]\\{2\\}\\)\\([0-9]\\{2\\}\\)[0-9]*-"
         "🢔(\\1-\\2-\\3) "
         (subst-char-in-string ? ?  buffer-file-name)
         )
      (funcall orig-fun)))
  )

;;; dired "J"
;; replace `dired-goto-file' with equivalent helm and ivy functions:
;; `helm-find-files' fuzzy matching and other features
;; `counsel-find-file' more `M-o' actions
(with-eval-after-load 'dired
  (evil-define-key 'normal dired-mode-map "J"
    (cond ((featurep! :completion helm) 'helm-find-files)
          ((featurep! :completion ivy) 'counsel-find-file))))

(after! ivy-posframe
  (setq ivy-posframe-parameters
        `((min-width . ;; 90
                     20          )
          (min-height . ,ivy-height)
          ;; (left-fringe . 8)
          ;; (right-fringe . 8)
          )
        ))

;;; conda
(use-package! conda
  :after python
  :config
  (setq conda-anaconda-home (expand-file-name "/opt/intel/oneapi/intelpython/latest")
        conda-env-home-directory (expand-file-name "~/.conda"))

  ;; integration with term/eshell
  (conda-env-initialize-interactive-shells)
  (after! eshell (conda-env-initialize-eshell))

  (add-to-list 'global-mode-string
               '(conda-env-current-name (" conda:" conda-env-current-name " "))
               'append)
  )

;; ;; ;; ;; python lsp
;; (after! lsp-python-ms
;;   (set-lsp-priority! 'mspyls 1))

;;; no evil-snipe
(after! evil-snipe
  (pushnew! evil-snipe-disabled-modes 'ibuffer-mode 'dired-mode))

