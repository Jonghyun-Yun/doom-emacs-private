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
(load-theme 'modus-operandi t)
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

(if (version= emacs-version "29.0.50")
    (pixel-scroll-precision-mode))

;;; load lisp
(setq load-prefer-newer t)
(when IS-MAC
;(load! "local/splash")
)
(with-eval-after-load 'hydra
  (load! "local/hydra-plus"))
(load! "bindings")

(when IS-MAC
  (setq system-screenshot-method "pngpaste %s"))

;; https://gist.github.com/d12frosted/a60e8ccb9aceba031af243dff0d19b2e
;; don't add all org-roam files to agenda
;; only those who with TODO keywords, schedule, or deadline
;; run before org-plus
(after! org
  ;; https://zzamboni.org/post/how-to-insert-screenshots-in-org-documents-on-macos/
  (remove-hook 'org-load-hook #'+org-init-capture-defaults-h)
  (add-to-list 'org-tags-exclude-from-inheritance "roadmap")
  (load! "local/vulpea-agenda/vulpea-agenda")
  (setq +org-capture-job-file "~/org/jobs.org")
  (setq +org-capture-bookmark-file "~/org/inbox.org")
  )
(after! org-download
  (setq org-download-screenshot-method system-screenshot-method)
  )
(load! "local/org-plus")

;; ;; (when (modulep! :ui ligatures +extra)
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
(when (modulep! :lang org +pretty)
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
  (setq org-image-actual-width t)
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

;;;; org-remark
(use-package! org-remark
  :init
  (require 'org-remark-global-tracking)
  (org-remark-global-tracking-mode +1)
  ;; Key-bind `org-remark-mark' to global-map so that you can call it globally
  ;; before the library is loaded.  In order to make `org-remark-mark' and
  ;; `org-remark-mode' callable, use `autoload'.
  (autoload #'org-remark-mark "org-remark" nil t)
  (autoload #'org-remark-mode "org-remark" nil t)
  (define-key global-map (kbd "C-c n m") #'org-remark-mark)
  :after org
  :config
  ;; The rest of keybidings are done only on loading `org-remark'
  (define-key org-remark-mode-map (kbd "C-c n o") #'org-remark-open)
  (define-key org-remark-mode-map (kbd "C-c n ]") #'org-remark-view-next)
  (define-key org-remark-mode-map (kbd "C-c n [") #'org-remark-view-prev)
  (define-key org-remark-mode-map (kbd "C-c n r") #'org-remark-remove)
  )
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
(unless IS-LINUX
  (after! projectile
    (projectile-add-known-project "/Users/yunj/Dropbox/emacs/.doom.d/")
    (projectile-add-known-project "/Users/yunj/Dropbox/workspace/swap/")
    (projectile-add-known-project "/Users/yunj/OneDrive/workspace/python-tutorial/HarvardX-Using_Python_for_Research/")
    ;; (projectile-add-known-project "~/Dropbox/research/hnet-irt")
    ;; (projectile-add-known-project "~/Dropbox/research/hnet-irt/GEPS")
    (projectile-add-known-project "/Users/yunj/Dropbox/research/lsjm-art/lsjm-draft/")
    ;; (projectile-add-known-project "~/Dropbox/research/lsjm-art")
    ;; (projectile-add-known-project "~/Dropbox/utsw-projects/HITS-CLIP")
    ;; (projectile-add-known-project "~/OneDrive/research/lapf")
    ;; (projectile-add-known-project "~/research/s.ham/RAS")
    ;; (projectile-add-known-project "~/research/mj.jeon")
    ))

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

(when (modulep! :tools biblio)
  (after! org-ref
    (setq org-ref-insert-cite-function
          (lambda ()
	    (org-cite-insert nil)))))

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
  (elfeed-set-max-connections 5)
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

;;;; elfeed-summary
;; https://github.com/SqrtMinusOne/elfeed-summary
(use-package! elfeed-summary
  :after elfeed
  )

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

;; (defvar doom-elfeed-dir (concat doom-private-dir ".local/elfeed/")
;;   "TODO")
;; (after! elfeed
;;   (setq elfeed-db-directory (concat doom-elfeed-dir "db/")
;;         elfeed-enclosure-default-dir (concat doom-elfeed-dir "enclosures/"))
;;   )

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
             ;; #'jyun/doom-modeline-height
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

;; line-number
(add-hook! 'prog-mode-hook (setq display-line-numbers t))

;; ibuffer and R buffers need to be manually added
(advice-add 'ibuffer :around #'jyun/persp-add-buffer)
(advice-add 'R :around #'jyun/persp-add-buffer)
;; (advice-add 'jupyter-run-repl :around #'jyun/persp-add-buffer)

;; ;; speed up comint
;; (setq gud-gdb-command-name "gdb --annotate=1"
;;       large-file-warning-threshold nil
;;       line-move-visual nil)

;;;; python
(setq ein:jupyter-default-kernel "ds")
(setq python-shell-interpreter "ipython"
      ;; python-shell-interpreter-args "--simple-prompt"
      python-shell-interpreter-args "-i")
;; (setq python-shell-interpreter "jupyter"
;;       python-shell-interpreter-args "console --simple-prompt"
;;       python-shell-prompt-detect-failure-warning nil)


(after! python
  (setq conda-env-home-directory (expand-file-name "~/.conda"))
  (conda-env-activate "ds")
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
   lsp-headerline-breadcrumb-enable t
   lsp-ui-doc-show-with-mouse t))

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
(when (modulep! :completion ivy)
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
(setq company-idle-delay 1.0
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
    (cond ((modulep! :completion helm) 'helm-find-files)
          ((modulep! :completion ivy) 'counsel-find-file)
          (t 'find-file))))

;; OS X ls not working with --quoting-style=literal
(after! fd-dired
  (when IS-MAC
    (setq fd-dired-ls-option '("| xargs -0 gls -ld --quoting-style=literal" . "-ld"))))
;; display icons with colors
;; (setq all-the-icons-dired-monochrome nil)

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
;; (eval-after-load "org-element"
  ;; (setq org-element-use-cache nil))
;; (add-hook 'after-init-hook  (lambda () (setq! gcmh-high-cons-threshold (* 64 1024 1024))))
;; (setq! gcmh-high-cons-threshold (* 64 1024 1024))
                                        ; xx mb

;;; tree-sitter
;; (use-package! tree-sitter
;;   :hook
;;   (prog-mode . global-tree-sitter-mode)
;;   :config
;;   (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))
;; (use-package! tree-sitter-langs
;;   :after tree-sitter)


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


;;; clean local elc
(defun jyun/clean-and-rebuild-local-pacakges ()
  (interactive)
  (let* ((pkg-list '("scimax" "doom-snippets" "langtool-posframe" "emacs-overleaf" "org-cv"))
         (build-dir (concat doom-local-dir "straight/build-27.2/")))
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

;;; very large files
;; make VLF available without delaying startup,
(use-package! vlf-setup
  :defer-incrementally vlf-tune vlf-base vlf-write vlf-search vlf-occur vlf-follow vlf-ediff vlf)

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
(use-package ob-ammonite
  ;; :ensure-system-package (amm . "sudo sh -c '(echo \"#!/usr/bin/env sh\" && curl -L https://github.com/lihaoyi/Ammonite/releases/download/2.0.4/2.13-2.0.4) > /usr/local/bin/amm && chmod +x /usr/local/bin/amm' && amm")
  :defer t
  :when (modulep! :lang scala)
  :config
  (require 'ammonite-term-repl)
  ;; (defun ag91/substitute-sbt-deps-with-ammonite ()
  ;;   "Substitute sbt-style dependencies with ammonite ones."
  ;;   (interactive)
  ;;   (apply 'narrow-to-region (if (region-active-p) (my/cons-cell-to-list (region-bounds)) `(,(point-min) ,(point-max))))
  ;;   (goto-char (point-min))
  ;;   (let ((regex "\"\\(.+?\\)\"[ ]+%\\{1,2\\}[ ]+\"\\(.+?\\)\"[ ]+%\\{1,2\\}[ ]+\"\\(.+?\\)\"")
  ;;         (res))
  ;;     (while (re-search-forward regex nil t)
  ;;       (let* ((e (point))
  ;;              (b (search-backward "\"" nil nil 6))
  ;;              (s (buffer-substring-no-properties b e))
  ;;              (s-without-percent (apply 'concat (split-string s "%")))
  ;;              (s-without-quotes (remove-if (lambda (x) (eq x ?" ;"
  ;;                                                      ))
  ;;                                           s-without-percent))
  ;;              (s-as-list (split-string s-without-quotes)))
  ;;         (delete-region b e)
  ;;         (goto-char b)
  ;;         (insert (format "import $ivy.`%s::%s:%s`" (first s-as-list) (second s-as-list) (third s-as-list)))
  ;;         )
  ;;       )
  ;;     res)
  ;;   (widen))
  )

(use-package ammonite-term-repl
  :defer t
  :config
  (setq ammonite-term-repl-auto-detect-predef-file nil
        ammonite-term-repl-program-args '("--no-default-predef" "--no-home-predef")))

(use-package! ob-scala
  :when (modulep! :lang scala)
  ;; :after org
  :after scala-mode)

;;; org-mode jupyter
(eval-after-load "jupyter-client"
  ;; (map! :map org-src-mode-map
  ;;       "C-c C-c" #'org-edit-src-exit)
  (map! :map jupyter-repl-interaction-mode-map
        "C-c C-c" nil)
  )
(setq jupyter-repl-echo-eval-p t)


;;; spell-fu
(add-hook! 'org-mode-hook (lambda () (setq spell-fu-mode -1)))
(remove-hook 'text-mode-hook #'spell-fu-mode)

;;; ox-ipynb
(after! org
  (require 'ox-ipynb)
  ;; conflict with +org-redisplay-inline-images-in-babel-result-h
  (advice-remove 'org-display-inline-images 'font-lock-fontify-buffer)
  )

;;; org-babel ansi color
;; (defun ek/babel-ansi ()
;;   (when-let ((beg (org-babel-where-is-src-block-result nil nil)))
;;     (save-excursion
;;       (goto-char beg)
;;       (when (looking-at org-babel-result-regexp)
;;         (let ((end (org-babel-result-end))
;;               (ansi-color-context-region nil))
;;           (ansi-color-apply-on-region beg end))))))
;; (add-hook 'org-babel-after-execute-hook 'ek/babel-ansi)

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

;;; native-comp
;; (add-to-list 'native-comp-deferred-compilation-deny-list "\\`/Users/yunj/doom-emacs/\\.local/.*/vertico-posframe\\.el\\'")

(when IS-GUI
;;; org-modern
  ;; Add frame borders and window dividers
  ;; (modify-all-frames-parameters
  ;;  '((right-divider-width . 40)
  ;;    (internal-border-width . 40)))
  ;; (dolist (face '(window-divider
  ;;                 window-divider-first-pixel
  ;;                 window-divider-last-pixel))
  ;;   (face-spec-reset-face face)
  ;;   (set-face-foreground face (face-attribute 'default :background)))
  ;; (set-face-background 'fringe (face-attribute 'default :background))

(setq
 ;; Edit settings
 ;; org-auto-align-tags nil
 ;; org-tags-column 0
 org-catch-invisible-edits 'show-and-error
 ;; org-special-ctrl-a/e t
 ;; org-insert-heading-respect-content t
 org-modern-star ["♠""♡""♦""♧"]
 ;; org-modern-star ["◉""○""◈""◇""⁕"]
 ;; Org styling, hide markup etc.
 ;; org-hide-emphasis-markers nil
 ;; org-pretty-entities nil
 ;; org-ellipsis "…"

 ;; Agenda styling
 org-agenda-block-separator ?─
 org-agenda-time-grid
 '((daily today require-timed)
   (800 1000 1200 1400 1600 1800 2000)
   " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
 org-agenda-current-time-string
 "⭠ now ─────────────────────────────────────────────────")

(add-hook 'org-mode-hook #'org-modern-mode)
(add-hook 'org-agenda-finalize-hook #'org-modern-agenda))

;;; appearance
(use-package! lin
  :config
  (setq lin-face 'lin-blue) ; check doc string for alternative styles

  ;; You can use this to live update the face:
  ;;
  ;; (customize-set-variable 'lin-face 'lin-green)

  (setq lin-mode-hooks
        '(bongo-mode-hook
          dired-mode-hook
          elfeed-search-mode-hook
          git-rebase-mode-hook
          grep-mode-hook
          ibuffer-mode-hook
          ilist-mode-hook
          ledger-report-mode-hook
          log-view-mode-hook
          magit-log-mode-hook
          mu4e-headers-mode
          notmuch-search-mode-hook
          notmuch-tree-mode-hook
          occur-mode-hook
          org-agenda-mode-hook
          proced-mode-hook
          tabulated-list-mode-hook))

  (lin-global-mode 1)
  )

(use-package! pulsar
  :config
  (setq pulsar-pulse-functions
        ;; NOTE 2022-04-09: The commented out functions are from before
        ;; the introduction of `pulsar-pulse-on-window-change'.  Try that
        ;; instead.
        '(recenter-top-bottom
          move-to-window-line-top-bottom
          reposition-window
          ;; bookmark-jump
          ;; other-window
          ;; delete-window
          ;; delete-other-windows
          forward-page
          backward-page
          scroll-up-command
          scroll-down-command
          ;; windmove-right
          ;; windmove-left
          ;; windmove-up
          ;; windmove-down
          ;; windmove-swap-states-right
          ;; windmove-swap-states-left
          ;; windmove-swap-states-up
          ;; windmove-swap-states-down
          ;; tab-new
          ;; tab-close
          ;; tab-next
          org-next-visible-heading
          org-previous-visible-heading
          org-forward-heading-same-level
          org-backward-heading-same-level
          outline-backward-same-level
          outline-forward-same-level
          outline-next-visible-heading
          outline-previous-visible-heading
          outline-up-heading))

  (setq pulsar-pulse-on-window-change t)
  (setq pulsar-pulse t)
  (setq pulsar-delay 0.055)
  (setq pulsar-iterations 10)
  (setq pulsar-face 'pulsar-magenta)
  (setq pulsar-highlight-face 'pulsar-yellow)

  (pulsar-global-mode 1)

  ;; OR use the local mode for select mode hooks

  (dolist (hook '(org-mode-hook emacs-lisp-mode-hook))
    (add-hook hook #'pulsar-mode))

  ;; pulsar does not define any key bindings.  This is just a sample that
  ;; respects the key binding conventions.  Evaluate:
  ;;
  ;;     (info "(elisp) Key Binding Conventions")
  ;;
  ;; The author uses C-x l for `pulsar-pulse-line' and C-x L for
  ;; `pulsar-highlight-line'.
  ;;
  ;; You can replace `pulsar-highlight-line' with the command
  ;; `pulsar-highlight-dwim'.
  (let ((map global-map))
    (define-key map (kbd "C-c h p") #'pulsar-pulse-line)
    (define-key map (kbd "C-c h h") #'pulsar-highlight-line))
  ;; integration with the `consult' package:
  (add-hook 'consult-after-jump-hook #'pulsar-recenter-top)
  (add-hook 'consult-after-jump-hook #'pulsar-reveal-entry)

  ;; integration with the built-in `imenu':
  (add-hook 'imenu-after-jump-hook #'pulsar-recenter-top)
  (add-hook 'imenu-after-jump-hook #'pulsar-reveal-entry)
  )

;;; window split
(defun jyun/resize-window-legal-pdf ()
  "resize a selected window to fit a legal size pdf file."
  (interactive)
  (doom-resize-window nil 62)
  (doom-resize-window nil 90 t)
  )

(defun spacemacs--window-split-splittable-windows ()
  (seq-remove
   (lambda (window)
     ;; TODO: find a way to identify unsplittable side windows reliably!
     nil)
   (spacemacs--window-split-non-ignored-windows)))

(defun spacemacs--window-split-non-ignored-windows ()
  "Determines the list of windows to be deleted."
  (seq-filter
   (lambda (window)
     (let* ((name (buffer-name (window-buffer window)))
            (prefixes-matching
             (seq-filter
              (lambda (prefix) (string-prefix-p prefix name))
              spacemacs-window-split-ignore-prefixes)))
       (not prefixes-matching)))
   (window-list (selected-frame))))

(defun spacemacs/window-split-default-delete ()
  "Deletes other windows, except a list of excluded ones."
  (if spacemacs-window-split-ignore-prefixes
      (let* ((deletable (spacemacs--window-split-non-ignored-windows))
             (splittable (spacemacs--window-split-splittable-windows)))
        (when splittable
          (let* ((selected (car splittable))
                 (to-delete (delq selected deletable)))
            (select-window selected)
            (dolist (window to-delete) (delete-window window)))))
    (delete-other-windows)))

(defvar spacemacs-window-split-ignore-prefixes nil
  "Prefixes for windows that are not deleted when changing split layout.

You can add an entry here by using the following:
(add-to-list 'spacemacs-window-split-ignore-prefixes \"Buffer prefix\")")

(defvar spacemacs-window-split-delete-function
  'spacemacs/window-split-default-delete
  "Function used to delete other windows when changing layout.

Used as a callback by the following functions:
  - spacemacs/window-split-grid
  - spacemacs/window-split-triple-columns
  - spacemacs/window-split-double-columns
  - spacemacs/window-split-single-column

Possible values:
  - 'spacemacs/window-split-default-delete (default)
  - 'delete-other-windows
  - 'treemacs-delete-other-windows (when using the treemacs package)
  - a lambda: (lambda () (delete-other-windows))
  - a custom function:
    (defun my-delete-other-windows () (delete-other-windows))
    (setq spacemacs-window-split-delete-function 'my-delete-other-windows)")

(defun spacemacs/window-split-grid-2by4 (&optional purge)
  "Set the layout to a 2x4 grid.

Uses the funcion defined in `spacemacs-window-split-delete-function'
as a means to remove windows.

When called with a prefix argument, it uses `delete-other-windows'
as a means to remove windows, regardless of the value in
`spacemacs-window-split-delete-function'."
  (interactive "P")
  (if purge
      (let ((ignore-window-parameters t))
        (delete-other-windows))
    (funcall spacemacs-window-split-delete-function))
  (if (spacemacs--window-split-splittable-windows)
      (let* ((previous-files (seq-filter #'buffer-file-name
                                         (delq (current-buffer) (buffer-list))))
             (second (split-window-right))
             (third (split-window-right))
             (fourth (split-window-right))
             (fifth (split-window-below))
             (sixth (split-window second nil 'below))
             (seventh (split-window third nil 'below))
             (eighth (split-window fourth nil 'below)))
        (set-window-buffer second (or (car previous-files) (dired-jump)))
        (set-window-buffer third (or (cadr previous-files) "*doom:scratch*"))
        (set-window-buffer fourth (or (caddr previous-files) "*doom:scratch*"))
        (set-window-buffer fifth (or (cadddr previous-files) "*doom:scratch*"))
        (set-window-buffer sixth (or (car (cddddr previous-files)) "*doom:scratch*"))
        (set-window-buffer seventh (or (car (cdr (cddddr previous-files))) "*doom:scratch*"))
        (set-window-buffer eighth (or (car (cdr (cdr (cddddr previous-files)))) "*doom:scratch*"))
        (balance-windows))
    (message "There are no main windows available to split!")))

(defun spacemacs/window-split-grid-2by3 (&optional purge)
  "Set the layout to a 2x3 grid.

Uses the funcion defined in `spacemacs-window-split-delete-function'
as a means to remove windows.

When called with a prefix argument, it uses `delete-other-windows'
as a means to remove windows, regardless of the value in
`spacemacs-window-split-delete-function'."
  (interactive "P")
  (if purge
      (let ((ignore-window-parameters t))
        (delete-other-windows))
    (funcall spacemacs-window-split-delete-function))
  (if (spacemacs--window-split-splittable-windows)
      (let* ((previous-files (seq-filter #'buffer-file-name
                                         (delq (current-buffer) (buffer-list))))
             (second (split-window-right))
             (third (split-window-right))
             (fourth (split-window-below))
             (fifth (split-window second nil 'below))
             (sixth (split-window third nil 'below)))
        (set-window-buffer second (or (car previous-files) (dired-jump)))
        (set-window-buffer third (or (cadr previous-files) "*doom:scratch*"))
        (set-window-buffer fourth (or (caddr previous-files) "*doom:scratch*"))
        (set-window-buffer fifth (or (cadddr previous-files) "*doom:scratch*"))
        (set-window-buffer sixth (or (car (cddddr previous-files)) "*doom:scratch*"))
        (balance-windows))
    (message "There are no main windows available to split!")))

(defun spacemacs/window-split-grid (&optional purge)
  "Set the layout to a 2x2 grid.

Uses the funcion defined in `spacemacs-window-split-delete-function'
as a means to remove windows.

When called with a prefix argument, it uses `delete-other-windows'
as a means to remove windows, regardless of the value in
`spacemacs-window-split-delete-function'."
  (interactive "P")
  (if purge
      (let ((ignore-window-parameters t))
        (delete-other-windows))
    (funcall spacemacs-window-split-delete-function))
  (if (spacemacs--window-split-splittable-windows)
      (let* ((previous-files (seq-filter #'buffer-file-name
                                         (delq (current-buffer) (buffer-list))))
             (second (split-window-below))
             (third (split-window-right))
             (fourth (split-window second nil 'right)))
        (set-window-buffer third (or (car previous-files) "*scratch*"))
        (set-window-buffer second (or (cadr previous-files) "*scratch*"))
        (set-window-buffer fourth (or (caddr previous-files) "*scratch*"))
        (balance-windows))
    (message "There are no main windows available to split!")))

(defun spacemacs/window-split-triple-columns (&optional purge)
  "Set the layout to triple columns.

Uses the funcion defined in `spacemacs-window-split-delete-function'
as a means to remove windows.

When called with a prefix argument, it uses `delete-other-windows'
as a means to remove windows, regardless of the value in
`spacemacs-window-split-delete-function'."
  (interactive "P")
  (if purge
      (let ((ignore-window-parameters t))
        (delete-other-windows))
    (funcall spacemacs-window-split-delete-function))
  (if (spacemacs--window-split-splittable-windows)
      (let* ((previous-files (seq-filter #'buffer-file-name
                                         (delq (current-buffer) (buffer-list))))
             (second (split-window-right))
             (third (split-window second nil 'right)))
        (set-window-buffer second (or (car previous-files) "*scratch*"))
        (set-window-buffer third (or (cadr previous-files) "*scratch*"))
        (balance-windows))
    (message "There are no main windows available to split!")))

(defun spacemacs/window-split-double-columns (&optional purge)
  "Set the layout to double columns.

Uses the funcion defined in `spacemacs-window-split-delete-function'
as a means to remove windows.

When called with a prefix argument, it uses `delete-other-windows'
as a means to remove windows, regardless of the value in
`spacemacs-window-split-delete-function'."
  (interactive "P")
  (if purge
      (let ((ignore-window-parameters t))
        (delete-other-windows))
    (funcall spacemacs-window-split-delete-function))
  (if (spacemacs--window-split-splittable-windows)
      (let* ((previous-files (seq-filter #'buffer-file-name
                                         (delq (current-buffer) (buffer-list)))))
        (set-window-buffer (split-window-right)
                           (or (car previous-files) "*scratch*"))
        (balance-windows))
    (message "There are no main windows available to split!")))

(defun spacemacs/window-split-single-column (&optional purge)
  "Set the layout to single column.

Uses the funcion defined in `spacemacs-window-split-delete-function'
as a means to remove windows.

When called with a prefix argument, it uses `delete-other-windows'
as a means to remove windows, regardless of the value in
`spacemacs-window-split-delete-function'."
  (interactive "P")
  (if purge
      (let ((ignore-window-parameters t))
        (delete-other-windows))
    (funcall spacemacs-window-split-delete-function))
  (balance-windows))

;;; ace-window + embark
;; https://karthinks.com/software/fifteen-ways-to-use-embark/
(eval-when-compile
  (defmacro kerthinks/embark-ace-action (fn)
    `(defun ,(intern (concat "kerthinks/embark-ace-" (symbol-name fn))) ()
       (interactive)
       (with-demoted-errors "%s"
         (require 'ace-window)
         (let ((aw-dispatch-always t))
           (aw-switch-to-window (aw-select nil))
           (call-interactively (symbol-function ',fn)))))))

(after! embark
  (define-key embark-file-map     (kbd "C-w") (kerthinks/embark-ace-action find-file))
  (define-key embark-buffer-map   (kbd "C-w") (kerthinks/embark-ace-action switch-to-buffer))
  (define-key embark-bookmark-map (kbd "C-w") (kerthinks/embark-ace-action bookmark-jump)))

;; https://localauthor.github.io/posts/aw-select.html
(map! (:map org-mode-map
       :leader "s C-l" #'link-hint-aw-select))
(defun link-hint-aw-select ()
  "Use avy to open a link in a window selected with ace-window."
  (interactive)
  (unless
      (avy-with link-hint-aw-select
        (link-hint--one :aw-select))
    (message "No visible links")))

(defun link-hint--aw-select-org-link (_link)
  (let ((org-link-frame-setup
         '((file . find-file))))
    (with-demoted-errors "%s"
      (if (and (> (length (aw-window-list)) 1)
               (not (member (org-element-property
                             :type (org-element-context))
                       '("http" "https"))))
          (let ((window (aw-select nil))
                (buffer (current-buffer))
                (new-buffer))
            (org-open-at-point)
            (setq new-buffer
                  (current-buffer))
            (switch-to-buffer buffer)
            (aw-switch-to-window window)
            (switch-to-buffer new-buffer))
        (link-hint-open-link-at-point)))))

(link-hint-define-type 'file-link
  :aw-select #'link-hint--aw-select-file-link)

(defmacro define-link-hint-aw-select (link-type fn)
  `(progn
     (link-hint-define-type ',link-type
       :aw-select #',(intern (concat "link-hint--aw-select-"
                                     (symbol-name link-type))))
     (defun ,(intern (concat "link-hint--aw-select-"
                             (symbol-name link-type))) (_link)
       (with-demoted-errors "%s"
         (if (> (length (aw-window-list)) 1)
             (let ((window (aw-select nil))
                   (buffer (current-buffer))
                   (new-buffer))
               (,fn)
               (setq new-buffer (current-buffer))
               (switch-to-buffer buffer)
               (aw-switch-to-window window)
               (switch-to-buffer new-buffer))
           (link-hint-open-link-at-point))))))

(define-link-hint-aw-select button push-button)
(define-link-hint-aw-select dired-filename dired-find-file)
(define-link-hint-aw-select org-link org-open-at-point)
(link-hint-define-type 'org-link :aw-select #'link-hint--aw-select-org-link)

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

;; elfeed
(map! :map elfeed-search-mode-map
      :e "B" #'ar/elfeed-search-browse-background-url)
  (defun ar/elfeed-search-browse-background-url ()
    "Open current `elfeed' entry (or region entries) in browser without losing focus."
    (interactive)
    (let ((entries (elfeed-search-selected)))
      (mapc (lambda (entry)
              (cl-assert (memq system-type '(darwin)) t "open command is macOS only")
              (start-process (concat "open " (elfeed-entry-link entry))
                             nil "open" "--background" (elfeed-entry-link entry))
              (elfeed-untag entry 'unread)
              (elfeed-search-update-entry entry))
            entries)
      (unless (or elfeed-search-remain-on-entry (use-region-p))
        (forward-line))))

;; vundo
 (use-package! vundo
  :unless (modulep! +tree)
  :custom
  (vundo-glyph-alist     vundo-unicode-symbols)
  (vundo-compact-display t)
  :config
  (when (modulep! :editor evil)
    (map! :map vundo-mode-map
          [remap doom/escape] #'vundo-quit))
  :defer t)

;;; elfeed-tube
 (use-package elfeed-tube
  ;; :ensure t ;; or :straight t
  :after elfeed
  :demand t
  :config
  ;; (setq elfeed-tube-auto-save-p nil) ; default value
  ;; (setq elfeed-tube-auto-fetch-p t)  ; default value
  (elfeed-tube-setup)

  (setq elfeed-tube-captions-languages
        '("ko" "en" "english (auto generated)"))

  :bind (:map elfeed-show-mode-map
         ("F" . elfeed-tube-fetch)
         ([remap save-buffer] . elfeed-tube-save)
         :map elfeed-search-mode-map
         ("F" . elfeed-tube-fetch)
         ([remap save-buffer] . elfeed-tube-save)))

(use-package elfeed-tube-mpv
  ;; :straight (:host github :repo "karthink/elfeed-tube")
  :bind (:map elfeed-show-mode-map
              ("C-c C-f" . elfeed-tube-mpv-follow-mode)
              ("C-c C-w" . elfeed-tube-mpv-where)))

;; (use-package! mu4e
;;   :load-path  "/usr/local/share/emacs/site-lisp/mu/mu4e"
;;     )
;; (add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu/mu4e")
;; (require 'mu4e)

;;; cypher
(use-package! cypher-mode)

;;; yt-dlp

(defvar yt-dlp-video-dir "/Users/yunj/Desktop/Videos/")
(when IS-LINUX
  (setq yt-dlp-video-dir "/home/yunj/Videos/"))

(defun wsl-open-exploer ()
  (interactive)
  (shell-command "explorer.exe ."))

(defun emacs-yt-dlp (&optional link)
  (interactive)
  (let ((fpath (or link (elfeed-get-link-at-point))))
    (async-start-process "yt-dlp" "yt-dlp" nil (concat  "-o" yt-dlp-video-dir "%(title)s-%(id)s.%(ext)s") fpath)
    (message (concat "Starting download: " fpath))
    )
  )

(defun yt-dlp-elfeed ()
  "Download the current entry's Youtube video using `yt-dlp'. "
  (interactive)
  (let ((link (elfeed-entry-link elfeed-show-entry)))
    (when link
      (message "Downloading the Youtube Video: %s" link)
      (emacs-yt-dlp link))))

(map!
 (:map elfeed-show-mode-map
  :n "g C-o" #'yt-dlp-elfeed
  ))

;;; osm
(use-package! osm
  :bind (("C-c m h" . osm-home)
         ("C-c m s" . osm-search)
         ("C-c m v" . osm-server)
         ("C-c m t" . osm-goto)
         ("C-c m x" . osm-gpx-show)
         ("C-c m j" . osm-bookmark-jump))

  :custom
  ;; Take a look at the customization group `osm' for more options.
  (osm-server 'default) ;; Configure the tile server
  (osm-copyright t)     ;; Display the copyright information

  :init
  ;; Load Org link support
  (with-eval-after-load 'org
    (require 'osm-ol))

  :config
  (setq osm-home '(32.5590711 -97.0643973 15))
  )

;;; WSL functions
(defun wsl-open-exploer ()
  (interactive)
  (shell-command "explorer.exe .")
  )

;;; openwith
(when IS-MAC
  ;; (require 'openwith)
  ;; (openwith-mode t)
  ;; (setq openwith-associations '(("\\.pdf\\'" "open -a Skim" (file))))
  )
