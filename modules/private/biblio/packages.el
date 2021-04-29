;; -*- no-byte-compile: t; -*-
;;; tools/biblio/packages.el

(package! bibtex-completion :pin "8a0dd9841316793aacddea744d6b8ca4a7857a35")
(when (featurep! :completion ivy)
  (package! ivy-bibtex :pin "8a0dd9841316793aacddea744d6b8ca4a7857a35"))
(when (featurep! :completion helm)
  (package! helm-bibtex :pin "8a0dd9841316793aacddea744d6b8ca4a7857a35"))
(when (featurep! :lang org)
  (package! org-ref :pin "3f9d9fa096b97d81981bec6cc70b791b56e49f20"))
;; (when (featurep! :lang org)
;;   (package! org-ref :pin "3f9d9fa096b97d81981bec6cc70b791b56e49f20")
;;   ;; (package! org-ref :pin "d9d01c0c1c1b980284a66d80289e736de7649174") ;; breaking
;;   ;; (package! org-ref :pin "caca18f8eeae213c2719e628949df70910f7d3c7") ;; breacking change in (defun org-ref-open-bibtex-notes ()
;;   ;; (package! org-ref :pin "75d83ea014e530591cfdafc591b9b1c44509d035")
;; ;; (package! org-ref :pin "9ab74270c1543e4743ca0436de567d8205403b43") ; https://github.com/jkitchin/org-ref/commit/9ab74270c1543e4743ca0436de567d8205403b43
;; )
(when (featurep! +roam-bibtex)
  (package! org-roam-bibtex :pin "a9a7d232ce25d06880aa2ed16148615af7e551a7"))

(package! citeproc-org :pin "22a759c4f0ec80075014dcc594baa4d1b470d995")
