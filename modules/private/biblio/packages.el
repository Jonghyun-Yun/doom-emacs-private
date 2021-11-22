;; -*- no-byte-compile: t; -*-
;;; tools/biblio/packages.el

(when (featurep! :lang org)
  (package! org-ref
    ;; :pin "8aa2bb45268f660956151547533689d4ec30378d" ;; version 2
    ;; :pin "4f58b5db2ed6bc2bb4ca46484243ca8b7d391442" ;; version 3
    :pin "d013e202c2b8b72a8d8b853f1fe4ec31d93e7174"
    ))

 (package! bibtex-completion :pin "bb47f355b0da8518aa3fb516019120c14c8747c9")
  (package! ivy-bibtex :pin "bb47f355b0da8518aa3fb516019120c14c8747c9")

(when (featurep! :completion helm)
  (package! helm-bibtex :pin "bb47f355b0da8518aa3fb516019120c14c8747c9"))

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
  (package! citar :pin "41ec5d4d5d625f7d784b4de20d14b7bceaf1730c"))
