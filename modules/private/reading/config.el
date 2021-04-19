;;; private/reading/config.el -*- lexical-binding: t; -*-


(use-package spray
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
                (when (featurep 'org-superstar)
                  (setq-local org-superstar-headline-bullets-list '("🙘" "🙙" "🙚" "🙛")
                              ;; org-superstar-headline-bullets-list '("🙐" "🙑" "🙒" "🙓" "🙔" "🙕" "🙖" "🙗")
                              org-superstar-remove-leading-stars t)
                  (org-superstar-restart))
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

(autoload #'mixed-pitch-serif-mode "mixed-pitch"
  "Change the default face of the current buffer to a serifed variable pitch, while keeping some faces fixed pitch." t)

(after! mixed-pitch
  (setq mixed-pitch-set-height t)
  (append mixed-pitch-fixed-pitch-faces
          '(org-drawer org-todo))
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
