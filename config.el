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

(setq doom-font (font-spec :family "JetBrains Mono" :size 20)
      doom-big-font (font-spec :family "JetBrains Mono" :size 30)
      doom-variable-pitch-font (font-spec :family "Overpass" :size 20)
      doom-unicode-font (font-spec :family "JuliaMono" :size 20)
      doom-serif-font (font-spec :family "IBM Plex Mono" :weight 'light :size 20))

(setq variable-pitch-serif-font (font-spec :family "Alegreya" :size 22))
;; (setq variable-pitch-serif-font (font-spec :family "Roboto Slab" :size 24 :weight 'light))
;; (setq variable-pitch-serif-font (font-spec :family "Libre Baskerville" :size 23 :weight 'light))
;; (setq variable-pitch-serif-font (font-spec :family "Libertinus Serif" :size 27 :weight 'light))
;; (setq variable-pitch-serif-font (font-spec :family "Merriweather" :size 24 :weight 'light))

;; missing out on the following Alegreya ligatures:
(set-char-table-range composition-function-table ?f '(["\\(?:ff?[fijlt]\\)" 0 font-shape-gstring]))
(set-char-table-range composition-function-table ?T '(["\\(?:Th\\)" 0 font-shape-gstring]))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one-light)
;; (load-theme 'doom-one-light t)
;; (load-theme 'doom-nord t)
(load-theme 'modus-operandi t)
(unless (display-graphic-p)
  (load-theme 'doom-nord t))
;; (load-theme 'spacemacs-light t)

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

;;; load lisp
(setq load-prefer-newer t)
(load! "local/splash")
(with-eval-after-load 'hydra
  (load! "local/hydra-plus"))
(load! "bindings")

;; https://gist.github.com/d12frosted/a60e8ccb9aceba031af243dff0d19b2e
;; don't add all org-roam files to agenda
;; only those who with TODO keywords, schedule, or deadline
;; run before org-plus
(after! org
  (remove-hook 'org-load-hook #'+org-init-capture-defaults-h)
  (add-to-list 'org-tags-exclude-from-inheritance "roadmap")
  (load! "local/vulpea-agenda/vulpea-agenda")
  )
(load! "local/org-plus")

;; ;; (when (featurep! :ui ligatures +extra)
;; ;;   (load! "local/ligature"))
(load! "local/ess-plus")
(load! "local/latex-plus")

(load! "local/visual-plus")

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
(when (featurep! :email mu4e)
  (load! "local/mu4e-plus"))
(when (featurep! :email notmuch)
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
      (pdf-view-auto-slice-minor-mode)))
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

;;;; reftex
(defface font-roboto-condensed
  '((t (:family "Roboto Condensed")))
  "TODO"
  :group 'basic-faces)
(after! reftex
  (setq reftex-toc-split-windows-horizontally t
        reftex-toc-split-windows-fraction 0.2
        reftex-level-indent 2)
  (add-hook 'reftex-toc-mode-hook (lambda () (variable-pitch-mode 1))))

(setq reftex-ref-style-default-list '("Default"
                                      "Cleveref"
                                      "AMSmath"))
(setq reftex-typekey-to-format-alist '((" " . "~\\ref{%s}")
                                       ("n" . "~\\ref{%s}")
                                       ("f" . "~\\ref{%s}")
                                       ("e" . "~\\eqref{%s}")
                                       ("i" . "~\\ref{%s}")
                                       ("s" . "~\\ref{%s}")
                                       ("t" . "~\\ref{%s}")
                                       ("l" . "~\\ref{%s}")
                                       ("N" . "~\\ref{%s}")))

;;;; cdlatex
;; (after! cdlatex
;;   (setq cdlatex-math-symbol-alist
;;         '((?: ("\\cdots" "\\ldots"))
;;           )
;;         ))

(setq cdlatex-env-alist
      '(("bmatrix" "\\begin{bmatrix}\n?\n\\end{bmatrix}" nil)
        ("equation*" "\\begin{equation*}\n?\n\\end{equation*}" nil)
        ("axiom" "\\begin{axiom}\n?\n\\end{axiom}\n" nil)
        ("proof" "\\begin{proof}\n?\n\\end{proof}\n" nil)
        ("remark" "\\begin{remark}\n?\n\\end{remark}\n" nil)
        ("lemma" "\\begin{lemma}\n?\n\\end{lemma}\n" nil)
        ("verbatim" "\\begin{verbatim}\n?\n\\end{verbatim}\n" nil)
        ("theorem" "\\begin{theorem}\n?\n\\end{theorem}\n" nil)
        ("corollary" "\\begin{corollary}\n?\n\\end{corollary}\n" nil)
        ("exercise" "\\begin{exercise}\n?\n\\end{exercise}\n" nil)
        ("definition" "\\begin{definition}\n?\n\\end{definition}\n" nil)
        ("algorithmic" "\\begin{algorithmic}\n?\n\\end{algorithmic}\n" nil)
        ("split" "\\begin{split}\n?\n\\end{split}\n" nil))
      cdlatex-command-alist
      '(("axm" "Insert axiom env"   "" cdlatex-environment ("axiom") t nil)
        ("thm" "Insert theorem env" "" cdlatex-environment ("theorem") t nil)
        ("spl" "Insert split env" "" cdlatex-environment ("split") t nil)
        ("des" "Insert description env" "" cdlatex-environment ("description") t nil)
        ("lmm" "Insert lemma env" "" cdlatex-environment ("lemma") t nil)
        ("vbt" "Insert verbatim env" "" cdlatex-environment ("verbatim") t nil)
        ("alg" "Insert algorithmic env" "" cdlatex-environment ("algorithmic") t nil)
        ("clr" "Insert corollary env" "" cdlatex-environment ("corollary") t nil)
        ("def" "Insert definition env" "" cdlatex-environment ("definition") t nil)
        ("exc" "Insert exercise env" "" cdlatex-environment ("exercise") t nil)
        ("prf" "Insert proof env" "" cdlatex-environment ("proof") t nil)
        ("rmk" "Insert remark env" "" cdlatex-environment ("remark") t nil))
      cdlatex-math-symbol-alist
      '((?: ("\\cdots" "\\ldots"))
        (?_    ("\\downarrow"  ""           "\\inf"))
        (?2    ("^2"           "\\sqrt{?}"     ""     ))
        (?3    ("^3"           "\\sqrt[3]{?}"  ""     ))
        (?^    ("\\uparrow"    ""           "\\sup"))
        ;;   (?k    ("\\kappa"      ""           "\\ker"))
        ;;   (?m    ("\\mu"         ""           "\\lim"))
        ;;   (?c    (""             "\\circ"     "\\cos"))
        ;;   (?d    ("\\delta"      "\\partial"  "\\dim"))
        ;;   (?D    ("\\Delta"      "\\nabla"    "\\deg"))
        ;;   ;; no idea why \Phi isnt on 'F' in first place, \phi is on 'f'.
        (?F    ("\\Phi"))
        (?V    (""))
        ;;   ;; now just convenience
        ;;   (?.    ("\\cdot" "\\dots"))
        ;;   (?:    ("\\vdots" "\\ddots"))
        ;;   (?*    ("\\times" "\\star" "\\ast"))
        )                             ;
      cdlatex-math-modify-alist
      '((?B    "\\mathbb"        nil          t    nil  nil)
        (?a    "\\abs"           nil          t    nil  nil)))

;;; org-mode
(when (featurep! :lang org +pretty)
  (after! org-superstar
    ;; (remove-hook 'org-mode-hook 'org-superstar-mode) ; manually turn it on!
    (setq org-superstar-headline-bullets-list '("♠" "♡" "♦" "♧")
          org-superstar-remove-leading-stars nil)))
(setq ;; org-src-window-setup 'current-window
 org-src-window-setup 'other-window
 org-return-follows-link t
 org-startup-with-inline-images t
 ;; org-use-speed-commands
 ;; (lambda () (and (looking-at org-outline-regexp) (looking-back "^\\**")))
 ;; nil
 org-log-into-drawer t)
(setq org-ellipsis
;;       ;; " ▾ " ; FiraGo
;;       ;; " ▼ " ; Alegreya Sans
;;       ;; " ⬎ " ; IBM Plex Mono
;;       ;; " ↩ " ; firacode
            " ⤶ " ; juliamono
;;       ;; " ⤵ "
;;       ;; "… "
;;       ;; " ↴ "
;;       ;; " ⤷ "
;;       org-cycle-separator-lines 2     ; -1 or 1 to use unicode org-ellipsis
      )
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

;;;; org-latex + tab behavior
(after! org
  (setq org-image-actual-width 500)
  ;; visual-mode tab binds back to org-cycle
  (remove-hook 'org-tab-first-hook #'+org-yas-expand-maybe-h)
  ;; insert-mode tab binds back to org-cycle
  (remove-hook 'org-tab-first-hook #'+org-indent-maybe-h)
;; adjust background colors of org-latex fragments
;; call it manually!
;; (add-hook! 'org-mode-hook #'my/org-latex-set-directory-name-to-background)
;; (add-hook! 'doom-load-theme-hook #'my/org-latex-set-directory-name-to-background)

(setq org-highlight-latex-and-related '(native script entities))
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
(use-package ox-gfm :after ox)

;;;; ox-hugo
(after! ox-hugo
  (setq org-hugo-auto-set-lastmod t)
  (add-to-list 'org-hugo-external-file-extensions-allowed-for-copying "csv"))

;;;; easy org-clock correction (disableed)
(use-package! org-clock-convenience
  :commands (org-clock-convenience-timestamp-up
             org-clock-convenience-timestamp-down
             org-clock-convenience-fill-gap
             org-clock-convenience-fill-gap-both)
  :init
  (map! (:map org-agenda-mode-map
         "<S-up>" #'org-clock-convenience-timestamp-up
         "<S-down>" #'org-clock-convenience-timestamp-down
         "H-o" #'org-clock-convenience-fill-gap
         "H-e" #'org-clock-convenience-fill-gap-both)))

;;;; ref documents in org
(use-package! org-transclusion
  :commands (org-transclusion-mode)
  :config
  (setq org-transclusion-exclude-elements nil))

;;;; org-noter
(when (featurep! :lang org +noter)
  (after! org-noter
    ;; (org-noter-doc-split-fraction '(0.57 0.43))
    (setq org-noter-always-create-frame t
          org-noter-auto-save-last-location t)
    (defun org-noter-init-pdf-view ()
      (progn
        (pdf-view-fit-width-to-window)
        (pdf-view-auto-slice-minor-mode)))
    (add-hook 'pdf-view-mode-hook 'org-noter-init-pdf-view)))

;;;; org-gcal
;; (require 'password-store)
;; org-gcal credintial after init
(add-hook! 'after-init-hook #'jyun/get-org-gcal-credential)
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
(setq omnisharp-server-executable-path "/usr/local/bin/omnisharp"
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

;;;; Hangout
(use-package! jabber
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

;;;; disable warnings
(after! warnings
  (add-to-list 'warning-suppress-types '(yasnippet backquote-change))
  (add-to-list 'warning-suppress-types
               ;;   '(undo discard-info)
               '(undo)))

;;;; projectile
(after! projectile
  (projectile-add-known-project "/Users/yunj/Dropbox/emacs/.doom.d/")
  ;; (projectile-add-known-project "~/Dropbox/research/hnet-irt")
  ;; (projectile-add-known-project "~/Dropbox/research/hnet-irt/GEPS")
  (projectile-add-known-project "/Users/yunj/Dropbox/research/lsjm-art/lsjm-draft/")
  ;; (projectile-add-known-project "~/Dropbox/research/lsjm-art")
  ;; (projectile-add-known-project "~/Dropbox/utsw-projects/HITS-CLIP")
  ;; (projectile-add-known-project "~/OneDrive/research/lapf")
  ;; (projectile-add-known-project "~/research/s.ham/RAS")
  ;; (projectile-add-known-project "~/research/mj.jeon")
  )

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
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
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
;; ;; https://github.com/kaz-yos/emacs/blob/master/init.d/500_recentf-related.el
;; (setq recentf-max-saved-items 300)
;; (setq recentf-max-menu-items 0)

;; disable recentf-cleanup on Emacs start, because it can cause problems with remote files
;; (setq recentf-auto-cleanup 'never)
;; (setq recentf-auto-cleanup 300)         ;; long recentf slow down emacs
;; (after! recentf
  ;; (setq recentf-auto-cleanup 600)
  ;; (add-to-list 'recentf-exclude 'file-remote-p)
  ;; )
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

(after! citar
  ;; list of paths
  (setq! citar-bibliography +biblio-default-bibliography-files
         citar-library-paths (list +biblio-pdf-library-dir)
         citar-notes-paths (list org-roam-directory)))

;; (setq bibtex-completion-pdf-open-function 'org-open-file)

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
(use-package! websocket
    :after org-roam)


(use-package! org-roam-ui
  :after org-roam ;; or :after org
  ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;         a hookable mode anymore, you're advised to pick something yourself
  ;;         if you don't care about startup time, use
  ;;  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

;;; elfeed
(after! elfeed
  ;; number of concurrent fetches
  (elfeed-set-max-connections 2)
  ;; (run-at-time nil (* 4 60 60) #'elfeed-update)
                                        ;update every 4 * 60 * 60 sec
  (setq
   ;; elfeed-search-title-max-width 100
   ;; elfeed-search-title-min-width 20
   ;; elfeed-search-filter "@3-week-ago"
   elfeed-show-entry-switch #'pop-to-buffer
   elfeed-show-entry-delete #'+rss/delete-pane
   ;; elfeed-search-print-entry-function '+rss/elfeed-search-print-entry
   elfeed-search-print-entry-function 'jyun/score-entry-line-draw
   ;; shr-max-image-proportion 0.6
   elfeed-search-date-format '("%m/%d/%y" 10 :left)
   ))


;;;; elfeed org-capture
(after! (org-capture elfeed)
  ;; elfeed capture
  (add-to-list 'org-capture-templates
               '("EFE" "Elfeed entry" entry
                 (file+headline +org-capture-inbox-file "Reading")
                 "* TODO %(message jyun/target-elfeed-title-link) :rss:
DEADLINE: %(org-insert-time-stamp (org-read-date nil t \"today\"))
%(message jyun/target-elfeed-entry-url)
%i \n%?"
                 :prepend t
                 :immediate-finish t)))

;; ;; A snippet for periodic update for feeds (10 mins since Emacs start, then every
;; ;; two hour)
;; (run-at-time (* 10 60) (* 2 60 60) #'(lambda () (progn
;;                                              (elfeed-set-max-connections 3)
;;                                              (elfeed-update))))

;;;; elfeed-score
(use-package! elfeed-score
  :after elfeed
  :init
  (setq elfeed-score-score-file (expand-file-name "elfeed.score" doom-private-dir))
  :config
  (progn
    ;; (elfeed-score-enable)
    (evil-define-key 'normal elfeed-search-mode-map "=" elfeed-score-map)
    ;; (define-key elfeed-search-mode-map "=" elfeed-score-map)
    ;; scores displayed in the search buffer
    ;; (setq elfeed-search-print-entry-function 'jyun/score-entry-line-draw)
    )
  )

;;; search
;;;; online lookup
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


;;;; deft
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

;;;; ffip
;; for doom-modeline
(use-package! find-file-in-project
  :commands
  (find-file-in-project
   find-file-in-current-directory-by-selected)
  :general (
            ;; [remap projectile-find-file] #'find-file-in-project
            [remap doom/find-file-in-private-config] #'jyun/find-file-in-private-config
            )
  :init
  (map! :leader "SPC" #'find-file-in-project-by-selected)
  :config
  (setq ffip-use-rust-fd t)
  ;; use ffip to find file in private config
  ;; (advice-add 'doom/find-file-in-private-config :around #'jyun/find-file-in-private-config)
  (setq ffip-ignore-filenames
  '(;; VCS
    ;; project misc
    "*.log"
    ;; Ctags
    "tags"
    "TAGS"
    ;; compressed
    "*.tgz"
    "*.gz"
    "*.xz"
    "*.zip"
    "*.tar"
    "*.rar"
    ;; Global/Cscope
    "GTAGS"
    "GPATH"
    "GRTAGS"
    "cscope.files"
    ;; html/javascript/css
    "*bundle.js"
    "*min.js"
    "*min.css"
    ;; Images
    "*.jpg"
    "*.jpeg"
    "*.gif"
    "*.bmp"
    "*.tiff"
    "*.ico"
    ;; documents
    "*.doc"
    "*.docx"
    "*.xls"
    "*.ppt"
    "*.odt"
    ;; C/C++
    "*.obj"
    "*.so"
    "*.o"
    "*.a"
    "*.ifso"
    "*.tbd"
    "*.dylib"
    "*.lib"
    "*.d"
    "*.dll"
    "*.exe"
    ;; Java
    ".metadata*"
    "*.class"
    "*.war"
    "*.jar"
    ;; Emacs/Vim
    "*flymake"
    "#*#"
    ".#*"
    "*.swp"
    "*~"
    "*.elc"
    ;; Python
    "*.pyc")))

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

;; ;; thinning all faces
(after! doom-modeline
  (add-hook! '(doom-load-theme-hook window-setup-hook)
             #'jyun/doom-modeline-height
             ;; #'jyun/thin-all-faces
             ;; #'jyun/evil-state-cursors
             ))

;;;; mixed-pitch-mode
;; (add-hook 'doom-init-ui-hook #'init-mixed-pitch-h)

(add-to-list '+zen-mixed-pitch-modes 'latex-mode)
(setq +zen-text-scale 0.8) ;; The text-scaling level for writeroom-mode

;;;; outline faces
;; (custom-set-faces!
;;   '(outline-1 :weight semi-bold :height 1.25)
;;   '(outline-2 :weight semi-bold :height 1.15)
;;   '(outline-3 :weight semi-bold :height 1.12)
;;   '(outline-4 :weight semi-bold :height 1.09)
;;   '(outline-5 :weight semi-bold :height 1.06)
;;   '(outline-6 :weight semi-bold :height 1.03)
;;   '(outline-8 :weight semi-bold)
;;   '(outline-9 :weight semi-bold))
;; (custom-set-faces!
;;   '(outline-1 :inherit 'variable-pitch :weight light :height 1.5)
;;   '(outline-2 :inherit 'variable-pitch :weight light :height 1.3)
;;   '(outline-3 :weight light :height 1.2)
;;   '(outline-4 :weight regular :height 1.1)
;;   '(outline-5 :weight regular :height 1.05)
;;   '(outline-6 :weight semi-bold :height 1.05)
;;   '(outline-7 :weight semi-bold :height 1.05)
;;   '(outline-8 :weight semi-bold :height 1.05)
;; org-title
;; (custom-set-faces!
;;   '(org-document-title :height 1.2))
;; deadlines in the error face when they're passed.
;; (setq org-agenda-deadline-faces
;;       '((1.001 . error)
;;         (1.0 . org-warning)
;;         (0.5 . org-upcoming-deadline)
;;         (0.0 . org-upcoming-distant-deadline)))

;;; coding + lsp-mode
;; disable flycheck by default
(remove-hook 'doom-first-buffer-hook #'global-flycheck-mode)

;; ibuffer and R buffers need to be manually added
(advice-add 'ibuffer :around #'jyun/persp-add-buffer)
(advice-add 'R :around #'jyun/persp-add-buffer)

;; ;; speed up comint
;; (setq gud-gdb-command-name "gdb --annotate=1"
;;       large-file-warning-threshold nil
;;       line-move-visual nil)

;;;; python
(setq ein:jupyter-default-kernel "tf")
(setq python-shell-interpreter "python"
      python-shell-interpreter-args "-i")
(after! python
  (setq conda-env-home-directory (expand-file-name "~/.conda"))
  (conda-env-activate "tf")
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

(setq
 lsp-ui-peek-mode nil                   ;; buggy if t before starting lsp
 lsp-ui-doc-show-with-mouse t
 ;; lsp-ui-sideline-show-hover nil
 ;; lsp-ui-doc-show-with-cursor       nil
 ;; lsp-ui-sideline-show-code-actions nil
 lsp-headerline-breadcrumb-enable t)

;;;; conda
;; (use-package! conda
;;   :after python
;;   :config
;;   (setq conda-anaconda-home (expand-file-name "/opt/intel/oneapi/intelpython/latest")
;;         conda-env-home-directory (expand-file-name "~/.conda"))
;;   (conda-env-activate "tf")
;;   ;; integration with term/eshell
;;   (conda-env-initialize-interactive-shells)
;;   (after! eshell (conda-env-initialize-eshell))
;;   (add-to-list 'global-mode-string
;;                '(conda-env-current-name (" conda:" conda-env-current-name " "))
;;                'append))

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
  (setq plantuml-jar-path "/usr/local/Cellar/plantuml/1.2021.4/libexec/plantuml.jar"
        plantuml-default-exec-mode 'jar
        org-plantuml-jar-path plantuml-jar-path))

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
 ) ; Don't put overwritten text in the kill ring

;; no key stroke for exiting INSERT mode: doom default jk
(setq evil-escape-key-sequence (kbd "jk")
      evil-escape-delay 0.15)
;; to escape from emacs state
(key-chord-mode 1)
(key-chord-define evil-emacs-state-map evil-escape-key-sequence 'evil-escape)
(key-chord-define evil-insert-state-map evil-escape-key-sequence 'evil-escape)

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

;;;;  ace-window
(setq aw-scope 'global
      aw-dispatch-always t
      aw-keys avy-keys)
;; C-w C-w ? to aw-show-dispath-help
(setq aw-dispatch-alist
      '((?x aw-delete-window "Delete Window")
        (?w aw-swap-window "Swap Windows")
        ;; (?M aw-move-window "Move Window")
        (?c aw-copy-window "Copy Window")
        (?i aw-switch-buffer-in-window "Select Buffer")
        (?p aw-flip-window)
        (?b aw-switch-buffer-other-window "Switch Buffer Other Window")
        (?m aw-execute-command-other-window "Execute Command Other Window")
        (?f aw-split-window-fair "Split Fair Window")
        (?v aw-split-window-vert "Split Vert Window")
        (?h aw-split-window-horz "Split Horz Window")
        (?o delete-other-windows "Delete Other Windows")
        (?T aw-transpose-frame "Transpose Frame")
        (?? aw-show-dispatch-help)))

;;; auto completition
;;;; ivy
;; https://github.com/hlissner/doom-emacs/issues/1317#issuecomment-483884401
(when (featurep! :completion ivy)
  ;; (remove-hook 'ivy-mode-hook #'ivy-rich-mode)
  ;; (setq ivy-height 15)
  (after! ivy-posframe
    (setq ivy-posframe-parameters
          `((min-width . ;; 90
                       20)
            (min-height . ,ivy-height)
            ;; (left-fringe . 8)
            ;; (right-fringe . 8)
            ))
    ;; (setq ivy-posframe-height-alist '((swiper . 10)))
    (pushnew! ivy-posframe-display-functions-alist
              '(counsel-M-x . ivy-display-function-fallback)
              '(counsel-describe-variable . ivy-display-function-fallback)
              '(swiper . ivy-display-function-fallback))))

;;;; company
(setq company-idle-delay 5.0
      company-minimum-prefix-length 2
      company-box-enable-icon t     ; disable all-the-icons
      company-tooltip-limit 10
      company-selection-wrap-around t)
;; company memory
(setq history-length 500)
;; (setq prescient-history-length 500)

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
(use-package! vertico-posframe
  :after vertico
  :if IS-GUI
  :config
  (vertico-posframe-mode 1)
  (setq vertico-posframe-poshandler #'posframe-poshandler-frame-bottom-center)
  ;; (setq vertico-posframe-poshandler #'posframe-poshandler-frame-top-center)
  (setq vertico-posframe-parameters
        '((left-fringe . 8)
          (right-fringe . 8))))

;;;; abbrev
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

;;; treemac
(after! treemacs
  (setq treemacs-width 25)
  (defvar treemacs-file-ignore-extensions '()
    "File extension which `treemacs-ignore-filter' will ensure are ignored")
  (defvar treemacs-file-ignore-globs '()
    "Globs which will are transformed to `treemacs-file-ignore-regexps' which `treemacs-ignore-filter' will ensure are ignored")
  (defvar treemacs-file-ignore-regexps '()
    "RegExps to be tested to ignore files, generated from `treeemacs-file-ignore-globs'")
  (defun treemacs-file-ignore-generate-regexps ()
    "Generate `treemacs-file-ignore-regexps' from `treemacs-file-ignore-globs'"
    (setq treemacs-file-ignore-regexps (mapcar 'dired-glob-regexp treemacs-file-ignore-globs)))
  (if (equal treemacs-file-ignore-globs '()) nil (treemacs-file-ignore-generate-regexps))
  (defun treemacs-ignore-filter (file full-path)
    "Ignore files specified by `treemacs-file-ignore-extensions', and `treemacs-file-ignore-regexps'"
    (or (member (file-name-extension file) treemacs-file-ignore-extensions)
        (let ((ignore-file nil))
          (dolist (regexp treemacs-file-ignore-regexps ignore-file)
            (setq ignore-file (or ignore-file (if (string-match-p regexp full-path) t nil)))))))
  (add-to-list 'treemacs-ignored-file-predicates #'treemacs-ignore-filter)
  (setq treemacs-file-ignore-extensions
        '(;; LaTeX
          "aux"
          "ptc"
          "fdb_latexmk"
          "fls"
          "synctex.gz"
          "toc"
          "cb"
          "cb2"
          ;; LaTeX - glossary
          "glg"
          "glo"
          "gls"
          "glsdefs"
          "ist"
          "acn"
          "acr"
          "alg"
          ;; LaTeX - pgfplots
          "mw"
          ;; LaTeX - pdfx
          "pdfa.xmpi"
          ;; ??
          "blg"
          ))
  (setq treemacs-file-ignore-globs
        '(;; LaTeX
          "*/_minted-*"
          ;; AucTeX
          "*/.auctex-auto"
          "*/_region_.log"
          "*/_region_.pdf"
          "*/_region_.tex")))

;;; dired "J"
;; replace `dired-goto-file' with equivalent helm and ivy functions:
;; `helm-find-files' fuzzy matching and other features
;; `counsel-find-file' more `M-o' actions
(with-eval-after-load 'dired
  (evil-define-key 'normal dired-mode-map "J"
    (cond ((featurep! :completion helm) 'helm-find-files)
          ((featurep! :completion ivy) 'counsel-find-file)
          (t 'find-file))))

;; OS X ls not working with --quoting-style=literal
(after! fd-dired
  (when IS-MAC
    (setq fd-dired-ls-option '("| xargs -0 gls -ld --quoting-style=literal" . "-ld"))))
;; display icons with colors
(setq all-the-icons-dired-monochrome nil)

;;; temporary fixes
;;;; eldoc error
;; https://github.com/hlissner/doom-emacs/issues/2972
;; (defadvice! +org--suppress-mode-hooks-a (orig-fn &rest args)
;;   :around #'org-eldoc-get-mode-local-documentation-function
;;   (delay-mode-hooks (apply orig-fn args)))
;; (after! org-eldoc
;;   (puthash "R" #'ignore org-eldoc-local-functions-cache))

;; https://github.com/hlissner/doom-emacs/issues/3185
(defadvice! no-errors/+org-inline-image-data-fn (_protocol link _description)
  :override #'+org-inline-image-data-fn
  "Interpret LINK as base64-encoded image data. Ignore all errors."
  (ignore-errors
    (base64-decode-string link)))

;; https://github.com/hlissner/doom-emacs/issues/4832
(advice-add #'org-capture :around
            (lambda (fun &rest args)
              (letf! ((#'+org--restart-mode-h #'ignore))
                (apply fun args))))

;;;; dap-mode
;; rigger the hydra when the program hits a breakpoint
(add-hook 'dap-stopped-hook
          (lambda (arg) (call-interactively #'dap-hydra)))

;;;; lsp
;; https://github.com/hlissner/doom-emacs/issues/5424
(defadvice! +lsp-diagnostics--flycheck-buffer ()
  :override #'lsp-diagnostics--flycheck-buffer
  "Trigger flycheck on buffer."
  (remove-hook 'lsp-on-idle-hook #'lsp-diagnostics--flycheck-buffer t)
  (when (bound-and-true-p flycheck-mode)
    (flycheck-buffer)))

;;;; org
(defadvice! shut-up-org-problematic-hooks (orig-fn &rest args)
  :around #'org-fancy-priorities-mode
  :around #'org-superstar-mode
  (ignore-errors (apply orig-fn args)))

;;;; org hangs on save, ox-hugo export, etc...
;;     https://lists.gnu.org/r/emacs-orgmode/2021-11/msg00638.html
;;     This has been fixed in faf8ce7de ??
(eval-after-load "org-element"
  (setq org-element-use-cache nil))
;; (add-hook 'after-init-hook  (lambda () (setq! gcmh-high-cons-threshold (* 64 1024 1024))))
;; (setq! gcmh-high-cons-threshold (* 64 1024 1024))
                                        ; xx mb

;;; tree-sitter
(use-package! tree-sitter
  :hook
  (prog-mode . global-tree-sitter-mode)
  :config
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))
(use-package! tree-sitter-langs
  :after tree-sitter)

;;; archive
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

;;;; editorconfig
;; editorconfig forces `require-final-newline' and `mode-require-final-newline' to `t
;; to remove a terminal newline in `snippet-mode', turn off editorconfig and set the values to t
;; or one can edit .editorconfig file
;; see ~/.doom.d/snippets/.editorconfig
;; (add-hook 'snippet-mode-hook '(lambda ()
;;                                 (progn
;;                                   (editorconfig-mode -1)
;;                                   (set (make-local-variable 'require-final-newline) nil))
;;                                 ))
;;

;;; testing
;;;; explain pause
(use-package! explain-pause-mode
  :commands (explain-pause-mode))

;;; eshell
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

;;; lsp-ltex
(use-package! lsp-ltex
  :after latex
  ;; :hook (LaTeX-mode . (lambda () (require 'lsp-ltex) (lsp!)))
  :config
  (setq lsp-ltex-enabled nil)
  (setq lsp-ltex-server-store-path "~/local/ltex-ls/"
        lsp-ltex-version "15.2.0")
  (setq lsp-ltex-dictionary "~/.hunspell_en_US")
  ;; (setq lsp-ltex-disabled-rules ;; '(({"MORFOLOGIK_RULE_EN_US"}))
  ;;       '(("{\"en-US\": [\"MORFOLOGIK_RULE_EN_US\"]}")))
  ;; (setq lsp-ltex--filename "ltex-ls-15.2.0-mac-x64"
  ;;      lsp-ltex--extension-name "ltex-ls-15.2.0-mac-x64.tar.gz")
  ;; (setq lsp-ltex--executable-path "~/local/ltex-ls/ltex-ls-15.2.0/bin/")
  )

;;; desktop.el
;; (desktop-save-mode 1)
;; (add-to-list 'desktop-globals-to-save 'file-name-history)

;;; anki
(use-package! anki-editor
  :after org-capture
  :init
  (defvar org-anki-file (concat (file-name-as-directory org-directory) "anki.org")
    "anki-notes file.")
  ;; Org-capture templates
  (with-eval-after-load 'org-capture
    ;; Org-capture templates
    (add-to-list 'org-capture-templates
                 `("a" "Anki"))
    (add-to-list 'org-capture-templates
                 `("ab" "Anki basic"
                   entry
                   (file+headline ,org-anki-file "Dispatch Shelf")
                   "* %<%H:%M>   %^g\n:PROPERTIES:\n:ID: %(shell-command-to-string \"uuidgen\"):ANKI_NOTE_TYPE: Basic\n:ANKI_DECK: Default\n:END:\n** Front\n%?\n** Back\n\n"
                   :kill-buffer t))
    (add-to-list 'org-capture-templates
                 `("ac" "Anki cloze"
                   entry
                   (file+headline ,org-anki-file "Dispatch Shelf")
                   "* %<%H:%M>   %^g\n:PROPERTIES:\n:ID: %(shell-command-to-string \"uuidgen\"):ANKI_NOTE_TYPE: Cloze\n:ANKI_DECK: Default\n:END:\n** Text\n\n** Extra\n"
                   :kill-buffer t)))
  :bind (:map org-mode-map
         ("C-c k +"  . anki-editor-cloze-region-auto-incr)
         ("C-c k -"  . anki-editor-cloze-region-dont-incr)
         ("C-c k ="  . anki-editor-reset-cloze-number)
         ("C-c k p"  . anki-editor-push-tree))
  :hook (org-capture-after-finalize . anki-editor-reset-cloze-number) ; Reset cloze-number after each capture.
  :config
  (setq anki-editor-create-decks t ;; Allow anki-editor to create a new deck if it doesn't exist
        anki-editor-org-tags-as-anki-tags t
        anki-editor-break-consecutive-braces-in-latex t)
  (defun anki-editor-cloze-region-auto-incr (&optional arg)
    "Cloze region without hint and increase card number."
    (interactive)
    (anki-editor-cloze-region my-anki-editor-cloze-number "")
    (setq my-anki-editor-cloze-number (1+ my-anki-editor-cloze-number))
    (forward-sexp))
  (defun anki-editor-cloze-region-dont-incr (&optional arg)
    "Cloze region without hint using the previous card number."
    (interactive)
    (anki-editor-cloze-region (1- my-anki-editor-cloze-number) "")
    (forward-sexp))
  (defun anki-editor-reset-cloze-number (&optional arg)
    "Reset cloze number to ARG or 1"
    (interactive)
    (setq my-anki-editor-cloze-number (or arg 1)))
  (defun anki-editor-push-tree ()
    "Push all notes under a tree."
    (interactive)
    (anki-editor-push-notes '(4))
    (anki-editor-reset-cloze-number))
  ;; Initialize
  (anki-editor-reset-cloze-number))

;;; org-roam
(after! org-roam
  (defun dw/org-roam-filter-by-tag (tag-name)
    (lambda (node)
      (member tag-name (org-roam-node-tags node))))

  (defun dw/org-roam-list-notes-by-tag (tag-name)
    (mapcar #'org-roam-node-file
            (seq-filter
             (dw/org-roam-filter-by-tag tag-name)
             (org-roam-node-list))))

  (defun dw/org-roam-refresh-agenda-list ()
    (interactive)
    (setq org-agenda-files (dw/org-roam-list-notes-by-tag "roadmap")))

  ;; Build the agenda list the first time for the session
  (dw/org-roam-refresh-agenda-list)

  (defun dw/org-roam-project-finalize-hook ()
    "Adds the captured project file to `org-agenda-files' if the
capture was not aborted."
    ;; Remove the hook since it was added temporarily
    (remove-hook 'org-capture-after-finalize-hook #'dw/org-roam-project-finalize-hook)

    ;; Add project file to the agenda list if the capture was confirmed
    (unless org-note-abort
      (with-current-buffer (org-capture-get :buffer)
        (add-to-list 'org-agenda-files (buffer-file-name)))))

  (defun dw/org-roam-find-project ()
    (interactive)
    ;; Add the project file to the agenda after capture is finished
    (add-hook 'org-capture-after-finalize-hook #'dw/org-roam-project-finalize-hook)

    ;; Select a project file to open, creating it if necessary
    (org-roam-node-find
     nil
     nil
     (dw/org-roam-filter-by-tag "roadmap")
     :templates
     '(("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
        :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+category: ${title}\n#+filetags: roadmap")
        :unnarrowed t))))

  ;; (defun dw/org-roam-capture-inbox ()
  ;;   (interactive)
  ;;   (org-roam-capture- :node (org-roam-node-create)
  ;;                      :templates '(("i" "inbox" plain "* %?"
  ;;                                    :if-new (file+head "Inbox.org" "#+title: Inbox\n")))))

  (defun dw/org-roam-capture-task ()
    (interactive)
    ;; Add the project file to the agenda after capture is finished
    (add-hook 'org-capture-after-finalize-hook #'dw/org-roam-project-finalize-hook)

    ;; Capture the new task, creating the project file if necessary
    (org-roam-capture- :node (org-roam-node-read
                              nil
                              (dw/org-roam-filter-by-tag "roadmap"))
                       :templates '(("p" "project" plain "** TODO %?"
                                     :if-new (file+head+olp "%<%Y%m%d%H%M%S>-${slug}.org"
                                                            "#+title: ${title}\n#+category: ${title}\n#+filetags: roadmap"
                                                            ("Tasks [/]")))))))


;;; hugo
;;;###autoload
(defun jyun/run-hugo-server (&optional wd fl)
  ""
  (interactive)
  (let ((default-directory (or wd default-directory))
        (flag (or fl "--disableFastRender"))
        (buf (current-buffer))
        (bname (concat "*hugo-server:" default-directory "*")))
    (start-process "hugo-server" bname "hugo" "server" flag)
    (set-process-sentinel (get-process "hugo-server") 'msg-me)
    (with-current-buffer bname
      (ess-r-mode)
      (+popup/buffer)
      (buffer-disable-undo))))

;;; clean local elc
(defun jyun/clean-and-rebuild-local-pacakges ()
  (interactive)
  (let* ((pkg-list '("scimax" "doom-snippets" "langtool-posframe" "emacs-overleaf"))
         (build-dir (concat doom-local-dir "straight/build-27.2/")))
    (when (y-or-n-p "Do you want delete local package builds?")
      (dolist (pkg pkg-list)
        (delete-directory (concat build-dir pkg) t t)))
    (when (y-or-n-p "Do you want rebuild local packages?")
      (start-process "doom-sync" "*doom-sync" "doom" "sync")
      (set-process-sentinel (get-process "doom-sync") 'msg-me))))


;;; svg-tag
(progn
  (defface font-svg-tag-tags
    '((t (:family "Roboto Slab" :weight light)))
    "TODO"
    :group 'basic-faces)
  (use-package! svg-tag-mode
    :init
    (add-hook! '(org-mode-hook) #'svg-tag-mode)
    :commands (svg-tag-mode global-svg-tag-mode)
    :config
    (defconst date-re "[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}")
    (defconst time-re "[0-9]\\{2\\}:[0-9]\\{2\\}")
    (defconst day-re "[A-Za-z]\\{3\\}")
    (defun svg-progress-percent (value)
      (svg-image (svg-lib-concat
                  (svg-lib-progress-bar (/ (string-to-number value) 100.0)
                                        nil :margin 0 :stroke 2 :radius 3 :padding 2 :width 11)
                  (svg-lib-tag (concat value "%")
                               nil :stroke 0 :margin 0)) :ascent 'center))
    (defun svg-progress-count (value)
      (let* ((seq (mapcar #'string-to-number (split-string value "/")))
             (count (float (car seq)))
             (total (float (cadr seq))))
        (svg-image (svg-lib-concat
                    (svg-lib-progress-bar (/ count total) nil
                                          :margin 0 :stroke 2 :radius 3 :padding 2 :width 11)
                    (svg-lib-tag value nil
                                 :stroke 0 :margin 0)) :ascent 'center)))
    (setq svg-tag-tags
          `(
            ;; Task priority
            ("\\[#[A-Z]\\]" . ( (lambda (tag)
                                  (svg-tag-make tag :face 'org-priority
                                                :beg 2 :end -1 :margin 0))))
            ;; TODO / DONE
            ("TODO" . ((lambda (tag) (svg-tag-make "TODO" :face 'org-todo :inverse t :margin 0))))
            ("DONE" . ((lambda (tag) (svg-tag-make "DONE" :face 'org-done :margin 0))))
            ("NEXT" . ((lambda (tag) (svg-tag-make "NEXT" :face '+org-todo-next :margin 0))))
            ("HOLD" . ((lambda (tag) (svg-tag-make "HOLD" :face '+org-todo-hold :margin 0))))
            ("IDEA" . ((lambda (tag) (svg-tag-make "IDEA" :face '+org-todo-idea :margin 0))))
            ("WAIT" . ((lambda (tag) (svg-tag-make "WAIT" :face '+org-todo-wait :margin 0))))
            ("KILL" . ((lambda (tag) (svg-tag-make "KILL" :face '+org-todo-kill :margin 0))))
            ;; Org @tags
            ("\\(:@[A-Za-z0-9]+\\)" . ((lambda (tag) (svg-tag-make tag :beg 1 :face 'org-tag))))
            ("\\(:@[A-Za-z0-9]+:\\)$" . ((lambda (tag) (svg-tag-make tag :beg 1 :end -1 :face 'org-tag))))
            ;; ;; Org tags
            ;; (":\\([A-Za-z0-9]+\\)" . ((lambda (tag) (svg-tag-make tag :face 'org-tag))))
            ;; (":\\([A-Za-z0-9]+[ \-]\\)" . ((lambda (tag) tag)))
            ;; (,(format "%s" time-re) . ((lambda (tag) tag)))
            ;; ;; Active date (with day name, with or without time)
            ;; (,(format "\\(<%s %s>\\)" date-re day-re) .
            ;;  ((lambda (tag)
            ;;     (svg-tag-make tag :beg 1 :end -1 :margin 0))))
            ;; (,(format "\\(<%s %s *\\)%s>" date-re day-re time-re) .
            ;;  ((lambda (tag)
            ;;     (svg-tag-make tag :beg 1 :inverse nil :crop-right t :margin 0))))
            ;; (,(format "<%s %s *\\(%s>\\)" date-re day-re time-re) .
            ;;  ((lambda (tag)
            ;;     (svg-tag-make tag :end -1 :inverse t :crop-left t :margin 0))))
            ;; ;; Inactive date  (with day name, with or without time)
            ;; (,(format "\\(\\[%s %s\\]\\)" date-re day-re) .
            ;;  ((lambda (tag)
            ;;     (svg-tag-make tag :beg 1 :end -1 :margin 0 :face 'org-date))))
            ;; (,(format "\\(\\[%s %s *\\)%s\\]" date-re day-re time-re) .
            ;;  ((lambda (tag)
            ;;     (svg-tag-make tag :beg 1 :inverse nil :crop-right t :margin 0 :face 'org-date))))
            ;; (,(format "\\[%s %s *\\(%s\\]\\)" date-re day-re time-re) .
            ;;  ((lambda (tag)
            ;;     (svg-tag-make tag :end -1 :inverse t :crop-left t :margin 0 :face 'org-date))))
            ))))

;;; dired
(after! dired
  ;; block size 900kb = same as default
  (setf (alist-get "\\.tar\\.bz2\\'" dired-compress-files-alist nil nil #'equal) "tar -cf - %i | pbzip2 -c9 > %o")
  ;; level 9 compression
  (push  '("\\.tar\\.lz\\'" .  "tar -cf - %i | plzip -9c > %o") dired-compress-files-alist))

;;; emacs-everywhere
(setq emacs-everywhere-frame-parameters
  `((name . "emacs-everywhere")
    (width . 80)
    (height . 24)))
;; export to markdown when closing the frame
;; (setq emacs-everywhere-major-mode-function #'org-mode)



;;; Tab-bar
(use-package! tab-bar
  :if (not (version-list-<
            (version-to-list emacs-version)
            '(27 0 1 0)))
  ;; :after cus-face
  :commands (tab-bar-mode)
  :bind-keymap ("H-t" . tab-prefix-map)
  :bind
  (("C-M-<tab>" . tab-bar-switch-to-next-tab)
   ("C-M-S-<tab>" . tab-bar-switch-to-prev-tab)
   ("H-<tab>" . tab-bar-switch-to-next-tab)
   ("H-<iso-lefttab>" . tab-bar-switch-to-prev-tab)
   ("s-u" . tab-bar-history-back)
   ("C-c u" . tab-bar-history-back)
   ("s-S-U" . tab-bar-history-forward)
   :map tab-prefix-map
   ("h" . my/tab-bar-show-hide-tabs)
   ("H-t" . tab-bar-select-tab-by-name))
  :config
  (tab-bar-history-mode 1)
  (setq  tab-bar-close-last-tab-choice 'tab-bar-mode-disable
         tab-bar-show                   1
         tab-bar-tab-name-truncated-max 14
         tab-bar-new-tab-choice        'ibuffer
         ;; tab-bar-tab-name-function '(lambda nil
         ;;                              "Use directory as tab name."
         ;;                              (let ((dir (expand-file-name
         ;;                                          (or (if (fboundp 'project-root)
         ;;                                                  (project-root (project-current)))
         ;;                                              default-directory))))
         ;;                                (substring dir (1+ (string-match "/[^/]+/$" dir)) -1 )))
         ;; tab-bar-select-tab-modifiers  '(meta)
         ;; tab-bar-tab-name-function 'tab-bar-tab-name-truncated
         ;; tab-bar-tab-name-function '(lambda nil (upcase (tab-bar-tab-name-truncated)))
         tab-bar-close-button-show nil
         )
  (defun my/tab-bar-show-hide-tabs ()
    "Show or hide tabs."
    (interactive)
    (setq tab-bar-show (if tab-bar-show nil 1)))
  (custom-set-faces
  '(tab-bar ((t (:height 1.0))))
  '(tab-bar-tab-inactive ((t (:inherit tab-bar :weight light))))
  ;; '(tab-bar-tab ((t (:inherit variable-pitch :background "#ffffff" :underline t :height 0.95)))))
  '(tab-bar-tab ((t (:inherit tab-bar :background "#ffffff" :underline t :height 1.0))))
  )
  ;; (advice-add 'tab-bar-rename-tab
  ;;             :after
  ;;             (defun +tab-bar-name-upcase (_name &optional _arg)
  ;;               "Upcase current tab name"
  ;;               (let* ((tab (assq 'current-tab (frame-parameter nil 'tabs)))
  ;;                      (tab-name (alist-get 'name tab)))
  ;;                 (setf (alist-get 'name tab) (upcase tab-name)
  ;;                       (alist-get 'explicit-name tab) t))
  ;;               ))
  )
(use-package! tab-bar-echo-area
  :ensure
  :demand
  :after tab-bar
  :init
  (defvar tab-bar-format nil "Format for tab-bar-echo-area-mode")
  :config
  (tab-bar-echo-area-mode 1)
  (add-to-list 'tab-bar-format #'tab-bar-format-menu-bar)
  :bind (:map tab-prefix-map
              ("c" . tab-bar-echo-area-display-tab-name)
              ("P" . tab-bar-echo-area-display-tab-names)))
(use-package! tab-bar-groups
  :ensure
  :after tab-bar
  :config
  (tab-bar-groups-activate))

;;; remove ^M
(defun delete-carrage-returns ()
  (interactive)
  (save-excursion
    (goto-char 0)
    (while (search-forward "\r" nil :noerror)
      (replace-match ""))))

;;; vertico extension
;; karthink
;; https://www.reddit.com/r/emacs/comments/ryqfz1/vertico_extensions_demo/
;; (vertico-indexed-mode)
(use-package! vertico-quick
  ;; :load-path "~/.local/share/git/vertico/extensions/"
  :after vertico
  :bind (:map vertico-map
         ("M-i" . vertico-quick-insert)
         ("C-'" . vertico-quick-exit)
         ("C-o" . vertico-quick-embark))
  :config
  (defun vertico-quick-embark (&optional arg)
    "Embark on candidate using quick keys."
    (interactive)
    (when (vertico-quick-jump)
      (embark-act arg))))

;;; very large files
;; make VLF available without delaying startup,
(use-package! vlf-setup
  :defer-incrementally vlf-tune vlf-base vlf-write vlf-search vlf-occur vlf-follow vlf-ediff vlf)

;;; initial evil state
(evil-set-initial-state 'sql-interactive-mode 'insert)
