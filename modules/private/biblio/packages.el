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
  (package! org-ref
    ;; :pin "8aa2bb45268f660956151547533689d4ec30378d" ;; version 2
    :pin "4f58b5db2ed6bc2bb4ca46484243ca8b7d391442" ;; version 3
    )
  )
;; (when (featurep! :lang org)
;;   (package! org-ref :pin "3f9d9fa096b97d81981bec6cc70b791b56e49f20")
;;   ;; (package! org-ref :pin "d9d01c0c1c1b980284a66d80289e736de7649174") ;; breaking
;;   ;; (package! org-ref :pin "caca18f8eeae213c2719e628949df70910f7d3c7") ;; breacking change in (defun org-ref-open-bibtex-notes ()
;;   ;; (package! org-ref :pin "75d83ea014e530591cfdafc591b9b1c44509d035")
;; ;; (package! org-ref :pin "9ab74270c1543e4743ca0436de567d8205403b43") ; https://github.com/jkitchin/org-ref/commit/9ab74270c1543e4743ca0436de567d8205403b43
;; )


;; (package! bibtex-completion :pin "a0d32ab16748b7b0c43d6421f1b497b7caf8e590")
(package! bibtex-completion :pin "bb47f355b0da8518aa3fb516019120c14c8747c9")

;; (when (featurep! :completion ivy)
(package! ivy-bibtex :pin "7c16399fd3a78d11d3599a0233372e6695d32003"
  ;; "a0d32ab16748b7b0c43d6421f1b497b7caf8e590"
  )
;; )

(when (featurep! :completion helm)
  (package! helm-bibtex :pin "7c16399fd3a78d11d3599a0233372e6695d32003"
    ;; "a0d32ab16748b7b0c43d6421f1b497b7caf8e590"
    ))

;; ;; https://github.com/org-roam/org-roam-bibtex/pull/87
;; (when (featurep! +roam-bibtex)
  ;; (package! org-roam-bibtex :pin "58b052e1246a990965c1a46343245cd57af92c30"))

;;; compatiable with roam v1
(when (and (featurep! +roam-bibtex) (featurep! :lang org +roam))
  (package! org-roam-bibtex :pin "c9865196efe7cfdfcced0d47ea3e5b39bdddd162"))

;;; org-roam V2
(when (and (featurep! +roam-bibtex) (featurep! :lang org +roam2))
  (package! org-roam-bibtex
    ;; :pin "9675eee4183301b16eb27776dae93e8c0b99eb07"
    :pin "671c2ae8e9df38d2a7a3476b63355d0d52c0ecd6"
    ))

(package! citeproc-org :pin "22a759c4f0ec80075014dcc594baa4d1b470d995")
(package! citeproc :pin "c8ff95862823cdff067e8cc9bb7f5ef537e8f1d9")

(when (featurep! :completion vertico)
  (package! citar
    ;; :pin "e5cbae466ff913e33b5f00bc91d6224f5205786e"
    :pin "fd33f5c4f7981036a969b5ca8aaf42380848ab32"
    )
  ;; (package! bibtex-actions :pin "6e3a194c3ab655693f8194be78542366755c58c9")
  )
