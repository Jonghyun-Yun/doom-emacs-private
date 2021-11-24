;;; private/write/config.el -*- lexical-binding: t; -*-

(use-package wordnut
  :defer t
  :commands (wordnut-lookup-current-word
             wordnut-search)
  :hook (wordnut-mode . evil-emacs-state)
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
  :defer t
  :commands (academic-phrases
             academic-phrases-by-section)
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
    ("~/Dropbox/emacs/textidote/textidote-wrapper.sh" source)
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
  ;; (add-hook 'LaTeX-mode-hook 'flycheck-mode)

  (flycheck-define-checker tex-textidote
    "A LaTeX grammar/spelling checker using textidote.

    See https://github.com/sylvainhalle/textidote"
    :modes (latex-mode plain-tex-mode)
    :command ("java" "-jar" (eval (expand-file-name "~/Dropbox/emacs/textidote/textidote.jar")) "--read-all"
              "--check" (eval (if ispell-current-dictionary (substring ispell-current-dictionary 0 2) "en"))
              "--dict" (eval (expand-file-name ispell-personal-dictionary))
              "--no-color" source-inplace)
    :error-patterns
    ((warning line-start "* L" line "C" column "-" (one-or-more alphanumeric) " "
              (message (one-or-more (not (any "]"))) "]")))
    )

  ;; add tex-textidote
  (add-to-list 'flycheck-checkers 'tex-textidote)
  )

;; https://github.com/agzam/mw-thesaurus.el
(use-package! mw-thesaurus
  :defer t
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

;; https://github.com/hpdeifel/synosaurus
(use-package synosaurus
  :defer t
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

(use-package! mathpix.el
  :defer t
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

;;; string-inflection
(use-package! string-inflection
  :defer t
  :commands
  (my-hydra-string-inflection/body)
  :init
  (progn
    (defhydra my-hydra-string-inflection
      (:hint nil)
      "
[_i_] cycle"
      ("i" string-inflection-all-cycle)
      )
    (map!
     :leader
     (:prefix ("zi" . "inflection")
      "c" 'string-inflection-lower-camelcase
      "C" 'string-inflection-camelcase
      :desc "String Inflection Hydra" "i" 'my-hydra-string-inflection/body
      "-" 'string-inflection-kebab-case
      "k" 'string-inflection-kebab-case
      "_" 'string-inflection-underscore
      "u" 'string-inflection-underscore
      "U" 'string-inflection-upcase))))

;;; spell
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

(require 'spell-fu) ;; otherwise error b/c `+spell/previous-error' is not defined.
(setq spell-fu-idle-delay 0.5)
;; (global-spell-fu-mode -1)

;; I need these lists for langtool!
(setf (alist-get 'org-mode +spell-excluded-faces-alist)
      '(
        org-level-1
        org-document-info
        org-list-dt
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

(setf (alist-get 'LaTeX-mode +spell-excluded-faces-alist)
      '(
        font-lock-function-name-face
        font-lock-variable-name-face
        font-lock-keyword-face
        font-lock-constant-face
        font-lock-comment-face
        font-latex-math-face
        font-latex-sedate-face))
;; font-latex-verbatim-face
;; font-latex-warning-face

;; these exculeded faces are in lists for spell-fu
(add-hook 'org-mode-hook (defun langtool-org-mode-ignore-fonts ()
                             (setq-local langtool-ignore-fonts
                                         (alist-get 'org-mode +spell-excluded-faces-alist))
                             ))
(add-hook 'markdown-mode-hook (defun langtool-markdown-ignore-fonts ()
                                (setq-local langtool-ignore-fonts
                                            (alist-get 'markdown-mode +spell-excluded-faces-alist))))
(add-hook 'LaTeX-mode-hook (defun langtool-LaTeX-ignore-fonts ()
                             (setq-local langtool-ignore-fonts
                                         (alist-get 'LaTeX-mode +spell-excluded-faces-alist))))

;;; mw-dict
(use-package! mw-learner
  :defer t
  :commands (mw-learner-lookup-at-point))
(use-package! mw-collegiate
  :defer t
  :commands (mw-collegiate-lookup-at-point))

;;; packages.el ends here
