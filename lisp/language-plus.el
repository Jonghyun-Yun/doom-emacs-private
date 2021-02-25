;;; packages.el --- language-plus layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Jonghyun Yun <yunj@MacBook.Jonghyun>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `language-plus-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `language-plus/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `language-plus/pre-init-PACKAGE' and/or
;;   `language-plus/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst language-plus-packages
  '(
    mw-thesaurus
    wordnut
    synosaurus
    flycheck
    osx-dictionary
    )
  "The list of Lisp packages required by the language-plus layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")


(defun language-plus/post-init-flycheck ()
  (use-package flycheck
    :config
    ;; https://www.macs.hw.ac.uk/~rs46/posts/2018-12-29-stylecheck-flycheck.html
    ;; https://www.cs.umd.edu/~nspring/software/style-check-readme.html
    (flycheck-define-checker style-check
      "A linter for style-check.rb"
      ;; ln -s ~/.spacemacs.d/lisp/style-check-0.14/style-check.rb /usr/local/bin/style-check.rb
      :command ("style-check.rb"
                source-inplace)
      :error-patterns
      ((warning line-start (file-name) ":" line ":" column ": "
                (message (one-or-more not-newline)
                         (zero-or-more "\n" (any " ") (one-or-more not-newline)))
                line-end))
      :modes latex-mode
      )

    ;; https://github.com/fikovnik/dotfiles/blob/master/.emacs.d/config.org#create-a-wrapper
    ;; https://github.com/sylvainhalle/textidote
    (flycheck-define-checker textidote
      "My latex checker"
      :command
      ("~/Dropbox/emacs/textidote-wrapper.sh" source)
      :error-patterns
      ((warning line-start (file-name) ":" line ":" column ": [" (id (1+ (not (any "]")))) "] " (message) line-end))
      :modes
      (latex-mode))
    
    ;; style-check
    (add-to-list 'flycheck-checkers 'style-check)
    ;; textidote and languagetool
    (add-to-list 'flycheck-checkers 'textidote)
    ;; texlint
    ;; https://www.macs.hw.ac.uk/~rs46/posts/2018-12-29-textlint-flycheck.html
    ;; https://github.com/kisaragi-hiu/flycheck-textlint
    (add-to-list 'flycheck-textlint-plugin-alist '(tex-mode . "latex"))
    (setq-default flycheck-textlint-config "~/.config/textlint/textlintrc.json")

    ;; enable flycheck for latex
    (add-hook 'latex-mode-hook 'flycheck-mode)
    (add-hook 'LaTeX-mode-hook 'flycheck-mode)
    ))

