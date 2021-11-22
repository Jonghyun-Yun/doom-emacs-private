;; -*- no-byte-compile: t; -*-
;;; tools/biblio/packages.el

(package! org-ref
    ;; :pin "8aa2bb45268f660956151547533689d4ec30378d" ;; version 2
    :pin "d013e202c2b8b72a8d8b853f1fe4ec31d93e7174"
    :disable t)

(package! bibtex-completion :pin "bb47f355b0da8518aa3fb516019120c14c8747c9")
(package! ivy-bibtex :pin "bb47f355b0da8518aa3fb516019120c14c8747c9")

(when (featurep! :completion helm)
  (package! helm-bibtex :pin "bb47f355b0da8518aa3fb516019120c14c8747c9"))

;;; org-roam V2
(when (and (featurep! +roam-bibtex) (featurep! :lang org +roam2))
  (package! org-roam-bibtex
    :pin "1034fedca880cf28b2d5d1442beb679d185036c0"
    ))

(package! citeproc-org :pin "22a759c4f0ec80075014dcc594baa4d1b470d995")
(package! citeproc :pin "c8ff95862823cdff067e8cc9bb7f5ef537e8f1d9")

(when (featurep! :completion vertico)
  (package! citar :pin "41ec5d4d5d625f7d784b4de20d14b7bceaf1730c"))

;; ;;; compatiable with roam v1
;; (when (and (featurep! +roam-bibtex) (featurep! :lang org +roam))
;;   (package! org-roam-bibtex :pin "c9865196efe7cfdfcced0d47ea3e5b39bdddd162"))
