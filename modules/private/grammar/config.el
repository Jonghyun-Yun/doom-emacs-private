;;; checkers/grammar/config.el -*- lexical-binding: t; -*-

(use-package! langtool
  :commands (langtool-check
             langtool-check-done
             langtool-show-message-at-point
             langtool-correct-buffer)
  :init (setq langtool-default-language "en-US")
  :config
  (unless (or langtool-bin
              langtool-language-tool-jar
              langtool-java-classpath
              langtool-language-tool-server-jar)
    (cond (IS-MAC
           (cond
            ;; is user using home brew?
            ((file-directory-p "/usr/local/Cellar/languagetool")
             (setq langtool-language-tool-jar
                   (locate-file "libexec/languagetool-commandline.jar"
                                (doom-files-in "/usr/local/Cellar/languagetool"
                                               :type 'dirs
                                               :depth 2))))
            ;; macports compatibility
            ((file-directory-p "/opt/local/share/java/LanguageTool")
             (setq langtool-java-classpath "/opt/local/share/java/LanguageTool/*"))))
          (IS-LINUX
           (setq langtool-java-classpath "/usr/share/languagetool:/usr/share/java/languagetool/*"))))

  ;; ARROWS: fix -> to a real arrow
  ;; EN_QUOTES: fix "..." to smart quotes
  (setq-default langtool-disabled-rules '("WHITESPACE_RULE" "ARROWS" "EN_QUOTES"
                                          "EN_UNPAIRED_BRACKETS" "COMMA_PARENTHESIS_WHITESPACE"))

  ;; to run n-grams for confusion wrods. `en' sub-directory is required
  ;; see https://dev.languagetool.org/finding-errors-using-n-gram-data.html
  (setq langtool-user-arguments '("--languagemodel" "/Users/yunj/.config/languagetool/languagemodel/"))
  (setq langtool-server-user-arguments '("-p" "8081" "--allow-origin" "\"*\"" "--languageModel" "/Users/yunj/.config/languagetool/languagemodel/"))

  ;;; to run langtool for org-/latex-mode buffers
  ;; https://github.com/redguardtoo/Emacs-langtool
  ;; not working in latex-mode, server not working
  ;; (add-hook 'org-mode-hook #'jyun/langtool-org-exclude-faces)
  ;; (add-hook 'LaTeX-mode-hook #'jyun/langtool-latex-exclude-faces)

  (define-key evil-normal-state-map (kbd "[ g")
    #'jyun/langtool-goto-previous-error)
  (define-key evil-normal-state-map (kbd "] g")
    #'jyun/langtool-goto-next-error)

  (setq langtool-autoshow-message-function
        ;; display in a minibuffer
        ;; 'langtool-autoshow-force-message
        ;; display in a popup
        'langtool-autoshow-detail-popup
        )
  )

(defvar languagetool-show-error-on-jump nil
  "If non-nil, automatically show a popup with the error when
  jumping to LanguageTool errors with '[ g' and '] g'.")

;; https://github.com/cjl8zf/langtool-ignore-fonts
(use-package langtool-ignore-fonts
  :defer t
  :after langtool
  )

;; Detects weasel words, passive voice and duplicates. Proselint would be a
;; better choice.
(use-package! writegood-mode
  :hook (org-mode markdown-mode rst-mode asciidoc-mode latex-mode)
  :config
  (map! :localleader
        :map writegood-mode-map
        "g" #'writegood-grade-level
        "r" #'writegood-reading-ease))
