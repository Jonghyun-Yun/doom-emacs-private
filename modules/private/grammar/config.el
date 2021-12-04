;;; checkers/grammar/config.el -*- lexical-binding: t; -*-

;; (setq langtool-bin "languagetool")
;; (setq langtool-language-tool-server-jar "/usr/local/Cellar/languagetool/5.4/libexec/languagetool-server.jar")
;; (setq langtool-language-tool-server-jar (concat
;;  (file-name-directory
;;   (directory-file-name
;;    (file-name-directory
;;     (directory-file-name (file-truename "/usr/local/bin/languagetool"))))) "libexec/languagetool-server.jar"))
;; (setq langtool-http-server-host "localhost"
;;       langtool-http-server-port 8081)

(setq langtool-language-tool-server-jar
      (when (file-directory-p "/usr/local/Cellar/languagetool")
        (setq langtool-language-tool-jar
              (locate-file "libexec/languagetool-server.jar"
                           (doom-files-in "/usr/local/Cellar/languagetool"
                                          :type 'dirs
                                          :depth 2)))))

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
  )

(use-package! langtool-posframe
  :after langtool
  :config
   (setq langtool-autoshow-message-function
        ;; display in a minibuffer
        ;; 'langtool-autoshow-force-message
        ;; display in a popup
        ;; 'langtool-autoshow-detail-popup
        ;; posframe
        'langtool-posframe-show-posframe
        )
  (after! company
    ;; Don't display popups if company is open
    (add-hook 'langtool-posframe-inhibit-functions #'company--active-p))
  (after! evil
    ;; Don't display popups while in insert or replace mode, as it can affect
    ;; the cursor's position or cause disruptive input delays.
    (add-hook! 'langtool-posframe-inhibit-functions
               #'evil-insert-state-p
               #'evil-replace-state-p))
  )

(defvar languagetool-show-error-on-jump nil
  "If non-nil, automatically show a popup with the error when
  jumping to LanguageTool errors with '[ g' and '] g'.")

;; https://github.com/cjl8zf/langtool-ignore-fonts
(use-package! langtool-ignore-fonts
  ;; :after langtool
  :hook
  (latex-mode . langtool-ignore-fonts-minor-mode)
  (org-mode . langtool-ignore-fonts-minor-mode)
  (markdown-mode . langtool-ignore-fonts-minor-mode)
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
