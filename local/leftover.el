;;; ../Dropbox/emacs/.doom.d/local/leftover.el -*- lexical-binding: t; -*-

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
;; (when (modulep! :tools debugger +lsp)
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
;;; svg-tag
;; (progn
;;   (defface font-svg-tag-tags
;;     '((t (:family "Roboto Slab" :weight light)))
;;     "TODO"
;;     :group 'basic-faces)
;;   (use-package! svg-tag-mode
;;     :init
;;     (add-hook! '(org-mode-hook) #'svg-tag-mode)
;;     :commands (svg-tag-mode global-svg-tag-mode)
;;     :config
;;     (defconst date-re "[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}")
;;     (defconst time-re "[0-9]\\{2\\}:[0-9]\\{2\\}")
;;     (defconst day-re "[A-Za-z]\\{3\\}")
;;     (defun svg-progress-percent (value)
;;       (svg-image (svg-lib-concat
;;                   (svg-lib-progress-bar (/ (string-to-number value) 100.0)
;;                                         nil :margin 0 :stroke 2 :radius 3 :padding 2 :width 11)
;;                   (svg-lib-tag (concat value "%")
;;                                nil :stroke 0 :margin 0)) :ascent 'center))
;;     (defun svg-progress-count (value)
;;       (let* ((seq (mapcar #'string-to-number (split-string value "/")))
;;              (count (float (car seq)))
;;              (total (float (cadr seq))))
;;         (svg-image (svg-lib-concat
;;                     (svg-lib-progress-bar (/ count total) nil
;;                                           :margin 0 :stroke 2 :radius 3 :padding 2 :width 11)
;;                     (svg-lib-tag value nil
;;                                  :stroke 0 :margin 0)) :ascent 'center)))
;;     (setq svg-tag-tags
;;           `(
;;             ;; Task priority
;;             ("\\[#[A-Z]\\]" . ( (lambda (tag)
;;                                   (svg-tag-make tag :face 'org-priority
;;                                                 :beg 2 :end -1 :margin 0))))
;;             ;; TODO / DONE
;;             ("TODO" . ((lambda (tag) (svg-tag-make "TODO" :face 'org-todo :inverse t :margin 0))))
;;             ("DONE" . ((lambda (tag) (svg-tag-make "DONE" :face 'org-done :margin 0))))
;;             ("NEXT" . ((lambda (tag) (svg-tag-make "NEXT" :face '+org-todo-next :margin 0))))
;;             ("HOLD" . ((lambda (tag) (svg-tag-make "HOLD" :face '+org-todo-hold :margin 0))))
;;             ("IDEA" . ((lambda (tag) (svg-tag-make "IDEA" :face '+org-todo-idea :margin 0))))
;;             ("WAIT" . ((lambda (tag) (svg-tag-make "WAIT" :face '+org-todo-wait :margin 0))))
;;             ("KILL" . ((lambda (tag) (svg-tag-make "KILL" :face '+org-todo-kill :margin 0))))
;;             ;; Org @tags
;;             ("\\(:@[A-Za-z0-9]+\\)" . ((lambda (tag) (svg-tag-make tag :beg 1 :face 'org-tag))))
;;             ("\\(:@[A-Za-z0-9]+:\\)$" . ((lambda (tag) (svg-tag-make tag :beg 1 :end -1 :face 'org-tag))))
;;             ;; ;; Org tags
;;             ;; (":\\([A-Za-z0-9]+\\)" . ((lambda (tag) (svg-tag-make tag :face 'org-tag))))
;;             ;; (":\\([A-Za-z0-9]+[ \-]\\)" . ((lambda (tag) tag)))
;;             ;; (,(format "%s" time-re) . ((lambda (tag) tag)))
;;             ;; ;; Active date (with day name, with or without time)
;;             ;; (,(format "\\(<%s %s>\\)" date-re day-re) .
;;             ;;  ((lambda (tag)
;;             ;;     (svg-tag-make tag :beg 1 :end -1 :margin 0))))
;;             ;; (,(format "\\(<%s %s *\\)%s>" date-re day-re time-re) .
;;             ;;  ((lambda (tag)
;;             ;;     (svg-tag-make tag :beg 1 :inverse nil :crop-right t :margin 0))))
;;             ;; (,(format "<%s %s *\\(%s>\\)" date-re day-re time-re) .
;;             ;;  ((lambda (tag)
;;             ;;     (svg-tag-make tag :end -1 :inverse t :crop-left t :margin 0))))
;;             ;; ;; Inactive date  (with day name, with or without time)
;;             ;; (,(format "\\(\\[%s %s\\]\\)" date-re day-re) .
;;             ;;  ((lambda (tag)
;;             ;;     (svg-tag-make tag :beg 1 :end -1 :margin 0 :face 'org-date))))
;;             ;; (,(format "\\(\\[%s %s *\\)%s\\]" date-re day-re time-re) .
;;             ;;  ((lambda (tag)
;;             ;;     (svg-tag-make tag :beg 1 :inverse nil :crop-right t :margin 0 :face 'org-date))))
;;             ;; (,(format "\\[%s %s *\\(%s\\]\\)" date-re day-re time-re) .
;;             ;;  ((lambda (tag)
;;             ;;     (svg-tag-make tag :end -1 :inverse t :crop-left t :margin 0 :face 'org-date))))
;;             ))))
;;; Tab-bar
;; (use-package! tab-bar
;;   :if (not (version-list-<
;;             (version-to-list emacs-version)
;;             '(27 0 1 0)))
;;   ;; :after cus-face
;;   :commands (tab-bar-mode)
;;   :bind-keymap ("H-t" . tab-prefix-map)
;;   :bind
;;   (("C-M-<tab>" . tab-bar-switch-to-next-tab)
;;    ("C-M-S-<tab>" . tab-bar-switch-to-prev-tab)
;;    ("H-<tab>" . tab-bar-switch-to-next-tab)
;;    ("H-<iso-lefttab>" . tab-bar-switch-to-prev-tab)
;;    ("s-u" . tab-bar-history-back)
;;    ("C-c u" . tab-bar-history-back)
;;    ("s-S-U" . tab-bar-history-forward)
;;    :map tab-prefix-map
;;    ("h" . my/tab-bar-show-hide-tabs)
;;    ("H-t" . tab-bar-select-tab-by-name))
;;   :config
;;   (tab-bar-history-mode 1)
;;   (setq  tab-bar-close-last-tab-choice 'tab-bar-mode-disable
;;          tab-bar-show                   1
;;          tab-bar-tab-name-truncated-max 14
;;          tab-bar-new-tab-choice        'ibuffer
;;          ;; tab-bar-tab-name-function '(lambda nil
;;          ;;                              "Use directory as tab name."
;;          ;;                              (let ((dir (expand-file-name
;;          ;;                                          (or (if (fboundp 'project-root)
;;          ;;                                                  (project-root (project-current)))
;;          ;;                                              default-directory))))
;;          ;;                                (substring dir (1+ (string-match "/[^/]+/$" dir)) -1 )))
;;          ;; tab-bar-select-tab-modifiers  '(meta)
;;          ;; tab-bar-tab-name-function 'tab-bar-tab-name-truncated
;;          ;; tab-bar-tab-name-function '(lambda nil (upcase (tab-bar-tab-name-truncated)))
;;          tab-bar-close-button-show nil
;;          )
;;   (defun my/tab-bar-show-hide-tabs ()
;;     "Show or hide tabs."
;;     (interactive)
;;     (setq tab-bar-show (if tab-bar-show nil 1)))
;;   (custom-set-faces
;;   '(tab-bar ((t (:height 1.0))))
;;   '(tab-bar-tab-inactive ((t (:inherit tab-bar :weight light))))
;;   ;; '(tab-bar-tab ((t (:inherit variable-pitch :background "#ffffff" :underline t :height 0.95)))))
;;   '(tab-bar-tab ((t (:inherit tab-bar :background "#ffffff" :underline t :height 1.0))))
;;   )
;;   ;; (advice-add 'tab-bar-rename-tab
;;   ;;             :after
;;   ;;             (defun +tab-bar-name-upcase (_name &optional _arg)
;;   ;;               "Upcase current tab name"
;;   ;;               (let* ((tab (assq 'current-tab (frame-parameter nil 'tabs)))
;;   ;;                      (tab-name (alist-get 'name tab)))
;;   ;;                 (setf (alist-get 'name tab) (upcase tab-name)
;;   ;;                       (alist-get 'explicit-name tab) t))
;;   ;;               ))
;;   )
;; (use-package! tab-bar-echo-area
;;   :ensure
;;   :demand
;;   :after tab-bar
;;   :init
;;   (defvar tab-bar-format nil "Format for tab-bar-echo-area-mode")
;;   :config
;;   (tab-bar-echo-area-mode 1)
;;   (add-to-list 'tab-bar-format #'tab-bar-format-menu-bar)
;;   :bind (:map tab-prefix-map
;;               ("c" . tab-bar-echo-area-display-tab-name)
;;               ("P" . tab-bar-echo-area-display-tab-names)))
;; (use-package! tab-bar-groups
;;   :ensure
;;   :after tab-bar
;;   :config
;;   (tab-bar-groups-activate))
;;; vertico extension
;; karthink
;; https://www.reddit.com/r/emacs/comments/ryqfz1/vertico_extensions_demo/
;; (vertico-indexed-mode)
;; (use-package! vertico-quick
;;   ;; :load-path "~/.local/share/git/vertico/extensions/"
;;   :after vertico
;;   :bind (:map vertico-map
;;          ("M-i" . vertico-quick-insert)
;;          ("C-'" . vertico-quick-exit)
;;          ("C-o" . vertico-quick-embark))
;;   :config
;;   (defun vertico-quick-embark (&optional arg)
;;     "Embark on candidate using quick keys."
;;     (interactive)
;;     (when (vertico-quick-jump)
;;       (embark-act arg))))

;; (use-package! vertico-directory
;;   :after vertico
;;   :ensure nil
;;   ;; More convenient directory navigation commands
;;   :bind (:map vertico-map
;;          ;; ("RET" . vertico-directory-enter)
;;          ("DEL" . vertico-directory-delete-char)
;;          ("M-DEL" . vertico-directory-delete-word)
;;          )
;;   ;; Tidy shadowed file names
;;   :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))


;;; turbo-log
;; (use-package! turbo-log
;;   :bind (("C-s-l" . turbo-log-print)
;;          ("C-s-i" . turbo-log-print-immediately)
;;          ("C-s-h" . turbo-log-comment-all-logs)
;;          ("C-s-s" . turbo-log-uncomment-all-logs)
;;          ("C-s-[" . turbo-log-paste-as-logger)
;;          ("C-s-]" . turbo-log-paste-as-logger-immediately)
;;          ("C-s-x" . turbo-log-delete-all-logs))
;;   :config
;;   (setq turbo-log-msg-format-template "\"🚀: %s\"")
;;   (setq turbo-log-allow-insert-without-tree-sitter-p t))

;;; show diff between init.example.el and .doom.d/init.el
;; https://github.com/hlissner/doom-emacs/issues/581
;; (defun doom--get-modules (file)
;;   (unless (file-exists-p file)
;;     (user-error "%s does not exist" file))
;;   (with-temp-buffer
;;     (insert-file-contents file)
;;     (when (re-search-forward "(doom! " nil t)
;;       (goto-char (match-beginning 0))
;;       (cdr (sexp-at-point)))))

;; (defun doom--put-modules (tmpfile modules)
;;   (with-temp-file tmpfile
;;     (delay-mode-hooks (emacs-lisp-mode))
;;     (insert (replace-regexp-in-string " " "\n" (prin1-to-string modules)))
;;     (indent-region (point-min) (point-max))))

;; ;;;###autoload
;; (defun doom/what-has-changed ()
;;   "Open an ediff session to compare the module list in
;; ~/.emacs.d/init.example.el and ~/.doom.d/init.el."
;;   (interactive)
;;   (let ((old-modules (doom--get-modules (expand-file-name "init.example.el" doom-emacs-dir)))
;;         (new-modules (doom--get-modules (expand-file-name "init.el" doom-private-dir)))
;;         (example-init-el "/tmp/doom-init.example.el")
;;         (private-init-el "/tmp/doom-private-init.el"))
;;     (doom--put-modules example-init-el old-modules)
;;     (doom--put-modules private-init-el new-modules)
;;     (ediff private-init-el example-init-el)))
