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

;;; mu4e
;; (when (modulep! :email mu4e)
;;   (package! mu4e-maildirs-extension)
;;   (package! mu4e-alert :disable t)
;;   )

;;; latex
(when (modulep! :lang latex)
  (package! latexdiff)
  ;; (package! latexdiff
  ;; :recipe (:host github :repo "galaunay/latexdiff.el"))
  ;; https://github.com/emacs-straight/auctex
  ;; auctex preview fix
  ;; (package! auctex :pin "1472d1d231aeae463013d5e36307605157f84191")

  ;; (package! lsp-ltex)
  )

;;; matlab
;; (package! matlab-mode)

;;; org
;; (package! org-fancy-priorities) ; slowdown emacs

;; annotation in symlinked doc
;; (package! org-noter :recipe (:local-repo "local/org-noter"
;;                              :branch "patch"))

;; (when (modulep! :lang org +noter)
;;   (package! org-noter :recipe
;;     (:host github
;;      :repo "org-noter/org-noter")
;;     )
;; )

;; Github flavored markdown exporter
;; (package! ox-gfm)
;; (package! org-transclusion
;;   :recipe (:host github :repo "nobiot/org-transclusion")
;;   )
;; ;; (package! org-clock-budget
;; ;;   :recipe (:host github :repo "Fuco1/org-clock-budget"))
;; (package! org-remark
;;   :recipe (:host github :repo "nobiot/org-remark")
;;   )

;; (package! ox-hugo
;;   :recipe (:local-repo "local/ox-hugo"
;;            :branch "patch"))

;   (package! ox-hugo
;     :recipe (:host github
;              :repo "jonghyun-yun/ox-hugo"
;              :branch "patch-2")
;     ;; :pin "1f875262b152aa0e57844b4c83aae4951d52a3fe"
;     :pin "144f646a090156ab828aa30552aaedea27b5e5c1"
;     :disable nil
;     )

;; (package! org-cv
;;   :recipe (:host github
;;            :repo "jonghyun-yun/org-cv"
;;            :files ("*.el"))
;;   ;; :pin "47ee61ce4538fe4406a68b4cfcf606e68e1f7261")
;;   :pin "219203e872b2bead5805544f65c9c7294e81e071")

;; org-mode presentation
;; (package! org-present)
;; (package! epresent)
;; ;; export doesn't work. problem in compiling; defmacro and marco eval in the same file
;; ;; ;; Load it localy
;; (package! ox-ravel
;;   :recipe (:host github
;;            :repo "jonghyun-yun/ox-ravel"
;;            :files ("*.el")
;;            )
;;   )
;; (package! org-re-reveal-ref)

(package! centered-window
  :disable t)
;; (package! org-tree-slide
;;   :disable t)

;;; jabber
;; (package! jabber)
;; (package! srv) ;; jabber dependency
;; (package! fsm) ;; jabber dependency

;;; visual
;; mixed-pitch-face available
;; (package! mixed-pitch :pin "519e05f74825abf04b7d2e0e38ec040d013a125a")
(package! modus-themes)
;; (package! ef-themes)

;;; coding
;; (package! ess-view-data :pin "283251e8ac19ac0c0f89a4b0f0eb38482167e52b")
;; (package! graphviz-dot-mode :pin "3642a0a5f41a80c8ecef7c6143d514200b80e194")

;;; convenience
(package! ctrlf)
(package! deadgrep)
(package! easy-kill)

;; (package! git-link :pin "2b510cf3f28bed842853294fc4ee23c7f8b6435a") ; use browse-at-remote SPC g y/Y
(package! visual-regexp :pin "48457d42a5e0fe10fa3a9c15854f1f127ade09b5")
(package! visual-regexp-steroids :pin "a6420b25ec0fbba43bf57875827092e1196d8a9e")

;; (package! key-chord)
;; (package! golden-ratio.el
;;   :recipe (:host github :repo "roman/golden-ratio.el"))

;;; org-roam
;; (package! org-roam
  ;; :pin "d93423d4e11da95bcf177b2bc3c74cb1d1acf807")
(package! org-roam-ui :pin "9ed0c5705a302a91fab2b8bcc777a12dcf9b3682" :disable t)
;; (package! org-roam-ui :recipe (:host github :repo "org-roam/org-roam-ui" :files ("*.el" "out")) :pin "c745d07018a46b1a20b9f571d999ecf7a092c2e1")
;; (package! websocket :pin "fda4455333309545c0787a79d73c19ddbeb57980") ; dependency of `org-roam-ui'
;; (package! websocket) ; dependency of `org-roam-ui'

;;; scimax
;; keep it here (not in scimax module)
;; (package! scimax
;;   :recipe (:local-repo "local/scimax"
;;            :files (
;;                    "scimax-org.el"
;;                    "scimax-stealing.el"
;;                    "scimax-elfeed.el"            ;; email elfeed
;;                    "scimax-autoformat-abbrev.el" ;; abbrev
;;                    "emacs-keybinding-command-tooltip-mode.el"
;;                    ;; "scimax-hydra.el"
;;                    )
;;            :branch "patch")
;;   )

;;; misc
(package! lorem-ipsum)

;;; doom-snippets
;; (package! doom-snippets
;;   :recipe (:host github
;;            :repo "jonghyun-yun/doom-snippets"
;;            :files (:defaults "*"))
;;   :pin "f1f18df5898233d3b1a4a28fc4df48e257d21667")

;; (when (modulep! :editor snippets)
;;   (package! doom-snippets
;;     :recipe (:local-repo "local/doom-snippets"
;;              :files (:defaults "*")))
;;   )

