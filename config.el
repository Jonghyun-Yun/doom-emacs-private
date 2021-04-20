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

;; passwords to be accessible
(use-package! pass)

;;; load lisp
(with-eval-after-load 'hydra
  (load! "lisp/hydra-plus"))
(load! "bindings")
(load! "lisp/mu4e-plus")
(load! "lisp/org-plus")
(load! "lisp/ligature")
(load! "lisp/ess-plus")
(load! "lisp/latex-plus")
(load! "lisp/visual-plus")
(load! "lisp/elfeed")

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

(after! plantuml-mode
  (setq plantuml-jar-path "/usr/local/Cellar/plantuml/*/libexec/plantuml.jar"
        org-plantuml-jar-path plantuml-jar-path))

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
      truncate-string-ellipsis "…"               ; Unicode ellispis are nicer than "...", and also save /precious/ space
      yas-triggers-in-field t ;snippets inside snippets
      )

;;; company
(after! company
  (setq company-idle-delay 0.5
        company-minimum-prefix-length 2
        company-tooltip-limit 10
        ;; company-box-enable-icon nil ;;disable all-the-icons
        ))

;; company memory
(setq-default history-length 1000)
(setq-default prescient-history-length 1000)


;;; org-mode
(after! org
  ;; rendering when not at point
  ;; (use-package! org-fragtog
  ;; :hook (org-mode . org-fragtog-mode))

  (when (featurep! :lang org +pretty)
    (setq org-superstar-headline-bullets-list '("♠" "♡" "♦" "♧")
          org-superstar-remove-leading-stars nil
          ))

  ;; background color for org-latex
  ;; (+org-refresh-latex-background-h)
  (setq
   ;; org-export-in-background t                  ; async export by default

   org-fontify-quote-and-verse-blocks nil
   org-fontify-whole-heading-line nil

   org-journal-encrypt-journal t
   ;; org-hide-leading-stars t
   ;; org-startup-indented nil

   ;; org-ellipsis " ▾ "
   ;; org-ellipsis "  ⏷  "
   org-ellipsis " ▼ "

   org-indent-indentation-per-level 1
   org-adapt-indentation nil

   ;; tag indent
   ;; org-tags-column -77

   ;; org export global setting
   org-export-with-toc nil
   org-log-done 'time
   ;; latex highlight
   ;; org-highlight-latex-and-related '(native)
   ;; don't ask to follow elisp link
   org-confirm-elisp-link-function nil
   )

  ;; (setq org-insert-heading-respect-content nil)

  ;; default attach folder
  ;; (after! org-attach
  ;;   (setq
  ;;    org-attach-id-dir "data/"))

  ;; visual-mode tab binds back to org-cycle
  (remove-hook 'org-tab-first-hook #'+org-yas-expand-maybe-h)

  ;; insert-mode tab binds back to org-cycle
  (remove-hook 'org-tab-first-hook #'+org-indent-maybe-h))

