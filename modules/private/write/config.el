;;; private/write/config.el -*- lexical-binding: t; -*-

(use-package wordnut
  :commands (wordnut-lookup-current-word
             wordnut-search)
  :hook (wordnut-mode . evil-emacs-state)
  ;; :init
  ;; (progn
  ;;   (global-set-key (kbd "C-c C-s l") 'wordnut-lookup-current-word)
  ;;   (global-set-key (kbd "C-c C-s w") 'wordnut-search)
  ;;   )
  :config
  (setq wordnut-cmd "/usr/local/bin/wn")
  )

;; (use-package! wordnut
;;   :commands (wordnut-search
;;              wordnut-lookup-current-word)
;;   :config
;;   (define-derived-mode wordnut-mode org-mode "WordNut"
;;     "Major mode interface to WordNet lexical database.
;; Turning on wordnut mode runs the normal hook `wordnut-mode-hook'.

;; \\{wordnut-mode-map}"

;;     (setq-local visual-line-fringe-indicators '(nil top-right-angle))
;;     (visual-line-mode 1)

;;     ;; we make a custom imenu index
;;     (setq imenu-generic-expression nil)
;;     (setq-local imenu-create-index-function 'wordnut--imenu-make-index)
;;     (imenu-add-menubar-index)

;;     ;; (setq font-lock-defaults '(wordnut-font-lock-keywords))

;;     ;; if user has adaptive-wrap mode installed, use it
;;     (if (and (fboundp 'adaptive-wrap-prefix-mode)
;;              (boundp 'adaptive-wrap-extra-indent))
;;         (progn
;;           (setq adaptive-wrap-extra-indent 3)
;;           (adaptive-wrap-prefix-mode 1))))
;;   (defun wordnut--format-buffer ()
;;     (let ((inhibit-read-only t)
;;           (case-fold-search nil))
;;       ;; delete the 1st empty line
;;       (goto-char (point-min))
;;       (delete-blank-lines)

;;       ;; make headings
;;       (delete-matching-lines "^ +$" (point-min) (point-max))
;;       (while (re-search-forward
;;               (concat "^" (regexp-opt wordnut-section-headings t) ".* \\(of \\)?\\(\\w+\\) \\(\\w+\\)\n\n.*\\([0-9]+\\) sense.*") nil t)
;;         (replace-match "* \\1 :\\3:\n"))

;;       (goto-char (point-min))
;;       (while (re-search-forward
;;               (concat "^" (regexp-opt wordnut-section-headings t) ".* \\(of \\)?\\(\\w+\\) \\(\\w+\\)") nil t)
;;         (replace-match "* \\1 :\\3:"))

;;       ;; remove empty entries
;;       (goto-char (point-min))
;;       (while (re-search-forward "^\\* .+\n\n\\*" nil t)
;;         (replace-match "*" t t)
;;         ;; back over the '*' to remove next matching lines
;;         (backward-char))

;;       ;; make sections
;;       (goto-char (point-min))
;;       (while (re-search-forward "^Sense \\([0-9]+\\)\n" nil t)
;;         (replace-match "** \\1 "))

;;       ;; remove the last empty entry
;;       (goto-char (point-max))
;;       (if (re-search-backward "^\\* .+\n\\'" nil t)
;;           (replace-match "" t t))

;;       (goto-char (point-min))))
;;   (set-popup-rule! "\\*WordNut" :size 80 :side 'right :select t :quit t)
;;   (map! :map wordnut-mode-map
;;         :nm "<C-return>" (cmd! (osx-dictionary--view-result
;;                                 (substring-no-properties (car wordnut-completion-hist))))
;;         :nm "RET" #'wordnut-lookup-current-word
;;         :nm "q" #'quit-window
;;         :nm "gh" #'wordnut-lookup-current-word))

;; (with-eval-after-load 'synosaurus
;;   ;; (require 'synosaurus-wordnet)
;;   (when IS-MAC
;;     (use-package! osx-dictionary
;;       :commands (osx-dictionary-search-word-at-point
;;                  osx-dictionary-search-input)
;;       :config
;;       (add-hook 'osx-dictionary-mode-hook '+write/buffer-face-mode-dict)
;;       (map! :map osx-dictionary-mode-map
;;             :nm "o"   #'osx-dictionary-open-dictionary.app
;;             :nm "s"   #'osx-dictionary-search-input
;;             :nm "q"   #'osx-dictionary-quit
;;             :nm "RET" #'osx-dictionary-search-word-at-point
;;             :nm "r"   #'osx-dictionary-read-word)
;;       (set-popup-rule! "\\*osx-dictionary" :size 80 :side 'right :select t :quit t))))

(use-package! academic-phrases
  :commands (academic-phrases
             academic-phrases-by-section)
  ;; :init
  ;; (progn
  ;;   (global-set-key (kbd "C-c C-s p") 'academic-phrases)
  ;;   (global-set-key (kbd "C-c C-s s") 'academic-phrases-by-section)
  ;;   )
  )

;; (use-package! wordsmith-mode
;; :commands (wordsmitch-mode))

(after! flycheck
  ;; https://www.macs.hw.ac.uk/~rs46/posts/2018-12-29-stylecheck-flycheck.html
  ;; https://www.cs.umd.edu/~nspring/software/style-check-readme.html
  (flycheck-define-checker style-check
    "A linter for style-check.rb"
    ;; cd /Users/yunj/Dropbox/emacs/style-check/
    ;; make user-install
    ;; ln -s /Users/yunj/Dropbox/emacs/style-check/style-check.rb /usr/local/bin/style-check.rb
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
  (setq flycheck-textlint-config "~/.config/textlint/textlintrc.json")

  ;; enable flycheck for latex
  (add-hook 'LaTeX-mode-hook 'flycheck-mode)
  )

;; https://github.com/agzam/mw-thesaurus.el
(use-package! mw-thesaurus
  ;; (spacemacs/set-leader-keys
  ;;   "xwm" 'mw-thesaurus-lookup-at-point
  ;;   )
  :hook (mw-thesaurus-mode . evil-emacs-state)
  :commands (mw-thesaurus-lookup-at-point)
  :config
  (after! pass
    (setq mw-thesaurus--api-key (password-store-get "mw-thesaurus/api-key")))
  ;; :init
  ;; (global-set-key (kbd "C-c C-s m") 'mw-thesaurus-lookup-at-point)
  ;;Key (Thesaurus):
  ;; (define-key mw-thesaurus-mode-map [remap evil-record-macro] #'mw-thesaurus--quit) ;;q
  ;; (define-key mw-thesaurus-mode-map [remap evil-substitute] #'osx-dictionary-search-input) ;;s
  ;; (define-key mw-thesaurus-mode-map [remap evil-org-delete] #'osx-dictionary-search-pointer) ;;d
  ;; (define-key mw-thesaurus-mode-map [remap evil-forward-char] #'wordnut-lookup-current-word) ;;l
  ;; (define-key mw-thesaurus-mode-map [remap evil-set-marker] #'mw-thesaurus-lookup-at-point) ;;m
  ;; (define-key mw-thesaurus-mode-map [remap evil-forward-word-begin] #'wordnut-search) ;;w
  )

;; https://github.com/gromnitsky/wordnut
;; (use-package wordnut
;; :init
;; (spacemacs/set-leader-keys
;;   "xwl" 'wordnut-lookup-current-word
;;   "xww" 'wordnut-search)
;; :commands (wordnut-lookup-current-word
;; wordnut-search)
;; :bind ("s-x" . synosaurus-choose-and-replace)
;;
;; :config
;; (evilified-state-evilify-map wordnut-mode-map
;;   :mode wordnut-mode
;;   :bindings
;;   "q" 'quit-window
;;   "w" 'wordnut-search
;;   "d" 'osx-dictionary-search-pointer
;;   "m" 'mw-thesaurus-lookup-at-point
;;   "l" 'wordnut-lookup-current-word
;;   "s" 'osx-dictionary-search-input
;;   )
;; )

;; https://github.com/hpdeifel/synosaurus
(use-package synosaurus
  :commands (synosaurus-mode
             synosaurus-lookup
             synosaurus-choose-and-replace)
  ;; :bind ("s-x" . synosaurus-choose-and-replace)
  ;;
  ;; :init
  ;; (progn
  ;;   ;; (global-set-key (kbd "C-c C-s l") 'synosaurus-lookup)
  ;;   (global-set-key (kbd "C-c C-s r") 'synosaurus-choose-and-replace)
  ;;   (global-set-key (kbd "C-c C-s i") 'synosaurus-choose-and-insert)
  ;;   )
  )

;;  (use-package synosaurus-wordnet
;;   :init
;;   :commands (synosaurus-backend-wordnet)
;; ;; synosaurus-backend-wordnet        An english offline thesaurus
;; ;; https://wordnet.princeton.edu
;; ;; $ brew install wordnet # for wn command.
;;   :config
;; (setq synosaurus-backend 'synosaurus-backend-wordnet
;; ;; The way of querying the user for word replacements.
;;       synosaurus-choose-method 'popup))

(after! osx-dictionary
  ;;   :defer t
  ;; :config
  (evil-set-initial-state 'osx-dictionary-mode 'emacs)
  ;; (evilified-state-evilify-map osx-dictionary-mode-map
  ;;   :mode osx-dictionary-mode
  ;;   :bindings
  ;;   "d" 'osx-dictionary-search-pointer
  ;;   "m" 'mw-thesaurus-lookup-at-point
  ;;   "l" 'wordnut-lookup-current-word
  ;;   )
  )

;; See https://github.com/kaz-yos/emacs/blob/master/init.d/500_spell-check-related.el
;; https://emacs.stackexchange.com/questions/21378/spell-check-with-multiple-dictionaries

;; http://blog.binchen.org/posts/what-s-the-best-spell-check-set-up-in-emacs.html
;; find aspell and hunspell automatically
;;

;; add Korean dic for hunspell
;; (add-to-list 'ispell-hunspell-dict-paths-alist
             ;; '("ko" "/Users/yunj/Library/Spelling/ko.aff")
             ;; )
;; (add-to-list 'ispell-hunspell-dictionary-alist '("ko"))

;; (add-to-list 'ispell-hunspell-dict-paths-alist
;;              '("en_US" "/Users/yunj/Library/Spelling/en_US.aff")
;;              )
;; (add-to-list 'ispell-hunspell-dictionary-alist '("en_US"))

;; (add-to-list 'ispell-hunspell-dict-paths-alist
;;              '("en_US-med" "/Users/yunj/Library/Spelling/en_US-med.aff")
;;              )
;; (add-to-list 'ispell-hunspell-dictionary-alist '("en_US-med"))

;; (with-eval-after-load 'ispell
;;   (cond
;;    ;; try hunspell at first
;;    ;; if hunspell does NOT exist, use aspell
;;    ((executable-find "hunspell")
;;     (setq ispell-program-name "hunspell")
;;     (setq ispell-dictionary "en_US,en_US-med")
;;     (setq ispell-dictionary-alist
;;           ;; Please note the list `("-d" "en_US")` contains ACTUAL parameters passed to hunspell
;;           ;; You could use `("-d" "en_US,en_US-med")` to check with multiple dictionaries
;;           ;; '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8))))
;;           '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US,en_US-med") nil utf-8)))
;;     (ispell-set-spellchecker-params)
;;     ;; (setq ispell-personal-dictionary "/Users/yunj/.hunspell_en_US")
;;     (ispell-hunspell-add-multi-dic "en_US,en_US-med")
;;     )

;;    ((executable-find "aspell")
;;     (setq ispell-program-name "aspell")
;;     ;; Please note ispell-extra-args contains ACTUAL parameters passed to aspell
;;     (setq ispell-extra-args '("--sug-mode=ultra" "--lang=en_US"))))
;;   )

;; (setq langtool-mother-tongue nil)
;; ;; Disabled rules pass to LanguageTool.
;; ;; String that separated by comma or list of string.
(after! 'langtool
  (setq langtool-disabled-rules '("WHITESPACE_RULE"
                                  "EN_UNPAIRED_BRACKETS"
                                  "COMMA_PARENTHESIS_WHITESPACE"
                                  "EN_QUOTES"))
  )

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

;; (setq google-translate-default-target-language "ko")

(use-package! mathpix.el
  :commands (mathpix-screenshot)
  ;; :init
  ;; (my-mathpix-password)
  ;; (require 'pass t)
  ;; (map! "C-c n m" #'mathpix-screenshot)
  :custom
  (mathpix-screenshot-method "screencapture -i %s")
  (mathpix-app-id (password-store-get "mathpix/app-id"))
  (mathpix-app-key (password-store-get "mathpix/app-key"))
  )

;; (eval-after-load "mathpix.el"
;;   (setq mathpix-app-id (password-store-get "mathpix/app-id")
;;         mathpix-app-key (password-store-get "mathpix/app-key"))
;;   )

;;; packages.el ends here
