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
