;; -*- no-byte-compile: t; -*-
;;; private/write/packages.el

(package! academic-phrases)

;; online
(package! define-word :pin "6e4a427503aef096484f88332962c346cdd10847" :disable t)
(package! powerthesaurus :pin "93036d3b111925ebc34f747ff846cb0b8669b92e" :disable t)
(package! mw-thesaurus)
(package! mw-dictionaries-emacs
  :recipe (:host github :repo "tongjie-chen/mw-dictionaries-emacs"))

;; offline
(package! wordnut :pin "feac531404041855312c1a046bde7ea18c674915")
(package! synosaurus :pin "14d34fc92a77c3a916b4d58400424c44ae99cd81")

;; math
(package! mathpix.el
  :recipe (:host github :repo "jethrokuan/mathpix.el"))

;; string
(package! string-inflection :pin "c4a519be102cb99dd86be3ee8c387f008d097635")
