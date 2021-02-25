;;; private/dired-plus/config.el -*- lexical-binding: t; -*-

(use-package! ivy-dired-history
  :defer t
  :after dired
  :config
  (after! savehist
    (add-to-list 'savehist-additional-variables 'ivy-dired-history-variable)))

;; (use-package! dired-quick-sort
;;   :after dired
;;   :when (not IS-WINDOWS)
;;   :config
;;   (dired-quick-sort-setup))

(use-package! dired-filter
  :defer t
  :after dired)

(use-package! dired-subtree
  :defer t
  :commands dired-subtree-toggle
  )

;; (use-package! dired-narrow
;;   :after dired)
