;; -*- no-byte-compile: t; -*-
;;; tools/biblio/packages.el

;; (package! bibtex-completion :pin "8a0dd9841316793aacddea744d6b8ca4a7857a35")
;; (when (featurep! :completion ivy)
;;   (package! ivy-bibtex :pin "8a0dd9841316793aacddea744d6b8ca4a7857a35"))
;; (when (featurep! :completion helm)
;;   (package! helm-bibtex :pin "8a0dd9841316793aacddea744d6b8ca4a7857a35"))
;; (when (featurep! :lang org)
;;   (package! org-ref :pin "3f9d9fa096b97d81981bec6cc70b791b56e49f20"))


(when (featurep! :lang org)
  (package! org-ref :pin "8aa2bb45268f660956151547533689d4ec30378d"))

(package! bibtex-completion :pin "a0d32ab16748b7b0c43d6421f1b497b7caf8e590")

;; (when (featurep! :completion ivy)
(package! ivy-bibtex :pin "a0d32ab16748b7b0c43d6421f1b497b7caf8e590")
;; )

(when (featurep! :completion helm)
  (package! helm-bibtex :pin "a0d32ab16748b7b0c43d6421f1b497b7caf8e590"))

;; (when (featurep! :completion vertico)
  ;; (package! bibtex-actions :pin "6e3a194c3ab655693f8194be78542366755c58c9"))

;; (when (featurep! :lang org)
;;   (package! org-ref :pin "3f9d9fa096b97d81981bec6cc70b791b56e49f20")
;;   ;; (package! org-ref :pin "d9d01c0c1c1b980284a66d80289e736de7649174") ;; breaking
;;   ;; (package! org-ref :pin "caca18f8eeae213c2719e628949df70910f7d3c7") ;; breacking change in (defun org-ref-open-bibtex-notes ()
;;   ;; (package! org-ref :pin "75d83ea014e530591cfdafc591b9b1c44509d035")
;; ;; (package! org-ref :pin "9ab74270c1543e4743ca0436de567d8205403b43") ; https://github.com/jkitchin/org-ref/commit/9ab74270c1543e4743ca0436de567d8205403b43
;; )

;; ;; https://github.com/org-roam/org-roam-bibtex/pull/87
;; (when (featurep! +roam-bibtex)
  ;; (package! org-roam-bibtex :pin "58b052e1246a990965c1a46343245cd57af92c30"))

;; ;; lastes with roam v1
;; (when (featurep! +roam-bibtex)
;;   (package! org-roam-bibtex :pin "c9865196efe7cfdfcced0d47ea3e5b39bdddd162"))

;; org-roam V2
(when (featurep! +roam-bibtex)
  (package! org-roam-bibtex :pin "9675eee4183301b16eb27776dae93e8c0b99eb07"))

(package! citeproc-org :pin "22a759c4f0ec80075014dcc594baa4d1b470d995")
(package! citeproc :pin "0857973409e3ef2ef0238714f2ef7ff724230d1c")
