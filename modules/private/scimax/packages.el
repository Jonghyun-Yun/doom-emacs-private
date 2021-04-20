;; -*- no-byte-compile: t; -*-
;;; private/scimax/packages.el
(package! emacs-google-this
  :recipe (:host github :repo "jkitchin/emacs-google-this")
  :pin "ca510689b84f14bff159ba468e11098b52f9b909"
  :disable t)

(package! ov :pin "c5b9aa4e1b00d702eb2caedd61c69a22a5fa1fab"
  :disable t)
