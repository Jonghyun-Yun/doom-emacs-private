;;; private/reading/config.el -*- lexical-binding: t; -*-

;;; mixed-pitch
(defvar variable-pitch-serif-font (font-spec :family "Alegreya" :size 20)
  "The default font to use.
Must be a `font-spec', a font object, an XFT font string, or an XLFD string.

This affects the `variable-pitch-serif' faces.")
(defvar mixed-pitch-modes '(org-mode LaTeX-mode markdown-mode gfm-mode Info-mode)
  "Modes that `mixed-pitch-mode' should be enabled in, but only after UI initialisation.")
(defun init-mixed-pitch-h ()
  "Hook `mixed-pitch-mode' into each mode in `mixed-pitch-modes'.
Also immediately enables `mixed-pitch-modes' if currently in one of the modes."
  (when (memq major-mode mixed-pitch-modes)
    (mixed-pitch-mode 1))
  (dolist (hook mixed-pitch-modes)
    (add-hook (intern (concat (symbol-name hook) "-hook")) #'mixed-pitch-mode)))

(autoload #'mixed-pitch-serif-mode "mixed-pitch"
  "Change the default face of the current buffer to a serifed variable pitch, while keeping some faces fixed pitch." t)

(after! mixed-pitch
  (setq mixed-pitch-set-height t)
  (pushnew! mixed-pitch-fixed-pitch-faces
            'org-drawer
            'org-todo
            'example-block
            )
  (defface variable-pitch-serif
    '((t (:family "serif")))
    "A variable-pitch face with serifs."
    :group 'basic-faces)
  (defun mixed-pitch-serif-mode (&optional arg)
    "Change the default face of the current buffer to a serifed variable pitch, while keeping some faces fixed pitch."
    (interactive)
    (progn
      (setq-local line-spacing 2)
      (set-face-attribute 'variable-pitch-serif nil :font variable-pitch-serif-font)
      (let ((mixed-pitch-face 'variable-pitch-serif))
        (mixed-pitch-mode (or arg 'toggle))))))

;; fix company faces in mixed-pitch-mode
;; (after! mixed-pitch
;;   (dolist (f (-filter (lambda (sym)
;;                         (s-prefix? "company-" (symbol-name sym)))
;;                       (face-list)))
;;     (pushnew! mixed-pitch-fixed-pitch-faces f)))

;;; speed reading
(use-package! spray
  :commands spray-mode
  :init
  (progn
    (defun speed-reading/start-spray ()
      "Start spray speed reading on current buffer at current point."
      (interactive)
      (evil-insert-state)
      (spray-mode t)
      (internal-show-cursor (selected-window) nil))
    ;; key map
    (map! :leader "ars" #'speed-reading/start-spray)
    (defadvice spray-quit (after speed-reading//quit-spray activate)
      "Correctly quit spray."
      (internal-show-cursor (selected-window) t)
      (evil-normal-state)))
  :config
  (progn
    (define-key spray-mode-map (kbd "h") 'spray-backward-word)
    (define-key spray-mode-map (kbd "l") 'spray-forward-word)
    (define-key spray-mode-map (kbd "q") 'spray-quit))
  ;; (eval-after-load 'which-key
  ;;   (push '((nil . "\\`speed-reading/\\(.+\\)\\'") . (nil . "\\1"))
  ;;         which-key-replacement-alist))
  (setq spray-wpm 400
        spray-height 700))

;;; write-room
(defvar +zen-serif-p t
  "Whether to use a serifed font with `mixed-pitch-mode'.")
