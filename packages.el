;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
;(package! another-package
;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;(package! this-package
;  :recipe (:host github :repo "username/repo"
;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;(package! builtin-package :recipe (:nonrecursive t))
;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;(unpin! pinned-package)
;; ...or multiple packages
;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;(unpin! t)

;; (package! org-mode
;;   :recipe (:host github
;;            :repo "emacs-straight/org-mode"
;;            :files ("*.el" "lisp/*.el" "contrib/lisp/*.el"))
;;   :pin "2c980de07341b015741dc2fdad27a3078c9618fb") ;https://github.com/emacs-straight/org-mode/releases/tag/release_9.3.7

(when (featurep! :email mu4e)
  (package! mu4e-maildirs-extension)
  (package! mu4e-alert)
  )

(package! latexdiff
  :recipe (:host github :repo "galaunay/latexdiff.el"))

(package! matlab-mode)

(package! find-file-in-project :pin "cb5f3d1b697ef8212cc276c7486cbce2bf6c2a02")
;; (package! scihub)

;; (package! wordnut :pin "feac531404041855312c1a046bde7ea18c674915")
;; (package! synosaurus :pin "14d34fc92a77c3a916b4d58400424c44ae99cd81")

;; (package! org-pdftools :pin "a5b61bca3f8c91b0859bb0df1a929f9a31a57b99")
;; (package! org-noter-pdftools :pin "a5b61bca3f8c91b0859bb0df1a929f9a31a57b99")

;; ;; export doesn't work. problem in compiling; defmacro and marco eval in the same file
;; ;; ;; Load it localy
;; (package! ox-ravel
;;   :recipe (:host github
;;            :repo "jonghyun-yun/ox-ravel"
;;            :files ("*.el")
;;            )
;;   )

;; (package! ox-hugo
;;   :recipe (:host github :repo "jonghyun-yun/ox-hugo" :nonrecursive t))

(package! ox-hugo
  :recipe (:local-repo "local/ox-hugo"
           :branch "patch"))

;; (package! org-cv
;;   :recipe (:host github
;;            :repo "jonghyun-yun/org-cv"
;;            :files ("*.el"))
;;   ;; :pin "47ee61ce4538fe4406a68b4cfcf606e68e1f7261")
;;   :pin "219203e872b2bead5805544f65c9c7294e81e071")

;; (package! doom-snippets
;;   :recipe (:host github
;;            :repo "jonghyun-yun/doom-snippets"
;;            :files ("*.el" "*"))
;;   ;; :pin "21b7c8d37224768091a34a6c3ede68d52d03fb18")
;;   )

(package! org-re-reveal-ref)
;; (package! lsp-latex)

;; (when (featurep! :ui treemacs)
  ;;   (package! treemacs-icons-dired)
  ;; )

(package! elfeed-score)

(package! jabber)
(package! srv) ;; jabber dependency
(package! fsm) ;; jabber dependency

;;; disabled packages
(package! writegood-mode :disable t)

;; (package! auto-highlight-symbol)
;; (package! highlight-numbers-mode)
(package! highlight-parentheses)

(package! spacemacs-theme)
(package! modus-themes)

;; bump org-ref (set in biblio)
(package! org-ref :pin "1936720c2377d8af9a5edb0d252f881c0ec24918")

;; (package! valign :pin "6b0345e29cdec8526c9c19b73bdea53295ec998e")

(package! golden-ratio.el
  :recipe (:host github :repo "roman/golden-ratio.el"))

;; bookmark
;; (package! bm)

;; Github flavored markdown exporter
(package! ox-gfm)

;; org-mode presentation
;; (package! org-present)
;; (package! epresent)

;; https://github.com/emacs-straight/auctex
;; auctex preview fix
(package! auctex :pin "1472d1d231aeae463013d5e36307605157f84191")

;; https://github.com/emacsmirror/org-gcal
;; (package! org-gcal :pin "52b7f8f7654e391f51e8d6d40506c8c170a5be20")

;; (package! visual-regexp)

;; (package! info-colors :pin "47ee73cc19...")

(package! org-appear :recipe (:host github :repo "awth13/org-appear")
  :pin "0b3b029d5851c77ee792727b280f062eaf2c22c7")

;; mixed-pitch-face available
(package! mixed-pitch :pin "519e05f74825abf04b7d2e0e38ec040d013a125a")

;; (package! org-pretty-table
  ;; :recipe (:host github :repo "Fuco1/org-pretty-table") :pin "474ad84a8f...")
;; (package! org-fragtog :pin "0151cabc7a...")
(package! org-fancy-priorities :disable t)

;; (package! pandoc-mode)

;; hydra depends on
;; (package! pretty-hydra :pin "84c1929a5153be169ca5c36737439d51dffde505")

(package! ess-view-data :pin "283251e8ac19ac0c0f89a4b0f0eb38482167e52b")

(package! conda :pin "dce431b25f5a13af58cc7cacfa7968b5a888609c")

;; annotation in symlinked doc
(package! org-noter :recipe (:local-repo "local/org-noter"
                             :branch "patch"))

;; useful!
(package! ctrlf)
(package! deadgrep)
(package! easy-kill)

(package! org-roam-server :pin "2122a61e9e9be205355c7e2c1e4b65986d6985a5")

(package! org-transclusion
  :recipe (:host github :repo "nobiot/org-transclusion"))
;; (package! org-clock-budget
;;   :recipe (:host github :repo "Fuco1/org-clock-budget"))

(package! git-link :pin "2b510cf3f28bed842853294fc4ee23c7f8b6435a")

;; disabled, use lispyville
;; (package! lispy :disable t)
;; (package! lispyville :disable t)

;; need review
(package! org-clock-convenience)
(package! company-posframe :disable t)
(package! lexic
  :pin "4ded6be2ce3e8dadc5635a534827181a8c8ab602"
  :disable t)

;; (package! orderless)
;; (package! yaml-mode)
;; (package! anki-editor)
;; (package! ox-texinfo+
  ;; :recipe (:host github :repo "tarsius/ox-texinfo-plus"))

(package! lorem-ipsum)


;;; scimax
(package! scimax :recipe (:local-repo "local/scimax"
                          :files (
                                  "scimax-org.el"
                                  "scimax-stealing.el"
                                  "scimax-elfeed.el"                 ;; email elfeed
                                  "scimax-autoformat-abbrev.el"      ;; abbrev
                                  "emacs-keybinding-command-tooltip-mode.el"
                                  ;; "scimax-hydra.el"
                                  )
                          :branch "patch"))

;;; nano-mu4e
;; (package! svg-tag-mode :recipe (:repo "rougier/svg-tag-mode"
;;                                 :host github))
;; (package! mu4e-thread-folding :recipe (:repo "rougier/mu4e-thread-folding"
;;                                        :host github))
;; (package! mu4e-dashboard :recipe (:repo "rougier/mu4e-dashboard"
;;                                   :host github))

;;; nano-emacs
(package! nano-emacs :recipe (:repo "jonghyun-yun/nano-emacs"
                              :host github))
