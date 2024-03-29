;;; ~/Dropbox/emacs/.doom.d/bindings.el -*- lexical-binding: t; -*-

;; (map! :map org-mode-map
;;       :nivme "TAB" #'org-cycle
;;       :nivme "S-TAB" #'org-shifttab
;;       :nivme "<tab>" #'org-cycle
;;       :nivme "<S-tab>" #'org-shifttab
;; )

;;; org
(map!  (:after evil-org
        :map evil-org-mode-map
        ;; disabling navigate table cells (from insert-mode)
        :i  "C-l"    nil
        :i  "C-h"    nil
        :i  "C-k"    nil
        :i  "C-j"    nil)
       (:map org-mode-map
        :n "C-k"       #'org-kill-line
        :n "C-j"       #'org-return
        :g "C-c C-v C-g" #'jyun/insert-src-block-name
        )

       ;; insert-mode C-k
       :i "C-k" #'kill-line

       ;; Org commands
       :g "C-c a" #'org-agenda
       :g "C-c c" #'org-capture
       :g "C-c l" #'org-store-link)

(map!
 :map org-tree-slide-mode-map
 :g "C-?" #'org-tree-slide-content
 :g "C-:" #'jyun/org-present-latex-preview
 )

;;; gtd
(bind-keys* :prefix-map gtd-mode-map
            :prefix "C-c g")

(bind-keys :map gtd-mode-map
           ("i" . my-org-agenda-inbox)
           ("s" . my-org-super-agenda-view)
           ("r" . my-org-agenda-routine)
           ;; review
           ("d" . my-new-daily-review)
           ("w" . my-new-weekly-review)
           ("m" . my-new-monthly-review)
           ;; calendar
           ("c" . =jyun/calendar)
           ;; ("o" . my-open-org-calendar)
           ("f" . org-gcal-fetch)
           ("D" . org-gcal-delete-at-point)
           ("P" . org-gcal-post-at-point)
           ;; agenda
           ("g" . consult-org-agenda))

;;; org-roam
(bind-keys* :prefix-map org-roam-mode-map
            :prefix "C-c r")

(map!
 (:map org-roam-mode-map
  :g
  "p" #'dw/org-roam-find-project
  "t" #'dw/org-roam-capture-task
  "r" #'org-roam-buffer-toggle
  "f" #'org-roam-node-find
  "u" #'org-roam-ui-open
  "g" #'org-roam-graph
  "i" #'org-roam-node-insert
  "I" #'org-roam-node-insert-immediate
  )
 :leader
 "n r p" #'dw/org-roam-find-project
 "n r t" #'dw/org-roam-capture-task
 "n r u" #'org-roam-ui-open
 "n r I" #'org-roam-node-insert-immediate)

;;;; org-roam-dailies
;; deprecated: use default one
;; (map! :leader
;;       (:prefix-map ("n" . "notes")
;;        (:when (modulep! :lang org +roam)
;;         (:prefix ("r" . "roam")
;;          (:prefix ("d" . "by date")
;;           "." #'org-roam-dailies-find-directory
;;           "b" #'org-roam-dailies-find-previous-note
;;           "f" #'org-roam-dailies-find-next-note
;;           "n" #'org-roam-dailies-capture-today
;;           "v" #'org-roam-dailies-capture-date)))))

;;; evil
(map!
;;;; gl for evil-org-mode
 :nv "gl"    nil
 :nv "gL"    nil
 ;; evil-lion
 :nv "gLl"            #'evil-lion-left
 :nv "gLr"            #'evil-lion-right



;;;; Navigation
 (:map evil-window-map
  "C-h"            nil
  "C-j"            nil
  "C-k"            nil
  "C-l"            nil
  "<left>"            #'evil-window-left
  "<down>"            #'evil-window-down
  "<up>"              #'evil-window-up
  "<right>"           #'evil-window-right)
 )

;;; misc
(map!
 ;; C-x C-b to ibuffer
 ;; [remap list-buffers]
 ;; #'ibuffer
 ;; window management (prefix "C-w")

 (:map cdlatex-mode-map
  :ie "TAB"           #'cdlatex-tab)

 (:map dired-mode-map
  :nvme "W" #'+macos-open-with
  :nvme "S" #'dired-do-symlink
  :nvme [tab] #'dired-subtree-toggle)
 )

;;; calendar
(map!
 :leader
 :desc "Calendar" "o c" #'=calendar
 (:map cfw:calendar-mode-map
  :after calfw
  :g "R" #'cfw:hide-routines
  :g "C" #'cfw:org-capture) ;; c and C for capture
 )

;; (:map inferior-ess-mode-map
;; "tab" #'completion-at-point)

;;; window management
(map!
 :n "C-t"   nil
 :n "C-S-t" nil
 :g "M-1"   #'winum-select-window-1
 :g "M-2"   #'winum-select-window-2
 :g "M-3"   #'winum-select-window-3
 :g "M-4"   #'winum-select-window-4
 :g "M-5"   #'winum-select-window-5
 :g "M-6"   #'winum-select-window-6
 :g "M-7"   #'winum-select-window-7
 :g "M-8"   #'winum-select-window-8
 :g "M-9"   #'winum-select-window-9
 :g "M-0"   #'winum-select-window-0-or-10

 :n "SPC 1" #'winum-select-window-1
 :n "SPC 2" #'winum-select-window-2
 :n "SPC 3" #'winum-select-window-3
 :n "SPC 4" #'winum-select-window-4
 :n "SPC 5" #'winum-select-window-5
 :n "SPC 6" #'winum-select-window-6
 :n "SPC 7" #'winum-select-window-7
 :n "SPC 8" #'winum-select-window-8
 :n "SPC 9" #'winum-select-window-9
 :n "SPC 0" #'winum-select-window-0-or-10

 ;; :g "s-t"   nil
 ;; :g "s-T"   nil
 :g "s-1"   #'+workspace/switch-to-0
 :g "s-2"   #'+workspace/switch-to-1
 :g "s-3"   #'+workspace/switch-to-2
 :g "s-4"   #'+workspace/switch-to-3
 :g "s-5"   #'+workspace/switch-to-4
 :g "s-6"   #'+workspace/switch-to-5
 :g "s-7"   #'+workspace/switch-to-6
 :g "s-8"   #'+workspace/switch-to-7
 :g "s-9"   #'+workspace/switch-to-8
 :g "s-0"   #'+workspace/switch-to-final

 (:leader
  :desc "2 by 4 grid"
  "wg4" #'my-hydra-window/spacemacs/window-split-grid-2by4
  :desc "2 by 3 grid"
  "wg3" #'my-hydra-window/spacemacs/window-split-grid-2by3
  :desc "2 by 2 grid"
  "wg2" #'my-hydra-window/spacemacs/window-split-grid)

 (:map persp-mode-map
  :leader
  "wc" nil
  :desc "Triple columns"
  "wc3" #'my-hydra-window/spacemacs/window-split-triple-columns)
  )


;;; mathpix
(map! :g "C-c s t" #'+lookup/dictionary-definition
      :leader
      ;; "i m" #'mathpix-screenshot
      "i m" #'jyun/mathpix-screenshot)

;;; dictionary
(when (modulep! :private write)
  (map!
   :g "C-c s T" #'wordnut-lookup-current-word
   :g "C-c s w" #'wordnut-search
   :g "C-c s p" #'academic-phrases
   :g "C-c s S" #'academic-phrases-by-section
   :g "C-c s m" #'mw-thesaurus-lookup-at-point
   ;; :g "C-c s l" #'synosaurus-lookup
   :g "C-c s r" #'synosaurus-choose-and-replace
   :g "C-c s i" #'synosaurus-choose-and-insert))

;;; langtool
(when (modulep! :private grammar)
  (map!
   :g "C-c s c" #'langtool-correct-buffer
   :g "C-c s d" #'langtool-check-done
   :g "C-c s s" #'langtool-check
   :leader
   "sgc" #'langtool-correct-buffer
   "sgs" #'langtool-check
   "sgd" #'langtool-check-done)
  )

;;; hydra key bindings
;; these keymaps are activated after the packages loading.
(with-eval-after-load 'smerge-mode
  (bind-keys :map smerge-mode-map
             ("C-c ^ ." . my-hydra-smerge/body)))

(with-eval-after-load 'git-timemachine
  (map! (:map git-timemachine-mode-map
         :desc "Git Timemachine Hydra"
         :nv "gt." #'my-hydra-timemachine/body)))
(map!
 (:leader
  :desc "Switch workspace"
  "TAB e" #'+workspace/switch-to
  :desc "Layouts Hydra"
  "TAB ." #'my-hydra-layouts/body
  ;; "TAB c" #'jyun/workspace-create
  :desc "Code Fold Hydra" "z." #'my-hydra-fold/body)
 (:map pdf-view-mode-map
  :localleader
  :desc "PDF View Hydra" "." #'my-hydra-pdf-tools/body)
 (:map org-mode-map
  :desc "Org Babel Hydra"
  :g "C-c C-v ." #'scimax-src-block-hydra/body)
 (:map org-agenda-mode-map
  :localleader
  :desc "Org Agenda Hydra" "." #'my-hydra-org-agenda/body))

;;; ess
(map! (:map ess-r-package-dev-map
       "I" #'ess-r-devtools-clean-and-rebuild-package
       ))

;;; elfeed
(map!
 :leader
 :desc "Newsfeed" "o n"  #'=rss
 ;;;; elfeed-score
 (:map elfeed-search-mode-map
  :after elfeed-score
  :e "="      #'elfeed-score-map)
 )
;;;; elfeed search map
(map!
 (:map elfeed-search-mode-map
  :after elfeed-search
  ;; [remap kill-this-buffer] "q"
  ;; [remap kill-buffer] "q"
  ;; :n doom-leader-key nil
  ;; :n "q" #'+rss/quit
  ;; :n "U" #'elfeed-search-untag-all-unread
  ;; :n "u" #'elfeed-search-tag-all-unread
  ;; :n "s" #'elfeed-search-live-filter
  :ne "c" #'elfeed-search-clear-filter
  :ne "RET" #'+rss/open
  ;; :n "+" #'elfeed-search-tag-all
  ;; :n "-" #'elfeed-search-untag-all
  ;; :n "S" #'elfeed-search-set-filter
  ;; :n "M-RET" #'elfeed-search-browse-url
  ;; :n "y" #'elfeed-search-yank
  ;; :ne "p" #'elfeed-show-pdf))
))
;;;; elfeed show map
;; (map!
;;  (:map elfeed-show-mode-map
;;   :after elfeed-show
;;   ;; [remap kill-this-buffer] "q"
;;   ;; [remap kill-buffer] "q"
;;   ;; :n doom-leader-key nil
;;   ;; :nme "q" #'+rss/delete-pane
;;   :nme "e" #'email-elfeed-entry
;;   ;; :nm "o" #'ace-link-elfeed
;;   ;; :nm "RET" #'org-ref-elfeed-add
;;   ;; [remap elfeed-show-next] #'+rss/next
;;   ;; [remap elfeed-show-prev] #'rss/previous ;;error
;;   :nme "p" #'elfeed-show-pdf
;;   :nme "C" #'jyun/elfeed-org-capture-entry
;;   ;; :nm "+" #'elfeed-show-tag
;;   ;; :nm "-" #'elfeed-show-untag
;;   ;; :nm "s" #'elfeed-show-new-live-search
;;   ;; :nm "y" #'elfeed-show-yank
;;   ))

;;; scimax
(map!
 :g
 :desc "Errors Hydra" "C-c ! ." (cmd! (scimax-open-hydra scimax-errors/body))
 "s-<up>" #'beginning-of-buffer
 "s-<down>" #'end-of-buffer)

;;; smartparen bindings
(map!
 (:after smartparens
  :map smartparens-mode-map
  "C-M-f" #'sp-forward-sexp
  "C-M-b" #'sp-backward-sexp
  "C-M-u" #'sp-backward-up-sexp
  "C-M-d" #'sp-down-sexp
  "C-M-p" #'sp-backward-down-sexp
  "C-M-n" #'sp-up-sexp
  "C-M-s" #'sp-splice-sexp
  "C-)" #'sp-forward-slurp-sexp
  "C-}" #'sp-forward-barf-sexp
  "C-(" #'sp-backward-slurp-sexp
  "C-{" #'sp-backward-barf-sexp))

;;; multiple-cursours
(map!
 (:when (modulep! :editor multiple-cursors)
  :nv "C-M-d" nil
  :nv "C-M-S-d" #'evil-multiedit-restore))

;;; company
(map!
 (:after company
  :i "C-x c" #'+company/complete
  :leader "i c" #'+company/complete)
 )

;;; emacs binding in insert mode
(map! :i "C-p" 'previous-line
      :i "C-n" 'next-line
      :i "C-u" 'universal-argument
      :i "C-c y" 'company-yasnippet
      :i "C-x C-s" 'save-buffer
      )

;;; ignore bindings
;; (global-set-key [C-wheel-up]  'ignore)
;; (global-set-key [C-wheel-down] 'ignore)

;;; kill-region + easy-kill
;; no S-delete can be mapped in MAC
;; C-backspace should be mapped using C-DEL
(map! :g "<C-backspace>" #'kill-region
      (:after easy-kill
       :map easy-kill-base-map
       :g "C-w" #'easy-kill-region))

;;; doom
(map!
 :leader
 :desc "doom/magit-fetch" "h d g" #'jyun/fetch-doom-emacs
 "h d i" #'doom/goto-private-init-file
 "h d C" nil
 :desc "Toggle truncate lines" "t n" #'toggle-truncate-lines)

;;; make
(when (modulep! :tools make)
  (map!
   :leader
   :desc "Run make" "c m" #'jyun/make
   ))

;;; citar
;; (map! (:map citar-map
;;        "p" #'citar-open-bibtex-pdf)
;;       (:map citar-citation-map
;;        "p" #'citar-open-bibtex-pdf))

;;; ess
(map!
 :desc "Rscript a current buffer"
 :g "C-c e b" #'jyun/save-current-buffer-and-run-Rscript
 :desc "Rscript at point"
 :g "C-c e e" #'jyun/run-Rscript-at-point
 :desc "Rscript the last file"
 :g "C-c e l" #'jyun/run-last-Rscript-file
 :desc "Rscript a file"
 :g "C-c e f" #'jyun/find-and-run-Rscript-file
 :desc "Tangle src block and Rscrit its target"
 :g "C-c e t" #'jyun/tangle-and-run-Rscript-src-block
 )

;;; org babel
(after! org
  (map!
   (:map org-mode-map
    :g "C-c C-v y" #'jyun/org-babel-yank-src-block
    :g "C-c C-v C-u" #'jyun/org-babel-goto-src-block-end
    )))

;;; pdf
(map! :map pdf-view-mode-map
      :ng "C-w" #'jyun/fit-window-to-pdf
      :ng "M-C-w" #'jyun/toggle-fit-window-to-pdf)
