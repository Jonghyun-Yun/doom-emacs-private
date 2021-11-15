;;; ../Dropbox/emacs/.doom.d/local/latex-plus.el -*- lexical-binding: t; -*-

;;; skip ispelling
(with-eval-after-load 'latex
  (setq ispell-tex-skip-alists
        (list
         (append
          (car ispell-tex-skip-alists)
          '(;; First list is used raw.
            ("[^\\]\\$" . "[^\\]\\$")
            ("\\\\cite[a-z*]" ispell-tex-arg-end)
            ("\\\\citealp" ispell-tex-arg-end)
            ("\\\\cref" ispell-tex-arg-end)
            ("\\\\bibliography" ispell-tex-arg-end)
            ("\\\\RequirePackage" ispell-tex-arg-end)
            ;; Second list has key placed inside \\begin{}.
            ("align\\*?"	. "\\\\end[ \t\n]*{[ \t\n]*align\\*?[ \t\n]*}")
            ))
         (cadr ispell-tex-skip-alists)))

  ;; make AUCTeX save files without asking
  (setq TeX-save-query nil)

  ;; define math environment for font-lock
  (setq font-latex-math-environments
        (quote
         ("display" "displaymath" "equation" "eqnarray" "gather" "math" "multline"
          "align" "alignat" "align*" "xalignat" "xxalignat" "flalign")))

  (evil-set-initial-state 'TeX-output-mode 'emacs)
  (evil-set-initial-state 'TeX-special-mode 'emacs)

  )

