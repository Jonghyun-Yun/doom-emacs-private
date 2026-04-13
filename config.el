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
;;   presentations or streaming
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
;;  doom-font (font-spec :family "Iosevka SS08" :size 24 :weight 'light)
;;  doom-big-font (font-spec :family "Iosevka SS08" :size 36 :weight 'light)
;;  ;; doom-variable-pitch-font (font-spec :family "Iosevka Etoile" :weight 'light)
;;  doom-variable-pitch-font (font-spec :family "Iosevka Aile" :weight 'light)
;;  doom-unicode-font (font-spec :family "Sarasa Mono K" :weight 'light)
;;  doom-serif-font (font-spec :family "Iosevka Slab" :weight 'light))

;; (setq
;;  doom-font (font-spec :family "Iosevka" :size 18)
;;  doom-big-font (font-spec :family "Iosevka" :size 28)
;;  ;; doom-variable-pitch-font (font-spec :family "Iosevka Etoile" :weight 'light)
;;  doom-variable-pitch-font (font-spec :family "Iosevka Aile" :size 18)
;;  doom-unicode-font (font-spec :family "JuliaMono" :size 18)
;;  ;; doom-serif-font (font-spec :family "IBM Plex Mono" :weight 'light :size 18)
;;  doom-serif-font (font-spec :family "Iosevka Slab" :size 18)
;; )

(setq doom-font (font-spec :family "JetBrains Mono" :size 18)
      doom-big-font (font-spec :family "JetBrains Mono" :size 28)
      doom-variable-pitch-font (font-spec :family "Overpass" :size 18)
      doom-unicode-font (font-spec :family "JuliaMono" :size 18)
      doom-serif-font (font-spec :family "IBM Plex Mono" :weight 'light :size 18))

(setq variable-pitch-serif-font (font-spec :family "Alegreya" :size 20))
;; (setq variable-pitch-serif-font (font-spec :family "Roboto Slab" :size 24 :weight 'light))
;; (setq variable-pitch-serif-font (font-spec :family "Libre Baskerville" :size 23 :weight 'light))
;; (setq variable-pitch-serif-font (font-spec :family "Libertinus Serif" :size 27 :weight 'light))
;; (setq variable-pitch-serif-font (font-spec :family "Merriweather" :size 24 :weight 'light))

(when IS-LINUX
  (setq doom-font (font-spec :family "JetBrains Mono" :size 16)
        doom-big-font (font-spec :family "JetBrains Mono" :size 26)
        doom-variable-pitch-font (font-spec :family "Overpass" :size 16)
        doom-unicode-font (font-spec :family "JuliaMono" :size 16)
        doom-serif-font (font-spec :family "IBM Plex Mono" :weight 'light :size 16))
  (setq variable-pitch-serif-font (font-spec :family "Alegreya" :size 18)))

;; missing out on the following Alegreya ligatures:
(set-char-table-range composition-function-table ?f '(["\\(?:ff?[fijlt]\\)" 0 font-shape-gstring]))
(set-char-table-range composition-function-table ?T '(["\\(?:Th\\)" 0 font-shape-gstring]))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one-light)
;; (load-theme 'doom-one-light t)
;; (load-theme 'doom-nord t)
(setq doom-theme 'modus-operandi)
;; (load-theme 'modus-operandi t)
;; (when IS-LINUX
;;   (load-theme 'doom-one t))
(unless (display-graphic-p)
  (load-theme 'doom-nord t))

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

(defvar IS-GUI (display-graphic-p)
"(display-graphic-p)")

;; (if (version= emacs-version "29.0.50")
;;     (pixel-scroll-precision-mode))

;;; load lisp
(setq load-prefer-newer t)
;; (with-eval-after-load 'hydra
;;   (load! "local/hydra-plus")
;;   )
(load! "bindings")

(when IS-MAC
  (setq system-screenshot-method "pngpaste %s"))

(when (not (modulep! :lang org +roam2))
  (setq! org-roam-directory "~/org/roam")
  )

;; TODO: nil causes emacs to freeze
(setq org-element-use-cache t)

;; no [[roam:]] links
(after! org
  (setq org-roam-completion-everywhere nil)
)

;; https://gist.github.com/d12frosted/a60e8ccb9aceba031af243dff0d19b2e
;; don't add all org-roam files to agenda
;; only those who with TODO keywords, schedule, or deadline
;; run before org-plus
(after! org
  ;; https://zzamboni.org/post/how-to-insert-screenshots-in-org-documents-on-macos/
  (remove-hook 'org-load-hook #'+org-init-capture-defaults-h)
  (add-to-list 'org-tags-exclude-from-inheritance "roadmap")
  (when (modulep! :lang org +roam2)
    (load! "local/vulpea-agenda/vulpea-agenda")
  )
  (setq +org-capture-job-file "~/org/jobs.org")
  (setq +org-capture-bookmark-file "~/org/inbox.org")

  ;; Suppress the spurious "Tab width in Org files must be 8, not 8" warning.
  ;; The warning comes from the `org-current-text-column' macro (org-macs.el),
  ;; which is expanded inline into compiled callers — it cannot be advised or
  ;; redefined after the fact.  Org already resets tab-width to 8 before the
  ;; warn call fires, so the fix is functional; only the noise needs muting.
  (defun my/suppress-org-tab-width-warning (orig-fn fmt &rest args)
    "Filter out the Org tab-width warning while letting all others through."
    (unless (and (stringp fmt)
                 (string-match-p "Tab width in Org files must be" fmt))
      (apply orig-fn fmt args)))
  (advice-add 'warn :around #'my/suppress-org-tab-width-warning)
  )
(after! org-download
  (setq org-download-screenshot-method system-screenshot-method)
  )

(load! "local/org-plus")

;; ;; (when (modulep! :ui ligatures +extra)
;; ;;   (load! "local/ligature"))

(when (modulep! :lang latex)
  (load! "local/latex-plus")
  )
(when (modulep! :lang ess)
  (load! "local/ess-plus")
  )

;; theme setting causes emacs to freeze
;; (load! "local/visual-plus")
;; (load! "local/font-face-plus")

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
  )

;; Dropbox sync changes hangul encoding to NFD, which results in 한글 자소분리 in dired and other modes
;; https://tt.kollhong.com/79
;; https://nullprogram.com/blog/2014/06/13/
(when IS-MAC
  (use-package! ucs-normalize
    :config
    (set-file-name-coding-system 'utf-8-hfs)))

;; org -> latex -> md -> docx
;; to properly generate cross references
;; https://github.com/lierdakil/pandoc-crossref
;; (use-package! md-word
;;   :load-path "local/"
;;   :after ox
;;   :config
;;   (after! ox-pandoc
;;     (add-to-list 'org-pandoc-valid-options 'citeproc))
;;   )

;;; email
(when (modulep! :email mu4e)
  (load! "local/mu4e-plus"))
(when (modulep! :email notmuch)
  (setq +notmuch-sync-backend 'mbsync))

;;; LaTeX
;; disable `rainbow-mode' after applying styles to the buffer.
;; (remove-hook 'TeX-update-style-hook #'rainbow-delimiters-mode)

(setq +latex-viewers '(pdf-tools skim))
;; (setq +latex-viewers '(skim pdf-tools))

(after! latex
  (defun latex-init-pdf-view ()
    (progn
      (pdf-view-fit-height-to-window)
      ;; (pdf-view-auto-slice-minor-mode)
      ))
  (add-hook 'pdf-view-mode-hook 'latex-init-pdf-view)

  ;; This variable was introduced in AUCTeX 11.90.
  ;; We need set LaTeX-reftex-cite-format-auto-activate to nil
  ;; when setting reftex-cite-format below
  ;; https://superuser.com/a/1386206
  (setq LaTeX-reftex-cite-format-auto-activate t)
  ;; make AUCTeX save files without asking
  (setq! TeX-save-query nil
         TeX-show-compilation nil
         ;; the below is buffer-local ???
         TeX-command-extra-options "-shell-escape"))

;; Set LaTeX preview image size for Org and LaTeX buffers.
(after! preview
  ;; latex-preview size
  (setq preview-scale 1.5)
  ;; (set 'preview-scale-function 1.75)
  )

;; ;; trying to turn off `rainbow-delimiters-mode'. not working..
;; (add-hook! 'LaTeX-mode-hook #'(lambda () (rainbow-delimiters-mode -1)))
;; (remove-hook 'TeX-update-style-hook #'rainbow-delimiters-mode)

(use-package! emacs-overleaf
  :commands (overleaf-setup
             emacs-overleaf-mode))

;;; org-mode
(when (modulep! :lang org +pretty)
  (after! org-superstar
    ;; (remove-hook 'org-mode-hook 'org-superstar-mode) ; manually turn it on!
    (setq ;; org-superstar-headline-bullets-list '("♠" "♡" "♦" "♧")
          org-superstar-remove-leading-stars nil)))

(setq ;; org-src-window-setup 'current-window
 org-src-window-setup 'other-window
 org-return-follows-link t
 org-startup-with-inline-images t
 ;; org-use-speed-commands
 ;; (lambda () (and (looking-at org-outline-regexp) (looking-back "^\\**")))
 ;; nil
 org-log-into-drawer t)
;; (setq org-ellipsis
;; ;;       ;; " ▾ " ; FiraGo
;; ;;       ;; " ▼ " ; Alegreya Sans
;; ;;       ;; " ⬎ " ; IBM Plex Mono
;; ;;       ;; " ↩ " ; firacode
;;             " ⤶ " ; juliamono
;; ;;       ;; " ⤵ "
;; ;;       ;; "… "
;; ;;       ;; " ↴ "
;; ;;       ;; " ⤷ "
;; ;;       org-cycle-separator-lines 2     ; -1 or 1 to use unicode org-ellipsis
;;       )
(setq
 ;; org-export-in-background t                  ; async export by default
 org-fontify-quote-and-verse-blocks nil
 org-fontify-whole-heading-line nil
 ;; org-hide-leading-stars nil
 org-startup-indented t
 org-habit-show-habits-only-for-today t
 org-journal-encrypt-journal t
 org-indent-indentation-per-level 2
 org-adapt-indentation t
 ;; tag indent
 ;; org-tags-column -77
 org-log-done 'time
 ;; don't ask to follow elisp link
 org-link-elisp-confirm-function nil
 ;; org export global setting
 org-export-with-toc nil
 org-export-with-tags nil)
  ;; org-insert-heading-respect-content nil
  ;; default attach folder
  ;;    org-attach-id-dir "data/"

;;; org-modern
(use-package! org-modern
  :if IS-GUI
  ;; :after org
  :hook (
         (org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda)
         )
  ;; :init
  ;; (global-org-modern-mode)
  :config
  (setq
   ;; Edit settings
   org-auto-align-tags nil
   org-tags-column 0
   org-catch-invisible-edits 'show-and-error
   org-special-ctrl-a/e t
   org-insert-heading-respect-content t

   ;; Org styling, hide markup etc.
   ;; org-modern-star ["♠""♡""♦""♧"]
   org-modern-replace-stars "♠♡♦♧◉○◈◇⁕"
   org-hide-emphasis-markers nil
   org-pretty-entities t

   ;; Agenda styling
   org-agenda-tags-column 0
   org-agenda-block-separator ?─
   org-agenda-time-grid
   '((daily today require-timed)
     (800 1000 1200 1400 1600 1800 2000)
     " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
   org-agenda-current-time-string
   "⭠ now ─────────────────────────────────────────────────")

  ;; Ellipsis styling
  (setq org-ellipsis "…")
  (set-face-attribute 'org-ellipsis nil :inherit 'default :box nil)

  ;; table styling
  (setq org-modern-table nil)
  )


;;;; org-latex + tab behavior
(after! org
  ;; if <s tab doesn't work
  (require 'org-tempo)
  (setq org-image-actual-width t)
  ;; visual-mode tab binds back to org-cycle
  (remove-hook 'org-tab-first-hook #'+org-yas-expand-maybe-h)
  ;; insert-mode tab binds back to org-cycle
  (remove-hook 'org-tab-first-hook #'+org-indent-maybe-h)
;; adjust background colors of org-latex fragments
;; call it manually!
;; (add-hook! 'org-mode-hook #'my/org-latex-set-directory-name-to-background)
;; (add-hook! 'doom-load-theme-hook #'my/org-latex-set-directory-name-to-background)

;; TODO: to resolve fontification error in copilot buffer
;; (setq org-highlight-latex-and-related '(native script entities))
(setq org-highlight-latex-and-related '(latex script entities))

(setq org-format-latex-options
      (plist-put org-format-latex-options :background
                 ;; "Transparent"
                 'default             ; work better with dvipng
                 ))
(add-to-list 'org-src-block-faces '("latex" (:inherit default :extend t)))
;; (setq org-src-block-faces '("latex" (:inherit default :extend t)))

;; cdlatex will ignore inline math $...$
;; (plist-put org-format-latex-options :matchers '("begin" "$1" "$" "$$" "\\(" "\\[")) ;; drop "$"

(setq org-preview-latex-image-directory "ltximg/"
      ;; org-archive-location ".archive/%s::"
      )

  (defvar jyun/org-latex-preview-scale 1.5
    "A scaling factor for the size of images created from LaTeX fragments.")
  (defun jyun/org-latex-set-options (&optional scale-input)
    "Set `org-latex-fragment' scale. `jyun/org-latex-preview-scale' is used as scale if none is provided as `scale-input' argument"
    (let ((scale (if scale-input scale-input jyun/org-latex-preview-scale)))
      (plist-put org-format-latex-options :scale scale)))

  ;; set default org-latex-preview size
  (jyun/org-latex-set-options 1.5))

;;;; org-latex-frag
;; TODO: move org-present scaling
;; BUG: error when (writeroom-mode 1)
;; (defadvice! +org-latex-preview-scale-a (img)
;;   "Make org latex preview respect `image-scaling-factor'."
;;   :filter-return #'org--make-preview-overlay
;;   (plist-put (cdr img) :scale (/ (image-compute-scaling-factor image-scaling-factor) 1.25)))
;; (setq-hook! 'text-scale-mode-hook
;;   image-scaling-factor (math-pow text-scale-mode-step text-scale-mode-amount))

;;;; org-pretty
;; align tables containing variable-pitch font, CJK characters and images
;; (add-hook 'org-mode-hook #'valign-mode)

;; (use-package! org-pretty-table
;;   :commands (org-pretty-table-mode global-org-pretty-table-mode))

;; (evil-set-initial-state 'org-agenda-mode 'emacs)

;;;; ox
(setq org-latex-tables-booktabs nil
      org-beamer-theme "[progressbar=foot]metropolis"
      ;; org-beamer-theme "default"
      org-beamer-frame-level 4
      org-latex-tables-booktabs nil)
;; ;; Github flavored markdown exporter
;; (use-package! ox-gfm :after ox)

;; (after! org
;;   (setq org-export-with-sub-superscripts nil ))

;;;; ox-hugo
(after! ox-hugo
  (setq org-hugo-auto-set-lastmod t)
  (add-to-list 'org-hugo-external-file-extensions-allowed-for-copying "csv"))

;;;; org-noter
(when (modulep! :lang org +noter)
  (after! org-noter
    ;; (org-noter-doc-split-fraction '(0.57 0.43))
    (setq org-noter-always-create-frame t
          org-noter-auto-save-last-location t)
    (defun org-noter-init-pdf-view ()
      (progn
        (pdf-view-fit-width-to-window)
        (pdf-view-auto-slice-minor-mode)))
    ;; (add-hook 'pdf-view-mode-hook 'org-noter-init-pdf-view)
    )
  )

;;;; org-gcal
;; (require 'password-store)
;; org-gcal credintial after init
;;(add-hook! 'after-init-hook #'jyun/get-org-gcal-credential)
(setq! org-gcal-cancelled-todo-keyword "KILL"
       org-gcal-auto-archive nil)

;; if something goes wrong, try delete the token and run `org-gcal-request-token'.
;; (progn
;; (delete-file org-gcal-token-file)
;; (org-gcal-request-token))

;;; misc
;; diable hi-line-mode in rainbow-mode
(add-hook! 'rainbow-mode-hook
  (hl-line-mode (if rainbow-mode -1 +1)))

;; BUG: evil-mc cursors cannot change to evil-insert using "i".
;; (setq outshine-use-speed-commands nil)
;; (outshine-speed-command-help)

(setq pdf-misc-print-program "lpr"
      pdf-misc-print-program-args nil)
(setq search-highlight t
      search-whitespace-regexp ".*?")
(setq omnisharp-server-executable-path "/opt/homebrew/bin/omnisharp"
      ;; doom-scratch-intial-major-mode 'lisp-interaction-mode
      )

;; no need: gcmh: https://github.com/emacsmirror/gcmh
;; (add-hook 'focus-out-hook #'garbage-collect)
(setq garbage-collection-messages nil)

;; set korean keyboard layout
;; C-\ to switch input-method
(setq default-input-method "korean-hangul390")

;; emacs-mode shift can be used for C-SPC
;; (setq shift-select-mode t)
;; replace highlighted text with what I type
;; (delete-selection-mode 1)

;;;; modifier and mouse
(when IS-MAC
  ;; NOTE: KARABINER
  ;; caps_lock: esc if alone, right_ctrl if hold_down
  ;; return: return if alone, right_ctrl if hold_down
  (setq mac-right-option-modifier 'meta)
  (setq mac-right-control-modifier 'hyper) ;C-s-a and C-s-' are mapped to right-ctrl by karabiner
  ;; (setq mac-function-modifier 'hyper)  ; make Fn key do Hyper
  (setq mac-mouse-wheel-smooth-scroll t))

;; ;;;; Hangout
;; (use-package! jabber
;;   :commands (jabber-connect-all
;;              jabber-connect)
;;   :init
;;   (add-hook 'jabber-post-connect-hooks 'spacemacs/jabber-connect-hook)
;;   :config
;;   ;; https://www.masteringemacs.org/article/keeping-secrets-in-emacs-gnupg-auth-sources
;;   ;; password encrypted in ~/doom-emacs/.local/etc/authinfo.gpg
;;   ;; machine gmail.com login jonghyun.yun port xmpp password *******
;;   ;; or I can use =pass=
;;   ;; see https://github.com/DamienCassou/auth-source-pass
;;   ;; pass insert jonghyun.yun@gmail.com:xmpp
;;   (setq jabber-account-list '(("jonghyun.yun@gmail.com"
;;                                (:network-server . "talk.google.com")
;;                                (:connection-type . starttls))))

;;   ;; (jabber-connect-all)
;;   ;; (jabber-keepalive-start)
;;   (evil-set-initial-state 'jabber-chat-mode 'insert))

;;;; disable warnings
(after! warnings
  (add-to-list 'warning-suppress-types '(yasnippet backquote-change))
  (add-to-list 'warning-suppress-types
               ;;   '(undo discard-info)
               '(undo)))

;; ;;;; projectile
;; ;;;; (unless IS-LINUX
;; ;;;;   (after! projectile
;; ;;;;     (projectile-add-known-project "/Users/yunj/Dropbox/emacs/.doom.d/")
;; ;;;;     (projectile-add-known-project "/Users/yunj/Dropbox/workspace/swap/")
;; ;;;;     (projectile-add-known-project "/Users/yunj/OneDrive/workspace/python-tutorial/HarvardX-Using_Python_for_Research/")
;; ;;;;     ;; (projectile-add-known-project "~/Dropbox/research/hnet-irt")
;; ;;;;     ;; (projectile-add-known-project "~/Dropbox/research/hnet-irt/GEPS")
;; ;;;;     (projectile-add-known-project "/Users/yunj/Dropbox/research/lsjm-art/lsjm-draft/")
;; ;;;;     ;; (projectile-add-known-project "~/Dropbox/research/lsjm-art")
;; ;;;;     ;; (projectile-add-known-project "~/Dropbox/utsw-projects/HITS-CLIP")
;; ;;;;     ;; (projectile-add-known-project "~/OneDrive/research/lapf")
;; ;;;;     ;; (projectile-add-known-project "~/research/s.ham/RAS")
;; ;;;;     ;; (projectile-add-known-project "~/research/mj.jeon")
;; ;;;;     ))

;;;; riksy local variables
;; old tricks stopped working. risky variables are ignored (doom updates)
;; instead I can safely eval risky variables...
(setq enable-local-eval t)
;; (add-to-list 'safe-local-eval-forms
;;              '(add-hook 'projectile-after-switch-project-hook (lambda () (jyun/magit-pull-overleaf overleaf-directory))))
;; (add-to-list 'safe-local-eval-forms '(add-hook 'after-save-hook (lambda () (jyun/magit-push-overleaf overleaf-directory))))
;; (add-to-list 'safe-local-eval-forms '(setq overleaf-directory (ffip-project-root)))

;; (setq safe-local-eval-forms
;;       (append safe-local-eval-forms
;;               '((setq overleaf-directory (ffip-project-root))
;;                 (add-hook 'projectile-after-switch-project-hook (lambda () (jyun/magit-pull-overleaf overleaf-directory)))
;;                 (add-hook 'after-save-hook (lambda () (jyun/magit-push-overleaf overleaf-directory)))
;;                 )))

;;;; time + modeline
(setq display-time-24hr-format t
      mouse-autoselect-window nil
      ;; indicate-unused-lines nil
      ;; spacemacs value of parameters
      scroll-conservatively 0)
(setq display-time-format ;; "%R %a %b %d"
      "%a %m/%d %R"
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

;;;; alert
(with-eval-after-load 'alert
  ;; calendar notification
  ;; (setq alert-default-style 'osx-notifier)
  (setq alert-default-style 'notifier))

;;;; maximize frame at startup
;; (unless IS-LINUX
;;   (add-to-list 'initial-frame-alist '(fullscreen . maximized)))

;; OS X native full screen
;; (add-to-list 'initial-frame-alist '(fullscreen . fullscreen))

;; prevent some cases of Emacs flickering
;; (add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

;;; Backups & Autosave
;; (auto-save-visited-mode +1)
(setq auto-save-default t
      create-lockfiles t
      make-backup-files nil
      ;; truncate-string-ellipsis "…"
      yas-triggers-in-field t           ; snippets inside snippets. some need this
      )
;; (setq save-place-forget-unreadable-files t) ;; emacs is slow to exit after enabling saveplace

;; Delete duplicated entries in autosaves of minibuffer history
;; (setq history-delete-duplicates t)

;;; recentf
(setq recentf-exclude '("recentf_.*$"
                        ;; ".*/elpa/.*"
                        ".*\\.maildir.*"
                        "/var/folders/.*"
                        ".*company-statistics.*"
                        ".*Cellar.*"
                        ".*\\.orhc-bibtex-cache"))

;;; reference
;;;; biblio
(setq! +biblio-pdf-library-dir "~/Zotero/storage/"
       +biblio-default-bibliography-files '("~/Zotero/myref.bib")
       ;; a single file for one long note / directory for many note files
       +biblio-notes-path "~/org/roam/refnotes.org"
       ;; +biblio-notes-path "~/org/roam/"
       org-ref-csl-default-style "chicago-author-date.csl"
       org-cite-csl-styles-dir "~/Zotero/styles/"
       org-cite-csl-locales-dir "~/Zotero/locales/"
       )

(when (modulep! :tools biblio)
  (after! org-ref
    (setq org-ref-insert-cite-function
          (lambda ()
	    (org-cite-insert nil)))))

(after! citar
  ;; list of paths
  (setq! citar-bibliography +biblio-default-bibliography-files
         citar-notes-paths (list org-roam-directory)
         citar-library-paths (list +biblio-pdf-library-dir)
         )
  (when (modulep! :lang org +roam2)
    (add-to-list 'org-roam-capture-templates
                 '("n" "literature note" plain
                   "%?"
                   :target
                   (file+head
                    "${citekey}.org"
                    "#+title: ${title}\n
                  \n* Notes\n  :PROPERTIES:\n  :NOTER_DOCUMENT: %(replace-home-to-tilde (car (bibtex-completion-find-pdf \"${citekey}\")))\n  :END:\n\n")
                   :unnarrowed t))
    (setq citar-org-roam-capture-template-key "n"))
  )

;;; org-roam
(after! org-roam
  (setq org-roam-graph-viewer "/Applications/Firefox.app/Contents/MacOS/firefox-bin"
        +org-roam-open-buffer-on-find-file nil)
  ;; (setq org-roam-dailies-capture-templates
  ;;       '(("d" "default" entry
  ;;          #'org-roam-capture--get-point
  ;;          "* %?"
  ;;          :file-name "daily/%<%Y-%m-%d_%A>"
  ;;          :head "#+TITLE: %<%Y-%m-%d %A>\n\n[[roam:%<%Y-%m %B>]]\n\n")))
  ;; the below bind `spare-keymap'. However, it cannot override default doom's binding
  ;; (map! :leader "nrd" #'org-roam-dailies-map)
  (setq org-roam-graph-executable
        ;; "circo"
        ;; "neato"
        ;; "twopi"
        "fdp"                           ; best for a large graph
        ;; "sfdp"
        ;; "patchwork"
        ;; "osage"
        )
  )

;;;; org-roam-ui
;;(use-package! websocket
;;    :after org-roam
;;    )

(when (modulep! :app rss)
  (load! "local/elfeed-plus")
)

;;; search
;;;; online lookup
(when (modulep! :tools lookup)
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
                  ("Weather"              "https://wttr.in/%s")
                  )))
  )

;;;; deft
(when (modulep! :ui deft)
  (setq ;; deft-extensions '("org" "md" "txt")
   deft-strip-summary-regexp
   (concat "\\("
           "[\n\t]" ;; blank
           "\\|^#\\+[[:upper:]_]+:.*$" ;; org-mode metadata
           "\\|^# #\\+[[:upper:]_]+:.*$" ;; commented org-mode metadata
           "\\|:PROPERTIES:\n\\(.+\n\\)+:END:\n" ;; proprety
           "\\)")
   deft-use-filename-as-title t
   deft-directory "~/org"
   ;; include subdirectories
   deft-recursive t)
  )

;;;; regexp
(use-package! visual-regexp
  :commands (vr/replace vr/query-replace)
  :init
  ;; (define-key global-map (kbd "C-c r") 'vr/replace)
  (define-key global-map (kbd "C-c q") 'vr/query-replace)
  ;; :bind*
  ;; (([remap query-replace-regexp] . vr/query-replace))
  ;; if you use multiple-cursors, this is for you:
  ;; (define-key global-map (kbd "C-c m") 'vr/mc-mark)
  ;; to use visual-regexp-steroids's isearch instead of the built-in regexp isearch, also include the following lines:
  ;; (define-key esc-map (kbd "C-r") 'vr/isearch-backward) ;; C-M-r
  ;; (define-key esc-map (kbd "C-s") 'vr/isearch-forward) ;; C-M-s)
  :config
  (require 'visual-regexp-steroids)
  )

;;; visual, ui, window mangement
;; Switch to the new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)
;; replace it to update all cursor colors
;; (remove-hook 'doom-load-theme-hook '+evil-update-cursor-color-h)

;; overide the cursor color hook
;; (defun +evil-update-cursor-color-h ()
;;   (jyun/evil-state-cursors))

;;; coding + lsp-mode
;; disable flycheck by default
;; (remove-hook 'doom-first-buffer-hook #'global-flycheck-mode)

;; line-number
(add-hook 'prog-mode-hook (lambda () (setq-local display-line-numbers t)))

;; ibuffer and R buffers need to be manually added
(advice-add 'ibuffer :around #'jyun/persp-add-buffer)
(advice-add 'R :around #'jyun/persp-add-buffer)
;; (advice-add 'jupyter-run-repl :around #'jyun/persp-add-buffer)

;;;; python
(setq ein:jupyter-default-kernel "ds")
(setq python-shell-interpreter "ipython"
      ;; python-shell-interpreter-args "--simple-prompt"
      python-shell-interpreter-args "-i")
;; (setq python-shell-interpreter "jupyter"
;;       python-shell-interpreter-args "console --simple-prompt"
;;       python-shell-prompt-detect-failure-warning nil)


(with-eval-after-load 'conda
  (setq conda-executable "mamba"))

(after! python
  (setq conda-env-home-directory (expand-file-name "~/.conda"))
  ;; (setq conda-env-home-directory '((expand-file-name "~/.local/share/mamba") (expand-file-name "~/.conda")))
  ;;(conda-env-activate "kedro")
  (add-to-list 'python-shell-completion-native-disabled-interpreters
               "jupyter")
  (add-to-list 'python-shell-completion-native-disabled-interpreters
               "python"))
(setq lsp-pyright-python-executable-cmd "python")
(setq dap-python-executable lsp-pyright-python-executable-cmd)

;;;; lsp
;; ccls takes too much resources
(setq lsp-disabled-clients '((python-mode . pyls)
                             (c-mode . ccls)
                             (c++-mode . ccls)))
(setq lsp-clangd-binary-path "/usr/local/opt/llvm/bin/clangd")

;; (setq
;;    ;; lsp-ui-peek-mode nil ;; buggy if t before starting lsp
;;    ;; lsp-ui-sideline-show-hover nil
;;    ;; lsp-ui-doc-show-with-cursor       nil
;;    ;; lsp-ui-sideline-show-code-actions t
;;  )

(after! lsp-mode
  (setq
   lsp-headerline-breadcrumb-enable nil ;; expensive for large project 
   lsp-ui-doc-show-with-mouse t))

;;;; matlab
(after! all-the-icons
  (setcdr (assoc "m" all-the-icons-extension-icon-alist)
          (cdr (assoc "matlab" all-the-icons-extension-icon-alist))))

(use-package! matlab-mode
  :commands (matlab-shell)
  :mode ("\\.m\\'" . matlab-mode)
  :config
  (setq matlab-return-add-semicolon t
        matlab-shell-ask-MATLAB-for-completions t
        matlab-shell-command-switches '("-nodesktop" "-nosplash"))

  ;; ;; set column for matlab m file buffer
  ;; (add-hook 'matlab-mode-hook
  ;;           #'(lambda ()
  ;;             (set-fill-column 100)))

  ;; :bind (:map matlab-mode-map
  ;;        ;; ("C-c C-l" . matlab-shell-run-line)
  ;;        ;; ("C-M-x" . matlab-shell-run-region-or-paragraph-and-step)
  ;;        ;; ("C-c C-n" . matlab-shell-run-line-and-step)
  ;;        ;; ("C-c C-z" . matlab-show-matlab-shell-buffer)
  ;;        )
  )

;;;; git
(use-package! git-link
  :commands
  (git-link git-link-commit git-link-homepage)
  :custom
  (git-link-use-commit t)
  (git-link-open-in-browser t))

;;;; plantuml
;; jar configuration needs for math typesetting.
;; version is pinned (brew pin plantuml)
(after! plantuml-mode
  (setq plantuml-default-exec-mode 'jar
        org-plantuml-jar-path plantuml-jar-path)
  (when IS-LINUX
    (setq plantuml-jar-path "/usr/share/plantuml/plantuml.jar"))
  (when IS-MAC
    (setq plantuml-jar-path "/opt/homebrew/Cellar/plantuml/1.2022.14/libexec/plantuml.jar"))
  )

;;;; graphviz
(use-package! graphviz-dot-mode
  :commands graphviz-dot-mode
  :mode ("\\.dot\\'" "\\.gz\\'")
  :init
  (after! org
    (setcdr (assoc "dot" org-src-lang-modes)
            'graphviz-dot)))

(use-package! company-graphviz-dot
  :after graphviz-dot-mode)

;;; writing
(use-package! lorem-ipsum
  :commands (lorem-ipsum-insert-paragraphs
             lorem-ipsum-insert-sentences
             lorem-ipsum-insert-list))

;;; evil
(setq ;; evil-ex-substitute-global t     ; I like my s/../.. to by global by default
 evil-move-cursor-back nil       ; Don't move the block cursor when toggling insert mode
 ;; evil-kill-on-visual-paste nil
 )
                                        ; Don't put overwritten text in the kill ring

;; no key stroke for exiting INSERT mode: doom default jk
(setq evil-escape-key-sequence (kbd "jk")
      evil-escape-delay 0.15)

(when (require 'key-chord nil t)
  ;; to escape from emacs state
  (key-chord-mode 1)
  (key-chord-define evil-emacs-state-map evil-escape-key-sequence 'evil-escape)
  (key-chord-define evil-insert-state-map evil-escape-key-sequence 'evil-escape)
  )

;;;; no evil-snipe
(after! evil-snipe
  (pushnew! evil-snipe-disabled-modes 'ibuffer-mode 'dired-mode)
  (pushnew! evil-snipe-disabled-modes 'wordnut-mode 'osx-dictionary-mode)
  (pushnew! evil-snipe-disabled-modes 'deadgrep-mode)
  ;; (pushnew! evil-snipe-disabled-modes 'reftex-select-label-mode 'reftex-select-bib-mode)
  )

;;; convenience
;;;; which-key
(with-eval-after-load 'which-key
  ;; Allow C-h to trigger which-key before it is done automatically
  ;; (setq which-key-show-early-on-C-h t)
  ;; make sure which-key doesn't show normally but refreshes quickly after it is
  ;; triggered.
  (setq which-key-idle-delay 1) ;; with 800kb garbage-collection
  ;; (setq which-key-idle-secondary-delay 0.05)
  ;; (define-key which-key-mode-map (kbd "C-h") 'which-key-C-h-dispatch)
  ;; (setq which-key-allow-multiple-replacements t)
  (pushnew!
   which-key-replacement-alist
   '(("" . "\\`+?evil[-:\\/]?\\(?:a-\\)?\\(.*\\)") . (nil . "◂\\1"))
   '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . "◃\\1")))
  ;; why I want this??
  ;; (setq which-key-replacement-alist nil)
  )

;;;;  ctrlf
(use-package! ctrlf
  :hook
  (after-init . ctrlf-mode)
  :bind
  ;; "M-s ." is overrided in normal mode
  ("C-s-s" . ctrlf-forward-symbol-at-point))
;; C-M-r  ctrlf-backward-alternate
;; C-M-s  ctrlf-forward-alternate
;; C-r    ctrlf-backward-default
;; C-s    ctrlf-forward-default
;; M-s .  ctrlf-forward-symbol-at-point
;; M-s _  ctrlf-forward-symbol


;;;; deadgrep
(use-package! deadgrep
  :commands (deadgrep)
  :config
  (map!
   (:map deadgrep-mode-map
    :n "d" #'deadgrep-directory
    :n "s" #'deadgrep-search-term
    :n "gr" #'deadgrep-restart
    :g "C-c C-q" #'deadgrep-kill-all-buffers)
   (:map deadgrep-edit-mode-map
    :g "C-c C-c" #'deadgrep-mode
    :g "C-c C-k" (cmd! (kill-buffer (current-buffer))))))

;;;;  easy-kill
;; https://github.com/leoliu/easy-kill
(use-package! easy-kill
  :bind*
  (([remap kill-ring-save] . easy-kill) ; M-w
   ([remap mark-sexp] . easy-mark))     ; C-M-S @
  :config
  ;; point > mark will place point to beginning-of-mark
  (easy-kill-defun easy-kill-mark-region ()
                   (interactive)
                   (pcase (easy-kill-get bounds)
                     (`(,_x . ,_x)
                      (easy-kill-echo "Empty region"))
                     (`(,beg . ,end)
                      (pcase (if (eq (easy-kill-get mark) 'end)
                                 (list end beg) (list beg end))
                        (`(,m ,pt)
                         (set-mark pt)
                         (goto-char m)))
                      (activate-mark)))))
;; M-w w: save word at point
;; M-w s: save sexp at point
;; M-w l: save list at point (enclosing sexp)
;; M-w d: save defun at point
;; M-w D: save current defun name
;; M-w f: save file at point
;; M-w b: save buffer-file-name or default-directory.
;; - changes the kill to the directory name, + to full name and 0 to basename.
;; C-SPC: turn selection into an active region

;;;;  avy
;; (setq avy-keys '(?a ?s ?d ?f ?j ?k ?l ?\;))
;; home row priorities: 8 6 4 5 - - 1 2 3 7
(setq avy-keys '(?n ?e ?j ?s ?t ?r ?l ?a)
      lispy-avy-keys avy-keys)

;;(load! "local/posframe-plus")

;;;; abbrev
(use-package! abbrev
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

(when (modulep! :ui treemac)
  (load! "local/treemac-plus")
)

;;;; dap-mode
;; rigger the hydra when the program hits a breakpoint
(add-hook 'dap-stopped-hook
          (lambda (arg) (call-interactively #'dap-hydra)))

 ;;;; org
(defadvice! shut-up-org-problematic-hooks (orig-fn &rest args)
  :around #'org-fancy-priorities-mode
  :around #'org-superstar-mode
  (ignore-errors (apply orig-fn args)))

;; eshell
;; aliases: see `+eshell-aliases'
(set-eshell-alias! "up" "eshell-up $1"
                   "pk" "eshell-up-peek $1")

;;; minibuffer
(defun switch-to-minibuffer ()
  "Switch to minibuffer window."
  (interactive)
  (if (active-minibuffer-window)
      (select-window (active-minibuffer-window))
    (error "Minibuffer is not active")))
(global-set-key "\C-co" 'switch-to-minibuffer) ;; Bind to `C-c o'

(when (modulep! :lang org +roam2)
  ;; include roam files with roadmap filetag
  (load! "local/org-roam-dw")
  )

;;; clean local elc
(defun jyun/clean-and-rebuild-local-packages ()
  (interactive)
  (let* ((pkg-list '("scimax" "doom-snippets" "langtool-posframe" "emacs-overleaf" "org-cv"))
  ;(let* ((pkg-list '("doom-snippets" "langtool-posframe" "emacs-overleaf" "org-cv"))
         (build-dir (concat doom-local-dir "straight/build-29.1/")))
    (when (y-or-n-p "Do you want delete local package builds?")
      (dolist (pkg pkg-list)
        (delete-directory (concat build-dir pkg) t t)))
    (when (y-or-n-p "Do you want rebuild local packages?")
      (start-process "doom-sync" "*doom-sync" "doom" "sync")
      (set-process-sentinel (get-process "doom-sync") 'msg-me))))

;;; dired
(unless IS-LINUX
  (after! dired
    ;; block size 900kb = same as default
    (setf (alist-get "\\.tar\\.bz2\\'" dired-compress-files-alist nil nil #'equal) "tar -cf - %i | pbzip2 -c9 > %o")
    ;; level 9 compression
    (push  '("\\.tar\\.lz\\'" .  "tar -cf - %i | plzip -9c > %o") dired-compress-files-alist)))

;;; dired "J"
;; replace `dired-goto-file' with equivalent helm and ivy functions:
;; `helm-find-files' fuzzy matching and other features
;; `counsel-find-file' more `M-o' actions
(with-eval-after-load 'dired
  (evil-define-key 'normal dired-mode-map "J"
    (cond ((modulep! :completion helm) 'helm-find-files)
          ((modulep! :completion ivy) 'counsel-find-file)
          (t 'find-file))))

;;; OS X ls not working with --quoting-style=literal
(after! fd-dired
  (when IS-MAC
    (setq fd-dired-ls-option '("| xargs -0 gls -ld --quoting-style=literal" . "-ld"))))
;; display icons with colors
;; (setq all-the-icons-dired-monochrome nil)

;;; emacs-everywhere
(setq emacs-everywhere-frame-parameters
  `((name . "emacs-everywhere")
    (width . 80)
    (height . 24)))
;; export to markdown when closing the frame
;; (setq emacs-everywhere-major-mode-function #'org-mode)

;;; remove ^M
(defun delete-carrage-returns ()
  (interactive)
  (save-excursion
    (goto-char 0)
    (while (search-forward "\r" nil :noerror)
      (replace-match ""))))

;;; initial evil state
(evil-set-initial-state 'sql-interactive-mode 'insert)
(evil-set-initial-state 'jupyter-repl-mode 'insert)

;;; mathpix
(defun jyun/mathpix-screenshot (&optional arg)
  "Mathpix in math env. C-u: display math, C-u C-u: inline math"
  (interactive "P")
  (cond ((equal arg '(4)) (progn (insert "\n\\[\n") (mathpix-screenshot) (insert "\n\\]\n")))
        ((equal arg '(16)) (progn (insert "\\(") (mathpix-screenshot) (insert "\\)")))
        (t (mathpix-screenshot))))

;;; scala
;; https://ag91.github.io/blog/2020/10/16/my-emacs-setup-for-scala-development/
(when (modulep! :lang scala)
  (use-package ob-ammonite!
    ;; :ensure-system-package (amm . "sudo sh -c '(echo \"#!/usr/bin/env sh\" && curl -L https://github.com/lihaoyi/Ammonite/releases/download/2.0.4/2.13-2.0.4) > /usr/local/bin/amm && chmod +x /usr/local/bin/amm' && amm")
    :defer t
    :when (modulep! :lang scala)
    :config
    (require 'ammonite-term-repl)
    )

  (use-package ammonite-term-repl
    :defer t
    :when (modulep! :lang scala)
    :config
    (setq ammonite-term-repl-auto-detect-predef-file nil
          ammonite-term-repl-program-args '("--no-default-predef" "--no-home-predef")))

  (use-package! ob-scala
    :when (modulep! :lang scala)
    ;; :after org
    :after scala-mode)
  )

;;; spell-fu
(when (modulep! :checkers spell)
  ;; (require 'spell-fu nil 'noerror) ;; otherwise error b/c `+spell/previous-error' is not defined.
  (add-hook! 'org-mode-hook (lambda () (setq spell-fu-mode -1)))
  (remove-hook 'text-mode-hook #'spell-fu-mode)
  )

(when (modulep! :lang org +jupyter)
  ;; (setq ob-async-no-async-languages-alist '("jupyter-python"))
  (eval-after-load "jupyter-client"
    ;; (map! :map org-src-mode-map
    ;;       "C-c C-c" #'org-edit-src-exit)
    (map! :map jupyter-repl-interaction-mode-map
          "C-c C-c" nil)
    )
  (setq jupyter-repl-echo-eval-p t)

  ;;; ox-ipynb
  ;; (after! org
  ;;   (require 'ox-ipynb)
  ;;   ;; conflict with +org-redisplay-inline-images-in-babel-result-h
  ;;   (advice-remove 'org-display-inline-images 'font-lock-fontify-buffer)
  ;;   )

  (defun jupyter-org-font-lock-ansi-escapes (limit)
    (let ((case-fold-search t))
      (when (re-search-forward
             "^[ \t]*\\(#\\+begin_example[ \t]*\\|: .*\\)$" limit t)
        (let ((beg (match-beginning 1))
              (beg1 (line-beginning-position 2))
              end)
          (cond
           ;; example block
           ((not (eq (char-after beg) ?:))
            (when (re-search-forward
                   "^[ \t]*#\\+end_example\\>.*"
                   nil t) ;; on purpose, we look further than LIMIT
              (setq end (min (point-max) (1- (match-beginning 0))))
              (jupyter-org--ansi-color-apply-on-region beg1 end)))
           ;; fixed width
           (t
            (setq end (or (and (re-search-forward "^[ \t]*[^ \t:]" nil t)
                               (1- (match-beginning 0)))
                          (point-max)))
            (jupyter-org--ansi-color-apply-on-region beg end)))))))

  (defun org-babel-jupyter-handle-result-ansi-escapes ()
    "Handle ANSI escapes in Jupyter src-block result."
    (org-babel-map-src-blocks nil
      (save-excursion
        (when-let ((beg (org-babel-where-is-src-block-result))
                   (end (progn (goto-char beg) (forward-line) (org-babel-result-end))))
          (ansi-color-apply-on-region beg end)))))
  (add-hook 'org-babel-after-execute-hook #'org-babel-jupyter-handle-result-ansi-escapes)
  )

;;; appearance: pulsar, lin
;; (load! "local/protesilaos")

 ;;; window split
(defun jyun/resize-window-legal-pdf ()
  "resize a selected window to fit a legal size pdf file."
  (interactive)
  (doom-resize-window nil 62)
  (doom-resize-window nil 90 t)
  )

;;; spacemacs window split
(load! "local/spacemacs-window-split")

;; ace-window + embark
(load! "local/ace-window")

;;; fit window to pdf
(defvar fit-window-to-pdf-p nil)
(defun jyun/fit-window-to-pdf ()
  (interactive)
  (fit-window-to-buffer))
(defun jyun/toggle-fit-window-to-pdf ()
  (interactive)
  (if (not fit-window-to-pdf-p)
      (progn
        (jyun/fit-window-to-pdf)
        (pdf-view-redisplay t)
        (add-hook 'pdf-view-after-change-page-hook #'jyun/fit-window-to-pdf)
        (setq fit-window-to-pdf-p t))
    (progn
      (remove-hook 'pdf-view-after-change-page-hook #'jyun/fit-window-to-pdf)
      (setq fit-window-to-pdf-p nil))
    )
  )

;; (use-package! mu4e
;;   :load-path  "/usr/local/share/emacs/site-lisp/mu/mu4e"
;;   :config
;;   (add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu/mu4e")
;;   )

;;; cypher - Neo4j
;; (use-package! cypher-mode)

;;; WSL functions
(defun wsl-open-exploer ()
  (interactive)
  (shell-command "explorer.exe .")
  )

;; we recommend using use-package to organize your init.el
(use-package! codeium
  ;; if you use straight
  ;; :straight '(:type git :host github :repo "Exafunction/codeium.el")
  ;; otherwise, make sure that the codeium.el file is on load-path

  :init
  ;; use globally
  ;; (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)
  ;; or on a hook
  (defun jyun/setup-company-for-codeium ()
    (setq-local company-idle-delay 0.5
                company-minimum-prefix-length 0
                ;; corfu-auto-prefix 0
                ;; corfu-auto-delay 0.5
                )
    (setq-local completion-at-point-functions '(codeium-completion-at-point)))
  (add-hook 'python-mode-hook #'jyun/setup-company-for-codeium)
  (add-hook 'java-mode-hook #'jyun/setup-company-for-codeium)
  (add-hook 'sql-mode-hook #'jyun/setup-company-for-codeium)
  (add-hook 'prog-mode-hook #'jyun/setup-company-for-codeium)

  ;; if you want multiple completion backends, use cape (https://github.com/minad/cape):
  ;; (add-hook 'python-mode-hook
  ;;     (lambda ()
  ;;         (setq-local completion-at-point-functions
  ;;             (list (cape-super-capf #'codeium-completion-at-point #'lsp-completion-at-point)))))
  ;; an async company-backend is coming soon!

  ;; codeium-completion-at-point is autoloaded, but you can
  ;; optionally set a timer, which might speed up things as the
  ;; codeium local language server takes ~0.2s to start up
  ;; (add-hook 'emacs-startup-hook
  ;;  (lambda () (run-with-timer 0.1 nil #'codeium-init)))

  ;; :defer t ;; lazy loading, if you want
  :config
  (setq use-dialog-box nil) ;; do not use popup boxes

  ;; if you don't want to use customize to save the api-key
  ;; (setq codeium/metadata/api_key "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")

  ;; get codeium status in the modeline
  (setq codeium-mode-line-enable
        (lambda (api) (not (memq api '(CancelRequest Heartbeat AcceptCompletion)))))
  (add-to-list 'mode-line-format '(:eval (car-safe codeium-mode-line)) t)
  ;; alternatively for a more extensive mode-line
  ;; (add-to-list 'mode-line-format '(-50 "" codeium-mode-line) t)

  ;; use M-x codeium-diagnose to see apis/fields that would be sent to the local language server
  (setq codeium-api-enabled
        (lambda (api)
          (memq api '(GetCompletions Heartbeat CancelRequest GetAuthToken RegisterUser auth-redirect AcceptCompletion))))
  ;; you can also set a config for a single buffer like this:
  ;; (add-hook 'python-mode-hook
  ;;     (lambda ()
  ;;         (setq-local codeium/editor_options/tab_size 4)))

  ;; You can overwrite all the codeium configs!
  ;; for example, we recommend limiting the string sent to codeium for better performance
  (defun my-codeium/document/text ()
    (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (min (+ (point) 1000) (point-max))))
  ;; if you change the text, you should also change the cursor_offset
  ;; warning: this is measured by UTF-8 encoded bytes
  (defun my-codeium/document/cursor_offset ()
    (codeium-utf8-byte-length
     (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (point))))
  (setq codeium/document/text 'my-codeium/document/text)
  (setq codeium/document/cursor_offset 'my-codeium/document/cursor_offset))

;;; java
(setq lsp-java-import-gradle-java-home "/Library/Java/JavaVirtualMachines/openjdk-8.jdk/Contents/Home/")

;; ;;; https://github.com/doomemacs/doomemacs/issues/7438
;; ;; HACK: since some upstream changes, formatting a specific region seems broken, and
;; ;; calling `+format/region' raises: "with Symbol’s function definition is void:
;; ;; apheleia--get-formatters", ensure to autoload the required function.
(use-package! apheleia
  :commands (apheleia--get-formatters))

(defun my/format-region (beg end &optional arg)
  (interactive "rP")
  (+format/region beg end arg)
  (ignore-errors
    (tree-sitter--teardown)
    (turn-on-tree-sitter-mode)))

(after! evil
  (map! :map evil-visual-state-map
        ";f" #'my/format-region))

(defun jyun/open-default-directory ()
  (interactive)
  (async-shell-command (concat "open " default-directory) nil nil)
  )

;;; ignore warning
(setq dired-quick-sort-suppress-setup-warning t)


;; TODO: remove repeated config in write module
(use-package! ispell
  :config
  (setq ispell-program-name "hunspell")
  ;; Configure German, Swiss German, and two variants of English.
  (setq ispell-dictionary "en_US")
  ;; For saving words to the personal dictionary, don't infer it from
  ;; the locale, otherwise it would save to ~/.hunspell_de_DE.
  ;; (setq ispell-personal-dictionary "~/.hunspell_personal")
  (setq ispell-personal-dictionary "~/.hunspell_en_US")
  ;; Configure `LANG`, otherwise ispell.el cannot find a 'default
  ;; dictionary' even though multiple dictionaries will be configured
  ;; in next line.
  (setenv "LANG" "en_US.UTF-8")
  ;; ispell-set-spellchecker-params has to be called
  ;; before ispell-hunspell-add-multi-dic will work
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic ispell-dictionary)
  ;; The personal dictionary file has to exist, otherwise hunspell will
  ;; silently not use it.
  (unless (file-exists-p ispell-personal-dictionary)
    (write-region "" nil ispell-personal-dictionary nil 0)
    )
  )

;; brew install --cask trex
(defun jyun/trex-ocr-insert ()
  "Trigger TRex OCR via CLI and insert recognized text."
  (interactive)
  (let ((output (shell-command-to-string "/Applications/TRex.app/Contents/MacOS/cli/trex")))
    (insert output)))
;; (global-set-key (kbd "C-c t") #'jyun/trex-ocr-insert)
(map! :leader
      ;; "i m" #'mathpix-screenshot
      "i t" #'jyun/trex-ocr-insert)

;; need to disply which-key for ]
(after! which-key
        (require 'spell-fu)
)

;; booster
;; sudo xattr -rd com.apple.quarantine ~/bin/emacs-lsp-booster

;;;copilot
;;;accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("M-<tab>" . 'copilot-next-completion)
              ("M-TAB" . 'copilot-next-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word))
  :config
  (setq copilot-max-char 200000)
  (add-to-list 'copilot-indentation-alist '(prog-mode 2))
  (add-to-list 'copilot-indentation-alist '(org-mode 2))
  (add-to-list 'copilot-indentation-alist '(text-mode 2))
  (add-to-list 'copilot-indentation-alist '(closure-mode 2))
  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2))
  )

(after! (evil copilot)
  ;; Define the custom function that either accepts the completion or does the default behavior
  (defun my/copilot-tab-or-default ()
    (interactive)
    (if (and (bound-and-true-p copilot-mode)
             ;; Add any other conditions to check for active copilot suggestions if necessary
             )
        (copilot-accept-completion)
      (evil-insert 1))) ; Default action to insert a tab. Adjust as needed.

  (defun rk/copilot-complete-or-accept ()
  "Command that either triggers a completion or accepts one if one
is available. Useful if you tend to hammer your keys like I do."
  (interactive)
  (if (copilot--overlay-visible)
      (progn
        (copilot-accept-completion)
        (open-line 1)
        (next-line))
    (copilot-complete)))

  ;; Bind the custom function to <tab> in Evil's insert state
  (evil-define-key 'insert 'global (kbd "M-C-<return>") 'rk/copilot-complete-or-accept)
  )

;; noter needs this
(defun replace-home-to-tilde (filename)
  (replace-regexp-in-string (getenv "HOME") "~" filename)
  )

(defun jyun/get-github-token ()
  (string-trim
   (shell-command-to-string
    "pass show github/magit | head -n 1")))
(setenv "GITHUB_PERSONAL_ACCESS_TOKEN" (jyun/get-github-token))

;; gptel
(load! "local/gptel-plus")
;; (load! "local/ado-org")

