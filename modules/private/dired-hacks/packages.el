;; -*- no-byte-compile: t; -*-
;;; private/dired-hacks/packages.el

(when (featurep! :completion ivy)
  (package! ivy-dired-history))
(package! dired-quick-sort)
(package! dired-filter)
(package! dired-subtree)
(package! dired-collapse :disable t)
(package! dired-rainbow :disable t)
(package! dired-ranger)

(package! dired-sidebar :pin "da77919081d9a4e73c2df63542353319381e4f89")

(package! dired-narrow :disable t)
