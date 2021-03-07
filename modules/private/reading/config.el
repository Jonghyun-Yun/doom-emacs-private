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
   :nvime "gV" #'nov-view-content-source))
