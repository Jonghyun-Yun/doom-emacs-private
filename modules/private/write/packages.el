;; -*- no-byte-compile: t; -*-
;;; private/write/packages.el

;; (package! synosaurus)
;; (package! wordnut)
(package! mw-thesaurus)
(package! academic-phrases)

;; (package! wordsmith-mode)

;; (package! powerthesaurus
;;   :recipe (:host github :repo "maxchaos/emacs-powerthesaurus" :branch "pt-api-change")
;;   :pin "4a834782a394f2dc70fc02d68b6962b44d87f0cf")
(package! wordnut :pin "feac531404041855312c1a046bde7ea18c674915")
(package! synosaurus :pin "14d34fc92a77c3a916b4d58400424c44ae99cd81")

(package! mathpix.el
  :recipe (:host github :repo "jethrokuan/mathpix.el"))

(package! string-inflection :pin "c4a519be102cb99dd86be3ee8c387f008d097635")

(package! mw-dictionaries-emacs
  :recipe (:host github :repo "tongjie-chen/mw-dictionaries-emacs")
  :disable t)
