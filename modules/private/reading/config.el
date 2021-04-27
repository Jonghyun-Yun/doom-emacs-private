;;; private/reading/config.el -*- lexical-binding: t; -*-

;;; speed reading
(use-package! spray
  :defer t
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

;;; nov
(use-package nov
  :defer t
  :mode ("\\.epub\\'" . nov-mode)
  :config
  (map!
   :map nov-mode-map
   :nvime "H" #'nov-previous-document
   :nvime "L" #'nov-next-document
   :nvime "[" #'nov-previous-document
   :nvime "]" #'nov-next-document
   :nvime "d" #'nov-scroll-up
   :nvime "u" #'nov-scroll-down
   :nvime "J" #'nov-scroll-up
   :nvime "K" #'nov-scroll-down
   :nvime "gm" #'nov-display-metadata
   :nvime "gr" #'nov-render-document
   :nvime "gt" #'nov-goto-toc
   :nvime "gv" #'nov-view-source
   :nvime "gV" #'nov-view-content-source)
  (defun +nov-mode-setup ()
    (face-remap-add-relative 'variable-pitch
                             :family "Merriweather"
                             :height 1.4
                             :width 'semi-expanded)
    (face-remap-add-relative 'default :height 1.3)
    (setq-local line-spacing 0.2
                next-screen-context-lines 4
                shr-use-colors nil)
    (require 'visual-fill-column nil t)
    (setq-local visual-fill-column-center-text t
                visual-fill-column-width 83
                nov-text-width 80)
    (visual-fill-column-mode 1)
    (hl-line-mode -1)
    )
  (add-hook 'nov-mode-hook #'+nov-mode-setup)
  )

;; ;; epub osx dictionary
;; (defun my-nov-mode-map ()
;;   (define-key nov-mode-map "s" 'osx-dictionary-search-pointer)
;;   t)
;; (add-hook 'nov-mode-hook 'my-nov-mode-map)

;;; write-room
(defvar +zen-serif-p t
  "Whether to use a serifed font with `mixed-pitch-mode'.")
(after! writeroom-mode
  (require 'mixed-pitch)
  (defvar-local +zen--original-org-indent-mode-p nil)
  (defvar-local +zen--original-mixed-pitch-mode-p nil)
  (defvar-local +zen--original-solaire-mode-p nil)
  (defvar-local +zen--original-org-pretty-table-mode-p nil)
  (defun +zen-enable-mixed-pitch-mode-h ()
    "Enable `mixed-pitch-mode' when in `+zen-mixed-pitch-modes'."
    (when (apply #'derived-mode-p +zen-mixed-pitch-modes)
      (if writeroom-mode
          (progn
            (setq +zen--original-solaire-mode-p solaire-mode)
            (solaire-mode -1)
            (setq +zen--original-mixed-pitch-mode-p mixed-pitch-mode)
            (funcall (if +zen-serif-p #'mixed-pitch-serif-mode #'mixed-pitch-mode) 1))
        (funcall #'mixed-pitch-mode (if +zen--original-mixed-pitch-mode-p 1 -1))
        (when +zen--original-solaire-mode-p (solaire-mode 1)))))
  (pushnew! writeroom--local-variables
            'display-line-numbers
            'visual-fill-column-width
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
                )))
  (add-hook 'writeroom-mode-disable-hook
            (defun +zen-nonprose-org-h ()
              "Reverse the effect of `+zen-prose-org'."
              (when (eq major-mode 'org-mode)
                (when (featurep 'org-superstar)
                  (org-superstar-restart))
                (when +zen--original-org-indent-mode-p (org-indent-mode 1))
                )))
  )

;;; mixed-pitch
(autoload #'mixed-pitch-serif-mode "mixed-pitch"
  "Change the default face of the current buffer to a serifed variable pitch, while keeping some faces fixed pitch." t)

(after! mixed-pitch
  (setq mixed-pitch-set-height t)
  (append mixed-pitch-fixed-pitch-faces
          '(org-drawer org-todo example-block))
  (defface variable-pitch-serif
    '((t (:family "serif")))
    "A variable-pitch face with serifs."
    :group 'basic-faces)
  (defun mixed-pitch-serif-mode (&optional arg)
    "Change the default face of the current buffer to a serifed variable pitch, while keeping some faces fixed pitch."
    (interactive)
    (progn
      (set-face-attribute 'variable-pitch-serif nil :font variable-pitch-serif-font)
      (let ((mixed-pitch-face 'variable-pitch-serif))
        (mixed-pitch-mode (or arg 'toggle))))))

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
  (defvar +org-present-format-latex-scale 2.5
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
      (apply orig-fun args)
      ))
  (advice-add 'org-tree-slide-mode :around #'jyun/org-tree-slide)

  ;; cause errors in navigating slides
  (advice-remove 'org-tree-slide--display-tree-with-narrow #'+org-present--narrow-to-subtree-a)
  )
