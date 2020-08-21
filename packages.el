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

(package! mathpix.el
  :recipe (:host github :repo "jethrokuan/mathpix.el"))

(package! matlab-mode)

;; (package! scihub)

(package! find-file-in-project)

;; (package! wordnut :pin "feac531404041855312c1a046bde7ea18c674915")
;; (package! synosaurus :pin "14d34fc92a77c3a916b4d58400424c44ae99cd81")

;; (package! org-pdftools)
;; (package! org-noter-pdftools)

;; Rmd export doesn't work. Load it localy
;; (package! ox-ravel
;;   :recipe (:host github
;;            :repo "jonghyun-yun/ox-ravel"
;;            ;;          :branch "org-plus-9"
;;            :files ("ox-ravel.el"))
;;   :pin "f6410c256b5d14f5257252698e08785e5670b92a"
;;   )

(package! ox-hugo
  :recipe (:host github :repo "jonghyun-yun/ox-hugo" :nonrecursive t))

(package! org-cv
  :recipe (:host github
           :repo "jonghyun-yun/org-cv"
           :files ("*.el"))
  ;; :pin "47ee61ce4538fe4406a68b4cfcf606e68e1f7261")
  :pin "219203e872b2bead5805544f65c9c7294e81e071")

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
