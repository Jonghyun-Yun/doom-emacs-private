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

;; "Iosevka SS08" ;; Monospace, Pragmata Pro Style
;; "Iosevka SS09" ;; Monospace, Source Code Pro Style
(setq doom-font (font-spec :family "Iosevka SS08" :size 20 :weight 'light)
      doom-variable-pitch-font (font-spec :family "Iosevka Sparkle" :weight 'light)
      ;; doom-unicode-font (font-spec :family "Iosevka SS08" :weight 'light)
      doom-big-font (font-spec :family "Iosevka SS08" :size 26 :weight 'light)
      )

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

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
  ;;       doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; (load-theme 'doom-one t)

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
  ;; (add-hook 'dired-mode-hook #'treemacs-icons-dired-mode)
  ;; )

;; disable flycheck by default
(after! flycheck
  (remove-hook 'doom-first-buffer-hook #'global-flycheck-mode)
  )

;; make-frame doesn't create a new persp
(after! persp-mode
  (remove-hook 'after-make-frame-functions #'persp-init-new-frame)
  )

(after! projectile
  (projectile-add-known-project "~/Dropbox/research/lsjm-art")
  (projectile-add-known-project "~/Dropbox/utsw-projects/HITS-CLIP")
  (projectile-add-known-project "~/OneDrive/research/lapf")
  (projectile-add-known-project "~/OneDrive/research/s.ham/RAS")
  )

(load! "+bindings")

(after! mu4e
  (load! "lisp/mu4e-plus"))

(load! "lisp/latex-plus")
(setq +latex-viewers '(skim pdf-tools))

(after! ess
  (load! "lisp/ess-plus")
  (evil-set-initial-state 'inferior-ess-mode 'emacs)
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

(setq ispell-check-comments nil)

;; spacemacs value of parameters
(setq scroll-conservatively 0)

;; prevent some cases of Emacs flickering
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

(auto-save-visited-mode +1)
;; no accumulating drafts
(add-hook 'mu4e-compose-mode-hook #'(lambda () (auto-save-visited-mode -1)))

;; wonder what happedn if I accidently close it

(setq company-idle-delay nil
      company-tooltip-limit 10
      company-box-enable-icon nil ;;disable all-the-icons
      )

;; Switch to the new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;; (setq trash-directory "~/.Trash/")

(after! org
  ;; (remove-hook 'org-mode-hook #'org-superstar-mode)
  (setq
   org-fontify-quote-and-verse-blocks nil
   org-fontify-whole-heading-line nil
   org-ellipsis " ▼ "
   org-journal-encrypt-journal t
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
   )
  ;; (setq org-insert-heading-respect-content nil)
)
  ;; (add-to-list 'org-modules 'org-habit t)

;; https://gitlab.com/oer/org-re-reveal-ref/-/blob/master/org-re-reveal-ref.el
;; it changes some of org-ref custom variables
(use-package! org-re-reveal-ref
  :after org-re-reveal
  )

;; Set LaTeX preview image size for Org and LaTeX buffers.
;; latex-preview size
(set 'preview-scale-function 1.5)
;; org-latex-preview size
(setq org-format-latex-options
      (quote
       (:foreground default :background default :scale 1.5 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
        ("begin" "$1" "$" "$$" "\\(" "\\["))
       ))

(after! ess-mode
  (setq ess-r-smart-operators t
        ess-use-ido t) ;; what is this?
  )

(use-package! mathpix.el
  :commands (mathpix-screenshot)
  :init
  (map! "C-c n m" #'mathpix-screenshot)
  :custom
  (mathpix-screenshot-method "screencapture -i %s")
  (mathpix-app-id (password-store-get "mathpix/app-id"))
  (mathpix-app-key (password-store-get "mathpix/app-key"))
  )

(with-eval-after-load 'org-roam
  (setq org-roam-graph-viewer "/Applications/Firefox.app/Contents/MacOS/firefox-bin")
  ;; (setq org-roam-graph-executable "neato")
  ;; (setq org-roam-graph-extra-config '(("overlap" . "false")))
  )

;; improve slow scrolling?
(use-package! hl-line+
 :config
 (hl-line-when-idle-interval 0.5)
 (toggle-hl-line-when-idle 1))

;; maximize frame at startup
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;;; Fewer garbage collection
;; Number of bytes of consing between garbage collections.
;; (defun set-gc-cons-threshold-normal (mb)
;;   "Set gc-cons-threshold in MB"
;;   (setq gc-cons-threshold (round (* mb 1000 1000))))

(setq garbage-collection-messages nil)
;; (add-hook 'after-init-hook #'(lambda () (set-gc-cons-threshold-normal 0.8)))

;; no need: gcmh: https://github.com/emacsmirror/gcmh
;; (add-hook 'focus-out-hook #'garbage-collect)

;; ;;; https://emacs.stackexchange.com/questions/30082/your-python-shell-interpreter-doesn-t-seem-to-support-readline
;; (with-eval-after-load 'python
;;   (defun python-shell-completion-native-try ()
;;     "Return non-nil if can trigger native completion."
;;     (let ((python-shell-completion-native-enable t)
;;           (python-shell-completion-native-output-timeout
;;            python-shell-completion-native-try-output-timeout))
;;       (python-shell-completion-native-get-completions
;;        (get-buffer-process (current-buffer))
;;        nil "_"))))

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
  ;; (setq which-key-idle-delay 10000)
  ;; (setq which-key-idle-secondary-delay 0.05)
  ;; (which-key-mode)
)

;; (with-eval-after-load 'elpa-mirror
;;   ;; local-melpa directory
;;   (setq elpamr-default-output-directory "~/.doom.d/local-melpa/")
;;   )

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

;; set korean keyboard layout
;; C-\ to switch input-method
(setq default-input-method "korean-hangul3f")

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

;; Hangout
(after! jabber
  (setq jabber-account-list '(("jonghyun.yun@gmail.com/emacs"
                               (:password. (password-store-get "hangouts/password"))
                               (:network-server . "talk.google.com")
                               (:connection-type . starttls)
                               )))
  ;; (jabber-connect-all)
  )

(after! paradox
  (setq paradox-github-token (password-store-get "paradox/github-token"))
  )

;; Other options
;; replace highlighted text with what I type
;; (delete-selection-mode 1)

(setq display-time-24hr-format t
      mouse-autoselect-window nil
      ;; indicate-unused-lines nil
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
        matlab-shell-ask-MATLAB-for-completions nil
        matlab-shell-command-switches '("-nodesktop" "-nosplash"))

  ;; set column for matlab m file buffer
  (add-hook 'matlab-mode-hook
            (lambda ()
              (set-fill-column 100)))

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
       +biblio-notes-path "~/org/refnotes.org")

;; open zotero pdf in org-ref
(after! org-ref
  (setq org-ref-default-bibliography "~/Zotero/myref.bib"
        org-ref-pdf-directory "~/Zotero/storage/"
        org-ref-bibliography-notes "~/org/refnotes.org")
  )

(after! bibtex-completion
  (setq bibtex-completion-library-path "~/Zotero/storage/"
        bibtex-completion-bibliography org-ref-default-bibliography
        bibtex-completion-notes-path org-ref-bibliography-notes
        bibtex-completion-pdf-field "file"
        bibtex-completion-find-additional-pdfs t)
  )

;; for doom-modeline
(use-package! find-file-in-project
  :config
  (setq ffip-use-rust-fd t)
  :general ([remap projectile-find-file] #'find-file-in-project)
  )

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
  (setq doom-modeline-icon nil)

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

(with-eval-after-load 'notmuch
  (setq +notmuch-sync-backend 'mbsync
        +notmuch-sync-command "mbsync -a"
        +notmuch-mail-folder "~/.mail/")
  )

(with-eval-after-load 'wordnut
  (setq wordnut-cmd "/usr/local/bin/wn"))

;; The text-scaling level for writeroom-mode
(after! writeroom-mode
  (setq +zen-text-scale 1.2)
  )

(after! org-msg
  (setq org-msg-options
        (concat org-msg-options " num:nil"))
  )

;; OS X ls not working with --quoting-style=literal
(after! fd-dired
  (when IS-MAC
    (setq fd-dired-ls-option ("| xargs -0 gls -ld --quoting-style=literal" . "-ld"))
    )
  )

(setq cdlatex-math-symbol-alist
      '((?: ("\\cdots" "\\ldots"))
        )
      )

;; (use-package scihub)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   '("~/Dropbox/research/lsjm-art/lsjm-art.org" "~/org/inbox.org" "~/org/todo.org" "~/org/gcal.org" "~/org/projects.org" "~/org/tickler.org" "~/org/routines.org"))
 '(safe-local-variable-values '((TeX-engine . xetex))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
