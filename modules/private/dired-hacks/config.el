;;; private/dired-hacks/config.el -*- lexical-binding: t; -*-

(use-package! ivy-dired-history
  :after dired
  :if (featurep! :completion ivy)
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
  :commands dired-subtree-toggle)

(use-package! dired-narrow
  :commands (dired-narrow-regexp)
  :init
  (evil-collection-define-key 'normal 'dired-mode-map
    "s" 'dired-narrow-regexp))

(use-package! dired-collapse
  :after dired
  :commnads (dired-collapse-mode))

(use-package! dired-ranger
  :after dired
  :commands (dired-ranger-copy)
  :init
  (map! (:map dired-mode-map
         "g P" #'dired-ranger-paste
         "g C" #'dired-ranger-copy)))
