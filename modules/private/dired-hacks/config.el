;;; private/dired-hacks/config.el -*- lexical-binding: t; -*-

(use-package! ivy-dired-history
  :after dired
  :if (modulep! :completion ivy)
  :config
  (after! savehist
    (add-to-list 'savehist-additional-variables 'ivy-dired-history-variable)))

(use-package! dired-quick-sort
  :after dired
  :when (not IS-WINDOWS)
  :config
  (dired-quick-sort-setup))

(use-package! dired-filter
  :after dired
  ;; :hook (dired-mode . dired-filter-mode)
  :init
  (define-key dired-mode-map (kbd "C-c C-f") dired-filter-map)
  (evil-define-key 'normal dired-mode-map "g/" dired-filter-map))

(use-package! dired-subtree
  :commands dired-subtree-toggle
  :config
  (setq dired-subtree-cycle-depth 4
        dired-subtree-line-prefix ">")
  (map! :map dired-mode-map
        [backtab] #'dired-subtree-cycle
        [tab] #'dired-subtree-toggle
        :n "g^" #'dired-subtree-beginning
        :n "g$" #'dired-subtree-end
        :n "gm" #'dired-subtree-mark-subtree
        :n "gu" #'dired-subtree-unmark-subtree))

(use-package! dired-narrow
  :commands (dired-narrow-regexp)
  :init
  (evil-collection-define-key 'normal 'dired-mode-map
    "s" 'dired-narrow-regexp))

 (use-package! dired-collapse
  :commands (dired-collapse-mode))

(use-package! dired-ranger
  :after dired
  :commands (dired-ranger-copy)
  ;; :init
  ;; (map! (:map dired-mode-map
  ;;        "g P" #'dired-ranger-paste
  ;;        "g C" #'dired-ranger-copy))
  )

(use-package! dired-sidebar
  :unless (modulep! :emacs dired +ranger)
  :commands (dired-sidebar-toggle-sidebar dired-sidebar-show-sidebar)
  :config
  (setq dired-sidebar-width 25
        dired-sidebar-theme 'ascii
        dired-sidebar-tui-update-delay 5
        dired-sidebar-recenter-cursor-on-tui-update t
        dired-sidebar-no-delete-other-windows t
        dired-sidebar-use-custom-modeline t)
  (pushnew! dired-sidebar-toggle-hidden-commands
            'evil-window-rotate-upwards 'evil-window-rotate-downwards)
  (map! :map dired-sidebar-mode-map
        :n "q" #'dired-sidebar-toggle-sidebar))