;;;; org-latex
(after! org
  ;; adjust background colors of org-latex fragments
  ;; call it manually!
  ;; (add-hook! 'org-mode-hook #'my/org-latex-set-directory-name-to-background)
  ;; (add-hook! 'doom-load-theme-hook #'my/org-latex-set-directory-name-to-background)

  (setq org-highlight-latex-and-related '(native script entities))
  (add-to-list 'org-src-block-faces '("latex" (:inherit default :extend t)))
  (setq org-format-latex-options
        (plist-put org-format-latex-options :background "Transparent"))

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

  ;; https://stackoverflow.com/questions/43149119/how-to-regenerate-latex-fragments-in-org-mode
  (defvar my/org-latex-toggle-fragment-has-been-called nil
    "Tracks if org-toggle-latex-fragment has ever been called (updated locally).")

  (defadvice org-toggle-latex-fragment (before my/latex-fragments-advice activate)
    "Keep Org LaTeX fragments in a directory with background color name."
    (if (not my/org-latex-toggle-fragment-has-been-called) (jyun/org-latex-set-options))
    (setq-local my/org-latex-toggle-fragment-has-been-called t)
    (jyun/org-latex-set-directory-color))

  (defadvice load-theme (after my/load-theme-advice-for-latex activate)
    "Conditionally update Org LaTeX fragments for current background."
    (if my/org-latex-toggle-fragment-has-been-called (jyun/org-latex-update-fragments-color)))

  (defadvice disable-theme (after my/disable-theme-advice-for-latex activate)
    "Conditionally update Org LaTeX fragments for current background."
    (if my/org-latex-toggle-fragment-has-been-called (jyun/org-latex-update-fragments-color)))

  (defun jyun/org-latex-set-directory-color ()
    "Set Org LaTeX directory name to default face"
    (interactive)
    (setq org-preview-latex-image-directory
          (concat "ltximg/_" (alist-get 'foreground-color (frame-parameters))
                  (let ((color (color-values (alist-get 'foreground-color (frame-parameters)))))
                    (apply 'concat (mapcar (lambda (x) (concat "_" x)) (mapcar 'int-to-string color))))
                  "/")))

  (defun jyun/org-latex-update-fragments-color ()
    "Remove Org LaTeX fragment layout, switch directory for face color, turn fragments back on."
    (interactive)
    ;; removes latex overlays in the whole buffer
    (org-remove-latex-fragment-image-overlays)

    ;; background directory switch
    (jyun/org-latex-set-directory-color)
    ;; recreate overlay
    ;; Argument '(16) is same as prefix C-u C-u,
    ;; means create images in the whole buffer instead of just the current section.
    ;; For many new images this will take time.
    (org-toggle-latex-fragment '(16)))
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
        org-latex-tables-booktabs t
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

;;; org-tree-slide
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
             ;; #'jyun/org-present-hide
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

  (defun jyun/org-tree-slide (orig-fun &rest args)
    "Hide a few `org-element'. Then, do `org-tree-slide-mode'."
    (progn
      (jyun/org-present-hide)
      (apply orig-fun args)
      ))
  (advice-add 'org-tree-slide-mode :around #'jyun/org-tree-slide)

  ;; cause errors in navigating slides
  ;; (advice-remove 'org-tree-slide--display-tree-with-narrow #'+org-present--narrow-to-subtree-a)
  )

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

;;;; conda
(with-eval-after-load 'conda
  (setq conda-anaconda-home "/opt/intel/oneapi/intelpython/latest"
        conda-env-home-directory "/Users/yunj/.conda")
  ;; (conda-env-initialize-interactive-shells)
  ;; (conda-env-initialize-eshell)
  )
;; (setq conda-env-autoactivate-mode t)

;;;; debugging
;; set this variable again after lsp
;; otherwise the default evn-home will be used
(when (featurep! :tools debugger +lsp)
  (with-eval-after-load 'lsp-mode
    (setq conda-env-home-directory "/Users/yunj/.conda")
    ))

;; information for debugging authentication in *Messages* buffer
;; (setq auth-source-debug t)

;;; languagetool
;; (setq langtool-bin "languagetool")
(setq langtool-language-tool-server-jar "/usr/local/Cellar/languagetool/*/libexec/languagetool-server.jar")
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
                ("arXiv"     "https://arxiv.org/search/?query=%s&searchtype=all&abstracts=show&order=-announced_date_first&size=50")
                ("Semantic Scholar"     "https://www.semanticscholar.org/search?q=%s")
                ("Dictionary.com"     "http://dictionary.reference.com/browse/%s?s=t")
                ("Thesaurus.com"   "http://www.thesaurus.com/browse/%s")
                )))


;; async-operations
;; commented out, messages are not sent, disapper
;; (require 'smtpmail-async)
;; (setq send-mail-function         'async-smtpmail-send-it
;; message-send-mail-function 'async-smtpmail-send-it)

;; elfeed capture
(add-to-list 'org-capture-templates
             '("EFE" "Elfeed entry" entry
               (file+headline "~/org/inbox.org" "Tasks")
               "* TODO %(elfeed-entry-title jyun/target-elfeed-entry) :rss:
:PROPERTIES:
:CREATED: %U
:LINK: %a
:URL: %(elfeed-entry-link jyun/target-elfeed-entry)
:END:
%i \n%?"
               :prepend t
               ))

;; email capture
(add-to-list 'org-capture-templates
             '("ATE" "Attention to Emails" entry
               (file+headline "~/org/inbox.org" "Tasks")
               "* TODO %(message jyun/target-mu4e-subject) :@email:
:PROPERTIES:
:CREATED: %U
:LINK: %a
:END:
%i \n%?"
               :prepend t
               ))

;; (map! :map mu4e-view-mode-map
;;       :nme "H-c" #'(lambda ()
;;                    (interactive)
;;                    (let* ((mu4e-subject (mu4e-message-field-at-point :subject)))
;;                      (setq jyun/target-mu4e-subject mu4e-subject)
;;                      (org-capture nil "ATE"))))