(after! writeroom-mode
  (require 'mixed-pitch)
  (defvar-local +zen--original-org-indent-mode-p nil)
  (defvar-local +zen--original-mixed-pitch-mode-p nil)
  (defvar-local +zen--original-solaire-mode-p nil)
  (defvar-local +zen--original-org-pretty-table-mode-p nil)
  (defvar-local +zen--original-org-appear-mode-p nil)
  (defun +zen-enable-mixed-pitch-mode-h ()
    "Enable `mixed-pitch-mode' when in `+zen-mixed-pitch-modes'."
    (when (apply #'derived-mode-p +zen-mixed-pitch-modes)
      (if writeroom-mode
          (progn
            (setq +zen--original-solaire-mode-p solaire-mode)
            (solaire-mode -1)
            (setq +zen--original-mixed-pitch-mode-p mixed-pitch-mode)
            (funcall (if +zen-serif-p #'mixed-pitch-serif-mode #'mixed-pitch-mode) 1)
            )
        (funcall #'mixed-pitch-mode (if +zen--original-mixed-pitch-mode-p 1 -1))
        (when +zen--original-solaire-mode-p (solaire-mode 1)))))
  (pushnew! writeroom--local-variables
            'display-line-numbers
            'visual-fill-column-width
            'org-hide-emphasis-markers
            'org-adapt-indentation
            'org-superstar-headline-bullets-list
            'org-superstar-remove-leading-stars)
  (add-hook 'writeroom-mode-enable-hook
            (defun +zen-prose-org-h ()
              "Reformat the current Org buffer appearance for prose."
              (when (eq major-mode 'org-mode)
                (setq display-line-numbers nil
                      ;; visual-fill-column-width 60
                      org-adapt-indentation nil
                      org-fontify-quote-and-verse-blocks t
                      org-fontify-whole-heading-line t
                      org-hide-emphasis-markers t
                      )
                (when (require 'org-superstar)
                  (setq-local org-superstar-headline-bullets-list '("🙘" "🙙" "🙚" "🙛")
                              ;; org-superstar-headline-bullets-list '("🙐" "🙑" "🙒" "🙓" "🙔" "🙕" "🙖" "🙗")
                              org-superstar-remove-leading-stars t)
                  (org-superstar-mode 1))
                (setq +zen--original-org-indent-mode-p org-indent-mode)
                (org-indent-mode -1)
                (setq +zen--original-org-appear-mode-p (bound-and-true-p org-appear-mode))
                (org-appear-mode 1)
                )))
  (add-hook 'writeroom-mode-hook (lambda ()
                                   (when (eq major-mode 'org-mode) (org-appear-mode))))
  (add-hook 'writeroom-mode-disable-hook
            (defun +zen-nonprose-org-h ()
              "Reverse the effect of `+zen-prose-org'."
              (when (eq major-mode 'org-mode)
                (when (featurep 'org-superstar)
                  (org-superstar-restart))
                (when +zen--original-org-indent-mode-p (org-indent-mode 1))
                (when +zen--original-org-appear-mode-p (org-appear-mode 1))
                )))
  )

;;; info-colors
(use-package! info-colors
  :commands (info-colors-fontify-node)
  :config
  (add-hook 'Info-selection-hook 'info-colors-fontify-node)
  ;; (add-hook 'Info-mode-hook #'mixed-pitch-mode)
  )

;;; org-tree-slide
(with-eval-after-load 'org-tree-slide
  (defvar +org-present-hide-properties t
    "Whether to hide property draws in `org-tree-slide'.")
  (defvar +org-present-hide-tags t
    "Whether to hide tags in `org-tree-slide'.")
  (defvar +org-present-format-latex-scale 3
    "A local variable to be used as `org-latex-preview-scale' in `org-tree-slide'.")
  (setq org-tree-slide-header nil
        org-tree-slide-skip-outline-level 5
        org-tree-slide-heading-emphasis nil
        +org-present-text-scale 4)

  ;; (remove-hook 'org-tree-slide-mode-hook
  ;;              #'+org-present-hide-blocks-h
  ;;              #'+org-present-prettify-slide-h

  ;; `jyun/org-present-hide' needs some functions in `contrib-present.el'
  ;; these functions are not autoloaded.
  (load (expand-file-name "modules/lang/org/autoload/contrib-present" doom-emacs-dir))
  (add-hook! 'org-tree-slide-mode-hook
             ;; #'jyun/org-present-hide
             #'jyun/org-present-mixed-pitch-setup
             #'org-appear-mode
             )
  (defun jyun/org-present-mixed-pitch-setup ()
    "Visual enchancement for `org-tree-slide'. `mixed-pitch-mode'
or `mixed-pitch-serif-mode' can be called afterward."
    (progn
      (require 'mixed-pitch)
      (setq-local
       ;; visual-fill-column-width 60
       ;; org-adapt-indentation nil
       org-fontify-quote-and-verse-blocks t
       org-fontify-whole-heading-line t
       org-hide-emphasis-markers t
       mixed-pitch-set-height nil
       )
      (when (require 'org-superstar)
        (setq-local org-superstar-headline-bullets-list '("🙘" "🙙" "🙚" "🙛")
                    ;; org-superstar-headline-bullets-list '("🙐" "🙑" "🙒" "🙓" "🙔" "🙕" "🙖" "🙗")
                    org-superstar-remove-leading-stars t)
        ;; (org-superstar-restart)
        (org-superstar-mode 1)
        )
      ))
  (defun jyun/org-tree-slide (orig-fun &rest args)
    "Hide a few `org-element'. Then, do `org-tree-slide-mode'."
    (progn
      (jyun/org-present-hide)
      ;; set default org-latex-preview size
      ;; (setq-local org-format-latex-options '(:foreground default :background default :scale ttt :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers ("begin" "$1" "$" "$$" "\\(" "\\[")))
      ;; (setq-local org-format-latex-options (plist-put org-format-latex-options :scale +org-present-format-latex-scale))
      (setq-local org-format-latex-options
                           (plist-put (copy-tree org-format-latex-options)
                                      :scale +org-present-format-latex-scale))
      (apply orig-fun args)
      ))
  (advice-add 'org-tree-slide-mode :around #'jyun/org-tree-slide)

  ;; cause errors in navigating slides
  ;; (advice-remove 'org-tree-slide--display-tree-with-narrow #'+org-present--narrow-to-subtree-a)
  (advice-remove 'org-tree-slide--display-tree-with-narrow #'+org-present--hide-first-heading-maybe-a)
  )


;;;###autoload
(defun jyun/org-present-hide ()
  "Hide comments, drawers and tags."
  (save-excursion
    ;; hide all comments
    (goto-char (point-min))
    (while (re-search-forward
            "^[ \t]*#\\(\\+\\(author\\|title\\|date\\):\\)?.*\n"
            nil t)
      (cond
       ((and (match-string 2)
             (save-match-data
               (string-match (regexp-opt '("title" "author" "date"))
                             (match-string 2)))))
       ((and (match-string 2)
             (save-match-data
               (string-match org-babel-results-keyword (match-string 2))))
        ;; This pulls back the end of the hidden overlay by one to
        ;; avoid hiding image results of code blocks.  I'm not sure
        ;; why this is required, or why images start on the preceding
        ;; newline, but not knowing why doesn't make it less true.
        (+org-present--make-invisible (match-beginning 0) (1- (match-end 0))))
       (t (+org-present--make-invisible (match-beginning 0) (1- (match-end 0))))))
    ;; hide tags
    (when +org-present-hide-tags
      (goto-char (point-min))
      (while (re-search-forward
              "^\\*+.*?\\([ \t]+:[[:alnum:]_@#%:]+:\\)[ \r\n]"
              nil t)
        (+org-present--make-invisible (match-beginning 1) (1- (match-end 1)))))
    ;; hide properties
    (when +org-present-hide-properties
      (goto-char (point-min))
      (while (re-search-forward org-drawer-regexp nil t)
        (let ((beg (match-beginning 0))
              (end (re-search-forward
                    "^[ \t]*:END:[ \r\n]*"
                    (save-excursion (outline-next-heading) (point)) t)))
          (+org-present--make-invisible beg (- end 2)))))))
;; (dolist (el '("title" "author" "date"))
;;   (goto-char (point-min))
;;   (when (re-search-forward (format "^\\(#\\+%s:[ \t]*\\)[ \t]*\\(.*\\)$" el) nil t)
;;     (+org-present--make-invisible (match-beginning 1) (match-end 1))
;;     (push (make-overlay (match-beginning 2) (match-end 2)) +org-present--overlays)
;;     ))


;; revert changes related to https://github.com/hlissner/doom-emacs/issues/5524
(defvar +org-present--overlays nil)

;;;###autoload
(defun +org-present--make-invisible (beg end)
  (unless (assq '+org-present buffer-invisibility-spec)
    (add-to-invisibility-spec '(+org-present)))
  (let ((overlay (make-overlay beg (1+ end))))
    (push overlay +org-present--overlays)
    (overlay-put overlay 'invisible '+org-present)))

;; to override one in doom's module
(with-eval-after-load 'org-tree-slide
  (defun +org-present-hide-blocks-h ()
    "Hide org #+ constructs."
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "^[[:space:]]*\\(#\\+\\)\\(\\(?:BEGIN\\|END\\|ATTR\\)[^[:space:]]+\\).*" nil t)
        (+org-present--make-invisible
         (match-beginning 1)
         (match-end 0))))))