;; somehow it looks for this package during the initialization of org-roam
(when IS-LINUX
  (package! org-mac-link :pin "0b18c1d070b9601cc65c40e902169e367e4348c9"))

;;; posframe
;; (package! company-posframe :disable t)
;; (package! which-key-posframe)
;; (package! transient-posframe :disable t)
;; (package! vertico-posframe)
;; (package! hydra-posframe
;;   :recipe (:host github
;;            :repo "Ladicle/hydra-posframe")
;;   )
;; (package! emacs-overleaf :recipe (:local-repo "local/emacs-overleaf")
;;   )
(when (modulep! :private grammar)
  (package! langtool-posframe :recipe (:local-repo "local/langtool-posframe")
    ))

(when IS-LINUX
  (package! which-key-posframe :disable t)
  (package! vertico-posframe :disable t)
  (package! hydra-posframe :disable t)
  ;; (package! emacs-everywhere :disable t)
  )

;; (package! posframe)
;; (package! posframe)

;;; testing new packages
;; (package! org-clock-convenience)
;; (package! explain-pause-mode
;;   :recipe (:host github :repo "lastquestion/explain-pause-mode"))
;; (package! anki-editor)

;;; disabled doom packages
;; (package! github-review :disable t)
;; (package! magit-flow :disable t)        ; have no gitflow
;; (package! eshell-up :disable t)
;; (package! org-superstar :disable t)

;;; https://github.com/hlissner/doom-emacs/pull/5883
;; (package! auctex
;;   :recipe (:files (:defaults "etc" "images" "latex" "style"))
;;   :pin "3b0a080ae596c26c17b15ba9c71fc5542eae238b")
;; (package! auctex :pin "3b0a080ae596c26c17b15ba9c71fc5542eae238b"
;;   :recipe (:files ("*.el" "*.info" "dir"
;;                    "doc" "etc" "images" "latex" "style")))

;;; python
;; (package! conda :pin "7a34e06931515d46f9e22154762e06e66cfbc81c")

;;; svg
;; (package! svg-tag-mode :disable t)

;;; tab-bar
;; (package! tab-bar-echo-area
;; :recipe (:host github :repo "fritzgrabo/tab-bar-echo-area"))
;; (package! tab-bar-groups
;; :recipe (:host github :repo "fritzgrabo/tab-bar-groups"))

;;; very large file
;; (package! vlf
;;   :recipe (:host github :repo "m00natic/vlfi"
;;            :files (:defaults "*"))
;;   :pin "cc02f2533782d6b9b628cec7e2dcf25b2d05a27c"
;;   )

;;; turbo-log
;; (package! turbo-log
;;   :recipe (:host github :repo "artawower/turbo-log"))

;;; scala
(when (modulep! :lang scala)
  (package! ob-scala :recipe (:local-repo "local/ob-scala") :disable nil))

;;; toml
(package! toml-mode)

;;; org-cv
;; (package! org-cv
;;   :disable t
;;   :recipe (:local-repo "local/org-cv"))

;;; org to ipynb
;; (package! ox-ipynb
;;   :recipe (:host github
;;            :repo "jkitchin/ox-ipynb"))

;;; Linux disabled package
;; (when IS-LINUX
;;   (package! org-roam :disable t))

;;; org-mode
(package! org-modern)

;;; No GUI
;; (unless (display-graphic-p)
;;   (package! writeroom-mode :disable t)
;;   (package! mixed-pitch :disable t)
;;   )

;;; appearance
;; (package! lin
;;   :recipe (:host nil
;;            :repo "https://git.sr.ht/~protesilaos/lin")
;;   )
;; (package! pulsar
;;   :recipe (:host nil
;;            :repo "https://git.sr.ht/~protesilaos/pulsar"))

;;; elfeed
;;; elfeed tube
(when (modulep! :app rss)
  ;; (package! elfeed-goodies :disable t)
  (package! elfeed-score)
  (package! elfeed-summary)
  ;; (package! elfeed-web :disable t)
  (package! elfeed-tube
    :recipe
    (:host github
     :repo "karthink/elfeed-tube"))
  (package! elfeed-tube-mpv
    :recipe
    (:host github
     :repo "karthink/elfeed-tube")
    )
  (package! mpv)
  )

;;; cypher
(package! cypher-mode
  :disable t
  :recipe (:host github
           :repo "jonghyun-yun/cypher-mode"
           :branch "master")
  ;; :pin "1f875262b152aa0e57844b4c83aae4951d52a3fe"
  )

;;; osm
;; (package! osm)

;;; openwith
;; (package! openwith :disable t)

;;; Copilot-like AI autocomplete
(package! codeium
  :recipe (:host github
           :repo "Exafunction/codeium.el")
  :disable t)

(package! copilot
  :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el"))
  )

(package! ispell)


(package! gptel
  :recipe (:host github :repo "karthink/gptel")
  :pin "3ad7a36250eaed8b68bb7fbd264877ef62bdf2b5")

(package! gptel-agent
  :recipe (:host github :repo "karthink/gptel-agent"))
(package! mcp
  :recipe (:host github :repo "lizqwerscott/mcp.el"))
(package! gptel-mcp
  :recipe (:host github :repo "lizqwerscott/gptel-mcp.el"))


(package! llm-tool-collection
  :recipe (:host github :repo "skissue/llm-tool-collection")
  :disable t)

(package! ragmacs
  :recipe (:host github :repo "positron-solutions/ragmacs"))

(package! gptel-got
  :recipe (:host nil
	   :repo "https://codeberg.org/bajsicki/gptel-got")
  :disable t)
