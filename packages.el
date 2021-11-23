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

;;; mu4e
(when (featurep! :email mu4e)
  (package! mu4e-maildirs-extension)
  (package! mu4e-alert :disable t)
  )

;;; latex
(package! latexdiff)
;; (package! latexdiff
  ;; :recipe (:host github :repo "galaunay/latexdiff.el"))

;; https://github.com/emacs-straight/auctex
;; auctex preview fix
;; (package! auctex :pin "1472d1d231aeae463013d5e36307605157f84191")


;;; matlab
;; (package! matlab-mode)
(package! matlab-mode :recipe (:host github :repo "matlab-mode/mirror"))


;;; search
(package! find-file-in-project :pin "cb5f3d1b697ef8212cc276c7486cbce2bf6c2a02")

;;; org
(package! org-fancy-priorities :disable t) ; slowdown emacs

;; annotation in symlinked doc
;; (package! org-noter :recipe (:local-repo "local/org-noter"
;;                              :branch "patch"))

(package! org-noter :recipe (:host github :repo "jonghyun-yun/org-noter"))

;; Github flavored markdown exporter
(package! ox-gfm)
(package! org-re-reveal-ref)
(package! org-transclusion
  :recipe (:host github :repo "nobiot/org-transclusion"))
;; (package! org-clock-budget
;;   :recipe (:host github :repo "Fuco1/org-clock-budget"))

;; ;; export doesn't work. problem in compiling; defmacro and marco eval in the same file
;; ;; ;; Load it localy
;; (package! ox-ravel
;;   :recipe (:host github
;;            :repo "jonghyun-yun/ox-ravel"
;;            :files ("*.el")
;;            )
;;   )

;; (package! ox-hugo
;;   :recipe (:local-repo "local/ox-hugo"
;;            :branch "patch"))

(package! ox-hugo
  :recipe (:host nil
           :repo "https://github.com/jonghyun-yun/ox-hugo"
           :branch "patch")
  ;; :pin "1f875262b152aa0e57844b4c83aae4951d52a3fe"
  )

;; (package! org-cv
;;   :recipe (:host github
;;            :repo "jonghyun-yun/org-cv"
;;            :files ("*.el"))
;;   ;; :pin "47ee61ce4538fe4406a68b4cfcf606e68e1f7261")
;;   :pin "219203e872b2bead5805544f65c9c7294e81e071")

;; org-mode presentation
;; (package! org-present)
;; (package! epresent)

;;; elfeed
(package! elfeed-goodies :disable t)
(package! elfeed-score)
(package! elfeed-web :disable t)

;;; jabber
(package! jabber)
(package! srv) ;; jabber dependency
(package! fsm) ;; jabber dependency

;;; visual
;; mixed-pitch-face available
;; (package! mixed-pitch :pin "519e05f74825abf04b7d2e0e38ec040d013a125a")
(package! modus-themes :disable t)
;; (package! doom-themes :disable t)

;;; coding
(package! ess-view-data :pin "283251e8ac19ac0c0f89a4b0f0eb38482167e52b")
(package! graphviz-dot-mode :pin "3642a0a5f41a80c8ecef7c6143d514200b80e194")
(package! conda :pin "dce431b25f5a13af58cc7cacfa7968b5a888609c")

;;; convenience
(package! ctrlf)
(package! deadgrep)
(package! easy-kill)
(package! git-link :pin "2b510cf3f28bed842853294fc4ee23c7f8b6435a")
(package! visual-regexp :pin "48457d42a5e0fe10fa3a9c15854f1f127ade09b5")
;; (package! visual-regexp-steroids :pin "a6420b25ec0fbba43bf57875827092e1196d8a9e")
(package! key-chord)
(package! golden-ratio.el
  :recipe (:host github :repo "roman/golden-ratio.el"))

;;; org-roam
;; (package! org-roam
  ;; :pin "d93423d4e11da95bcf177b2bc3c74cb1d1acf807")
(package! org-roam-ui :pin "9fcc9a8d716254565d06082bc6e861b259c132fd")
;; (package! org-roam-ui :recipe (:host github :repo "org-roam/org-roam-ui" :files ("*.el" "out")) :pin "c745d07018a46b1a20b9f571d999ecf7a092c2e1")
;; (package! websocket :pin "fda4455333309545c0787a79d73c19ddbeb57980") ; dependency of `org-roam-ui'
(package! websocket) ; dependency of `org-roam-ui'

;;; scimax
;; keep it here (not in scimax module)
(package! scimax :recipe (:local-repo "local/scimax"
                          :files (
                                  "scimax-org.el"
                                  "scimax-stealing.el"
                                  "scimax-elfeed.el"            ;; email elfeed
                                  "scimax-autoformat-abbrev.el" ;; abbrev
                                  "emacs-keybinding-command-tooltip-mode.el"
                                  "scimax-hydra.el"
                                  )
                          :branch "patch"))

;;; misc
(package! lorem-ipsum)
;; (package! selectric-mode :pin "1840de71f7414b7cd6ce425747c8e26a413233aa"
;;   :disable t)

;;; doom-snippets
(package! doom-snippets
  :recipe (:host nil
           :repo "https://github.com/jonghyun-yun/doom-snippets"
           :files ("*.el" "*"))
  ;; :pin "f1f18df5898233d3b1a4a28fc4df48e257d21667"
)

;;; tempo fixes
;; missing org-mac-link.el
;; (package! org-contrib
;;   :recipe (:host nil
;;            :repo "https://git.sr.ht/~bzg/org-contrib"
;;            )
;;   :pin "e14dfea59491f889f35868813122c5b8c0b4b3db")

(package! org-mac-link
  :recipe (:host nil :repo "https://git.sr.ht/~bzg/org-contrib"
           :files ("lisp/org-mac-link.el"))
  :pin "e14dfea59491f889f35868813122c5b8c0b4b3db"
  )

;; (package! org-gcal :pin "8b6df4b727339e3933c68045e104b6b1d99816f7")
;; (package! org-gcal :pin "52b7f8f7654e391f51e8d6d40506c8c170a5be20")
;; (package! org-gcal :pin "133cca813abd2823a6e2a9ada295b7b8b115be4f")

;;; testing new packages
(package! vertico-posframe :disable t)
(package! org-clock-convenience :disable t)