;; https://github.com/agzam/mw-thesaurus.el
(defun language-plus/init-mw-thesaurus ()
  (use-package mw-thesaurus
    :init
    (spacemacs/set-leader-keys
      "xwm" 'mw-thesaurus-lookup-at-point
      )
    :commands (mw-thesaurus-lookup-at-point)
    :config
    ;;Key (Thesaurus):
    (setq mw-thesaurus--api-key "40bf8bb6-e1d6-47d1-a7e6-34333111b760")
    (define-key mw-thesaurus-mode-map [remap evil-record-macro] #'mw-thesaurus--quit) ;;q
    (define-key mw-thesaurus-mode-map [remap evil-substitute] #'osx-dictionary-search-input) ;;s
    (define-key mw-thesaurus-mode-map [remap evil-org-delete] #'osx-dictionary-search-pointer) ;;d
    ;; (define-key mw-thesaurus-mode-map [remap evil-forward-char] #'wordnut-lookup-current-word) ;;l
    (define-key mw-thesaurus-mode-map [remap evil-set-marker] #'mw-thesaurus-lookup-at-point) ;;m
    (define-key mw-thesaurus-mode-map [remap evil-forward-word-begin] #'wordnut-search) ;;w
    ))

;; https://github.com/gromnitsky/wordnut
(defun language-plus/init-wordnut ()
  (use-package wordnut
    :init
    (spacemacs/set-leader-keys
      "xwl" 'wordnut-lookup-current-word
      "xww" 'wordnut-search)
    :commands (wordnut-lookup-current-word
               wordnut-search)
    ;; :bind ("s-x" . synosaurus-choose-and-replace)
    ;;
    :config
    (evilified-state-evilify-map wordnut-mode-map
      :mode wordnut-mode
      :bindings
      "q" 'quit-window
      "w" 'wordnut-search
      "d" 'osx-dictionary-search-pointer
      "m" 'mw-thesaurus-lookup-at-point
      "l" 'wordnut-lookup-current-word
      "s" 'osx-dictionary-search-input
      ))
  )

(defun language-plus/init-synosaurus ()
  ;; https://github.com/hpdeifel/synosaurus
  (use-package synosaurus
    :init
    :commands (synosaurus-mode
               synosaurus-lookup
               synosaurus-choose-and-replace)
    ;; :bind ("s-x" . synosaurus-choose-and-replace)
    ;;
    :config
    (progn
      (global-set-key (kbd "C-c C-s l") 'synosaurus-lookup)
      (global-set-key (kbd "C-c C-s r") 'synosaurus-choose-and-replace)
      (global-set-key (kbd "C-c C-s i") 'synosaurus-choose-and-insert)
      )
    (use-package synosaurus-wordnet
      :init
      :commands (synosaurus-backend-wordnet))
    ;; synosaurus-backend-wordnet        An english offline thesaurus
    ;; https://wordnet.princeton.edu
    ;; $ brew install wordnet # for wn command.
    (setq-default synosaurus-backend 'synosaurus-backend-wordnet)
    ;;
    ;; The way of querying the user for word replacements.
    (setq-default synosaurus-choose-method 'popup))
  )

(defun language-plus/post-init-osx-dictionary ()
  (use-package osx-dictionary
    ;;   :defer t
    :config
    (evilified-state-evilify-map osx-dictionary-mode-map
      :mode osx-dictionary-mode
      :bindings
      "d" 'osx-dictionary-search-pointer
      "m" 'mw-thesaurus-lookup-at-point
      "l" 'wordnut-lookup-current-word
      )

  ;;  (evilified-state-evilify-map osx-dictionary-mode-map
  ;;   :mode osx-dictionary-mode
  ;;   :eval-after-load osx-dictionary
  ;;   :bindings
  ;;   "d" 'osx-dictionary-search-pointer
  ;;   "m" 'mw-thesaurus-lookup-at-point
  ;;   "l" 'wordnut-lookup-current-word)
    ))

;; See https://github.com/kaz-yos/emacs/blob/master/init.d/500_spell-check-related.el
;; https://emacs.stackexchange.com/questions/21378/spell-check-with-multiple-dictionaries

;; http://blog.binchen.org/posts/what-s-the-best-spell-check-set-up-in-emacs.html
;; find aspell and hunspell automatically
(with-eval-after-load 'ispell
  (cond
   ;; try hunspell at first
   ;; if hunspell does NOT exist, use aspell
   ((executable-find "hunspell")
    (setq ispell-program-name "hunspell")
    (setq ispell-dictionary "en_US,en_US-med")
    (setq ispell-dictionary-alist
          ;; Please note the list `("-d" "en_US")` contains ACTUAL parameters passed to hunspell
          ;; You could use `("-d" "en_US,en_US-med")` to check with multiple dictionaries
          ;; '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8))))
          '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US,en_US-med") nil utf-8)))
    (ispell-set-spellchecker-params)
    ;; (setq ispell-personal-dictionary "/Users/yunj/.hunspell_en_US")
    (ispell-hunspell-add-multi-dic "en_US,en_US-med")
    )

   ((executable-find "aspell")
    (setq ispell-program-name "aspell")
    ;; Please note ispell-extra-args contains ACTUAL parameters passed to aspell
    (setq ispell-extra-args '("--sug-mode=ultra" "--lang=en_US"))))
  )

  ;; (setq langtool-mother-tongue nil)
  ;; ;; Disabled rules pass to LanguageTool.
  ;; ;; String that separated by comma or list of string.
  (setq langtool-disabled-rules '("WHITESPACE_RULE"
                                  "EN_UNPAIRED_BRACKETS"
                                  "COMMA_PARENTHESIS_WHITESPACE"
                                  "EN_QUOTES"))

  ;; ;; Show LanguageTool report automatically by popup.
  ;; ;; This idea come from: http://d.hatena.ne.jp/LaclefYoshi/20150912/langtool_popup
  ;; (defun langtool-autoshow-detail-popup (overlays)
  ;;   (when (require 'popup nil t)
  ;;     ;; Do not interrupt current popup
  ;;     (unless (or popup-instances
  ;;                 ;; suppress popup after type `C-g` .
  ;;                 (memq last-command '(keyboard-quit)))
  ;;       (let ((msg (langtool-details-error-message overlays)))
  ;;         (popup-tip msg)))))
  ;; (setq langtool-autoshow-message-function 'langtool-autoshow-detail-popup)

(setq google-translate-default-target-language "ko")

;;; packages.el ends here
