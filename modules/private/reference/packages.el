;; -*- no-byte-compile: t; -*-
;;; private/reference/packages.el

(package! org-ref
    ;; :pin "8aa2bb45268f660956151547533689d4ec30378d" ;; version 2
  :pin "12e5f9e89b92e731d5c199ff46f4f887ace9b791")

(package! bibtex-completion :pin "aa775340ba691d2322948bfdc6a88158568a1399")
(package! ivy-bibtex :pin "aa775340ba691d2322948bfdc6a88158568a1399")

;;; org-roam V2
(when (and (featurep! +roam-bibtex) (featurep! :lang org +roam2))
  (package! org-roam-bibtex
    :pin "196e5815dd13b014804122c4e32ee5f16f0ad66b"
    ))

(package! citeproc-org :pin "22a759c4f0ec80075014dcc594baa4d1b470d995")
;; (package! citeproc :pin "2e7df666bfeed92178d20c5851a2945ed5760664")

;; (when (featurep! :completion vertico)
;;   (package! citar :pin "7740300831af16f4c2bbc4012fcc6a21f1f9a809"))

;; ;;; compatiable with roam v1
;; (when (and (featurep! +roam-bibtex) (featurep! :lang org +roam))
;;   (package! org-roam-bibtex :pin "c9865196efe7cfdfcced0d47ea3e5b39bdddd162"))