;; (with-eval-after-load 'company-auctex
;;   (defun company-auctex-labels (command &optional arg &rest ignored)
;;     "company-auctex-labels backend"
;;     (interactive (list 'interactive))
;;     (case command
;;       (interactive (company-begin-backend 'company-auctex-labels))
;;       (prefix (company-auctex-prefix "\\\\?ref{\\([^}]*\\)\\="))
;;       (candidates (company-auctex-label-candidates arg))))

;;   (defun company-auctex-bibs (command &optional arg &rest ignored)
;;     "company-auctex-bibs backend"
;;     (interactive (list 'interactive))
;;     (case command
;;       (interactive (company-begin-backend 'company-auctex-bibs))
;;       (prefix (company-auctex-prefix "\\\\cite?[^[{]*\\(?:\\[[^]]*\\]\\)?{\\([^},]*\\)\\="))
;;       (LaTeX-add-all-bibitems-from-bibtex)
;;       (candidates (company-auctex-bib-candidates arg))))
;;   )

;; (defun get-bibtex-keys (file)
;;   (with-current-buffer (find-file-noselect file)
;;     (mapcar 'car (bibtex-parse-keys))))

;; (defun LaTeX-add-all-bibitems-from-bibtex ()
;;   (interactive)
;;   (mapc 'LaTeX-add-bibitems
;;         (apply 'append
;;                (mapcar 'get-bibtex-keys (reftex-get-bibfile-list)))))

;; Make RefTeX faster
(with-eval-after-load 'reftex
  (setq reftex-save-parse-info t
        reftex-use-multiple-selection-buffers t)
  ;; (evil-set-initial-state 'reftex-select-bib-mode 'emacs)
  ;; prompt for eq labeling
  ;; https://emacs.stackexchange.com/questions/40724/prompts-for-equation-label-information
  (setq reftex-insert-label-flags '("s" t))
  )

;; ;; RefTeX bindings
;; (setq reftex-refstyle "\\cref")
;; (eval-after-load "reftex"
;;   '(progn
;;      (define-key reftex-mode-map (kbd "C-c )")
;;        (lambda ()
;;          (interactive)
;;          (reftex-reference " ")))))

;; ;; Latex PDF viewers and forward/inverse sync
;; (setq TeX-view-program-list
;;       '(("Okular" "okular --unique %o#src:%n`pwd`/./%b")
;;         ("Skim" "displayline -b -g %n %o %b")
;;         ("PDF Tools" TeX-pdf-tools-sync-view)
;;         ("Sumatra PDF" ("\"C:/Program Files/SumatraPDF/SumatraPDF.exe\" -reuse-instance"
;;                         (mode-io-correlate " -forward-search %b %n ") " %o"))
;;         ("Zathura"
;;          ("zathura %o"
;;           (mode-io-correlate
;;            " --synctex-forward %n:0:%b -x \"emacsclient +%{line} %{input}\"")))))

;; ;; system specific pdf viwer
;; (cond
;;  ((string-equal system-type "darwin")
;;   (progn (setq TeX-view-program-selection '((output-pdf "Skim")))))
;;  ((string-equal system-type "gnu/linux")
;;   (progn (setq TeX-view-program-selection '((output-pdf "Okular")))))
;;  ((string-equal system-type "windows-nt")
;;   (progn (setq TeX-view-program-selection '((output-pdf "Sumatra PDF")))))
;;  )

;; to use pdf-tools for AUCTeX
;; (setq TeX-view-program-selection '((output-pdf "PDF Tools")))

;; (setq TeX-source-correlate-start-server t
;;       TeX-source-correlate-mode t
;;       )
;; (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)

;; ;; highlight parenthesis mode
;; (add-hook 'LaTeX-mode-hook 'highlight-parentheses-mode)  ; with AUCTeX LaTeX mode
;; (add-hook 'latex-mode-hook 'highlight-parentheses-mode)  ; with Emacs latex mode

;; ;; rainbow delimiters mode
;; (add-hook 'LaTeX-mode-hook 'rainbow-delimiters-mode)   ; with AUCTeX LaTeX mode
;; (add-hook 'latex-mode-hook 'rainbow-delimiters-mode)   ; with Emacs latex mode

;; for LaTeX inverse sync
;; (server-start) (server has been started by ~/emacs.d/init.el)

;; set default tex engine
;; (setq-default TeX-engine 'default)

;; full-document previews M-m m p
;; (add-hook 'doc-view-mode-hook 'auto-revert-mode)

;; LatexMk to pass the -pdf flag when TeX-PDF-mode is active
;; (setq auctex-latexmk-inherit-TeX-PDF-mode t)

  ;;; cdlatex
;; (add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)   ; with AUCTeX LaTeX mode
;; (add-hook 'latex-mode-hook 'turn-on-cdlatex)   ; with Emacs latex mode

;; ;; cdlatex _ and ^ to auctex _ and ^
;; (defun my-after-load-cdlatex ()
;;   (define-key cdlatex-mode-map "_" nil)
;;   (define-key cdlatex-mode-map "^" nil)
;;   t)
;; (eval-after-load "cdlatex" '(my-after-load-cdlatex))

;; (use-package cdlatex
;;   :defer t
;;   :hook
;;   (LaTeX-mode . cdlatex-mode)
;;   (latex-mode . cdlatex-mode)
;;   :config
;;   (remove-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
;;   ;; Use \( ... \) instead of $ ... $
;;   (setq cdlatex-use-dollar-to-ensure-math nil)
;;   ;; less invasive electric _ and ^
;;   (setq TeX-electric-sub-and-superscript t)
;;   ;; Disabling keys that have overlapping functionality with other parts of Doom
;;   :bind (:map cdlatex-mode-map
;;               ;; This would favor yasnippet’s expansion and cursor movement
;;               ;; over cdlatex’s expansion and movement, but that shouldn’t
;;               ;; matter if you’re not using yasnippet in latex buffers.
;;               ("TAB" . #'cdlatex-tab)
;;               ;; smartparens takes care of inserting closing delimiters, and if you
;;               ;; don't use smartparens you probably won't want these also.
;;               ("$" . nil)
;;               ("(" . nil)
;;               ("{" . nil)
;;               ("[" . nil)
;;               ("|" . nil)
;;               ("<" . nil)
;;               ;; ;; TAB is used for cdlatex's snippets and navigation. But we have
;;               ;; ;; yasnippet for that.
;;               ;; (:when (featurep! :editor snippets)
;;               ;;        :g "TAB" nil)
;;               ;; AUCTeX takes care of auto-inserting {} on _^ if you want, with
;;               ;; `TeX-electric-sub-and-superscript'
;;               ("^" . nil)
;;               ("_" . nil)
;;               ;; AUCTeX already provides this with `LaTeX-insert-item'
;;               ([(control return)] . nil)
;;               ))

(after! latex
;;; latexdiff
  (defun my-latexdiff-init ()
    (require 'latexdiff)
    (local-set-key (kbd "C-c d") 'latexdiff-vc))

  (add-hook 'LaTeX-mode-hook 'my-latexdiff-init)
  ;; (add-hook 'latex-mode-hook 'my-latexdiff-init)
  ;;   (map!
  ;;    :map LaTeX-mode-map
  ;;    :ei [C-return] #'LaTeX-insert-item)
  (setq TeX-electric-math '("\\(" . ""))
  ;;; tex-fold
  (setcar (assoc "⋆" LaTeX-fold-math-spec-list) "★") ;; make \star bigger
  (setq TeX-fold-math-spec-list
        `(
          ;; private macros
          ("ℝ" ("RR"))
          ("ℕ" ("NN"))
          ("ℤ" ("ZZ"))
          ("ℚ" ("QQ"))
          ("ℂ" ("CC"))
          ("ℙ" ("PP"))
          ("ℍ" ("HH"))
          ("𝔼" ("EE"))
          ("𝑑" ("dd"))
          ;; mathbb
          ("ℝ" ("mathbb{R}"))
          ("ℕ" ("mathbb{N}"))
          ("ℤ" ("mathbb{Z}"))
          ("ℚ" ("mathbb{Q}"))
          ("ℂ" ("mathbb{C}"))
          ("ℙ" ("mathbb{P}"))
          ("ℍ" ("mathbb{H}"))
          ("𝔼" ("mathbb{E}"))
          ("𝑑" ("mathbb{d}"))

          ;; known commands
          ;; ("" ("phantom"))
          ;; (,(lambda (num den) (if (and (TeX-string-single-token-p num) (TeX-string-single-token-p den))
          ;;                        (concat num "／" den)
          ;;                      (concat "❪" num "／" den "❫"))) ("frac"))
          ;; (,(lambda (arg) (concat "√" (TeX-fold-parenthesize-as-necessary arg))) ("sqrt"))
          ;; (,(lambda (arg) (concat "⭡" (TeX-fold-parenthesize-as-necessary arg))) ("vec"))
          ;; ("‘{1}’" ("text"))
          ;; private commands
          ("|{1}|" ("abs"))
          ("‖{1}‖" ("norm"))
          ("⌊{1}⌋" ("floor"))
          ("⌈{1}⌉" ("ceil"))
          ;; ("⌊{1}⌉" ("round"))
          ("𝑑{1}/𝑑{2}" ("dv"))
          ("∂{1}/∂{2}" ("pdv"))
          ;; fancification
          ;; ("{1}" ("mathrm"))
          ;; (,(lambda (word) (string-offset-roman-chars 119743 word)) ("mathbf"))
          ;; (,(lambda (word) (string-offset-roman-chars 119951 word)) ("mathcal"))
          ;; (,(lambda (word) (string-offset-roman-chars 120003 word)) ("mathfrak"))
          ;; (,(lambda (word) (string-offset-roman-chars 120055 word)) ("mathbb"))
          ;; (,(lambda (word) (string-offset-roman-chars 120159 word)) ("mathsf"))
          ;; (,(lambda (word) (string-offset-roman-chars 120367 word)) ("mathtt"))
          )
        TeX-fold-macro-spec-list
        '(
          ;; as the defaults
          ("[f]" ("footnote" "marginpar"))
          ("[c]" ("cite"))
          ("[l]" ("label"))
          ("[r]" ("ref" "pageref" "eqref"))
          ("[i]" ("index" "glossary"))
          ("..." ("dots"))
          ;; tweaked defaults
          ("©" ("copyright"))
          ("®" ("textregistered"))
          ("™"  ("texttrademark"))
          ("[1]:||►" ("item"))
          ("❡❡ {1}" ("part" "part*"))
          ("❡ {1}" ("chapter" "chapter*"))
          ("§ {1}" ("section" "section*"))
          ("§§ {1}" ("subsection" "subsection*"))
          ("§§§ {1}" ("subsubsection" "subsubsection*"))
          ("¶ {1}" ("paragraph" "paragraph*"))
          ("¶¶ {1}" ("subparagraph" "subparagraph*"))
          )))


;; Making \( \) less visible
;; (defface unimportant-latex-face
;;   '((t :inherit font-lock-comment-face :weight extra-light))
;;   "Face used to make \\(\\), \\[\\] less visible."
;;   :group 'LaTeX-math)

;; (font-lock-add-keywords
;;  'latex-mode
;;  `((,(rx (and "\\" (any "()[]"))) 0 'unimportant-latex-face prepend))
;;  'end)

;; (font-lock-add-keywords
;;  'latex-mode
;;  `((,"\\\\[[:word:]]+" 0 'font-lock-keyword-face prepend))
;;  'end)

;;; orgtbl mode
;; https://github.com/karthink/lazytab
;; (after! latex
  ;; (load! "~/.doom.d/local/lazytab/lazytab.el"))
