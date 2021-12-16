;; -*- no-byte-compile: t; -*-
;;; private/dired-hacks/packages.el

(when (featurep! :completion ivy)
  (package! ivy-dired-history))
(package! dired-quick-sort)
(package! dired-filter)
(package! dired-subtree)
(package! dired-collapse :disable t)
(package! dired-ranger)
(package! dired-rainbow :disable t)

(package! dired-narrow :disable t)
