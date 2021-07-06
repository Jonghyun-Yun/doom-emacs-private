;;; private/scimax/config.el -*- lexical-binding: t; -*-

;; ;; google-this
;; (use-package! google-this
;;   :config
;;   (google-this-mode 1)
;;   ;; (setq google-this-base-url "https://duckduckgo.")
;; ;; (defun google-this-url ()
;; ;;   "URL for google searches.
;; ;;   (concat google-this-base-url google-this-location-suffix "/?q=%s"))
;;   )

(after! elfeed
  (require 'scimax-elfeed))

(use-package! scimax-autoformat-abbrev)

;;; scimax
;; (load! "words")                         ;; bibtex search
;; (load! "scimax-elfeed")                 ;; email elfeed
;; (load! "scimax-hydra")                 ;; my hydra to review
;; (load! "scimax-autoformat-abbrev")      ;; abbrev

(defvar scimax-dir
  (expand-file-name (concat doom-private-dir "local/scimax"))
"A local directory to load scimax packages."
  )

(use-package! scimax-hydra
  :load-path scimax-dir
  :commands (scimax-dispatch-mode-hydra
             scimax-error/body
             scimax-src-block-hydra/body
             scimax/body)
  :init
  ;; (require 'cl)
  (map! :g
        "s-." #'scimax-dispatch-mode-hydra
        "s-," #'scimax/body)
  :config
  (require 'emacs-keybinding-command-tooltip-mode))

(add-hook 'find-file-hook #'my-enable-smerge-maybe)
(defun my-enable-smerge-maybe ()
  (when (and buffer-file-name (vc-backend buffer-file-name))
    (save-excursion
      (goto-char (point-min))
      (when (re-search-forward "^<<<<<<< " nil t)
        (smerge-mode +1)
	(+vc/smerge-hydra/body)))))

;; (use-package! ox-word
;; :after ox)

;; (scimax-ivy-yas)
;; (scimax-autoformat-mode)
;; (scimax-toggle-abbrevs)

(after! org
  (require 'scimax-org) ;; org mark-up
  ;; key bindings
  (bind-keys :map org-mode-map
             ("H--" . org-subscript-region-or-point)
             ("H-=" . org-superscript-region-or-point)
             ("H-i" . org-italics-region-or-point)
             ("H-b" . org-bold-region-or-point)
             ("H-v" . org-verbatim-region-or-point)
             ("H-c" . org-code-region-or-point)
             ("H-u" . org-underline-region-or-point)
             ("H-+" . org-strikethrough-region-or-point)
             ("H-4" . org-latex-math-region-or-point)
             ("H-e" . ivy-insert-org-entity)
             ("H-\"" . org-double-quote-region-or-point)
             ("H-'" . org-single-quote-region-or-point)
             ("H-m" . org-inline-math-region-or-point))
  ;; (add-hook! 'org-mode-hook #'scimax-autoformat-mode)

  (add-hook! 'org-mode-hook (lambda () (if (not (get 'scimax-org-renumber-environment 'enabled))
                                           (scimax-toggle-latex-equation-numbering)))))
