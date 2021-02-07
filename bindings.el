;;; ~/Dropbox/emacs/.doom.d/bindings.el -*- lexical-binding: t; -*-
;; (map! :map org-mode-map
;;       :nivme "TAB" #'org-cycle
;;       :nivme "S-TAB" #'org-shifttab
;;       :nivme "<tab>" #'org-cycle
;;       :nivme "<S-tab>" #'org-shifttab
;; )

(after! evil-org
  (map!  (:map evil-org-mode-map
          ;; disabling navigate table cells (from insert-mode)
          :i  "C-l"    nil
          :i  "C-h"    nil
          :i  "C-k"    nil
          :i  "C-j"    nil
          )
         )
  )

(map!
 ;; C-x C-b to ibuffer
 [remap list-buffers] #'ibuffer
 ;; window management (prefix "C-w")
 (:map evil-window-map
  ;; Navigation
  "C-h"            nil
  "C-j"            nil
  "C-k"            nil
  "C-l"            nil
  "<left>"            #'evil-window-left
  "<down>"            #'evil-window-down
  "<up>"              #'evil-window-up
  "<right>"           #'evil-window-right
  )
 
 (:map cdlatex-mode-map
  :ie "TAB"           #'cdlatex-tab)

 ;; gl for evil-org-mode
 :nv "gl"    nil
 :nv "gL"    nil
 ;; evil-lion
 :nv "gLl"            #'evil-lion-left
 :nv "gLr"            #'evil-lion-right

 (:map org-mode-map
  :n "C-k"       #'org-kill-line
  :n "C-j"       #'org-return)

 ;; insert-mode C-k
 :i "C-k"             #'kill-line

 ;; Org commands
 :g "C-c a"           #'org-agenda
 :g "C-c c"           #'org-capture
 :g "C-c l"           #'org-store-link

 ;; ;; elfeed-score
 ;; (:map elfeed-search-mode-map
 ;;  :e "="      #'elfeed-score-map)

 )

;; (when (featurep! :lang org +roam)
;;   (global-set-key (kbd "C-c l") #'org-roam-store-link)
;;   )

(bind-keys* :prefix-map gtd-mode-map
            :prefix "C-c g"
           )

(bind-keys :map gtd-mode-map
           ("i" . my-org-agenda-inbox)
           ("s" . my-org-super-agenda-view)
           ("r" . my-org-agenda-routine)
           ;; review
           ("d" . my-new-daily-review)
           ("w" . my-new-weekly-review)
           ("m" . my-new-monthly-review)
           ;; calendar
           ("c" . my-open-calendar)
           ("o" . my-open-org-calendar)
           ("f" . org-gcal-fetch)
           ("D" . org-gcal-delete-at-point)
           ("P" . org-gcal-post-at-point)
           )

(map!
 (:map cfw:calendar-mode-map
  :e "R" #'cfw:hide-routines)

 ;; (:map inferior-ess-mode-map
  ;; "tab" #'completion-at-point)

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
 )

(map! :g "C-c s t" #'+lookup/dictionary-definition
      :leader
      "i m" #'mathpix-screenshot)

(when (featurep! :private write)
  (map!
   :g "C-c s T" #'wordnut-lookup-current-word
   :g "C-c s w" #'wordnut-search
   :g "C-c s p" #'academic-phrases
   :g "C-c s s" #'academic-phrases-by-section
   :g "C-c s m" #'mw-thesaurus-lookup-at-point
   ;; :g "C-c s l" #'synosaurus-lookup
   :g "C-c s r" #'synosaurus-choose-and-replace
   :g "C-c s i" #'synosaurus-choose-and-insert
   )
  )

;; hydra key bindings
(with-eval-after-load 'smerge-mode
  (bind-keys :map smerge-mode-map
             ("C-c ^ ." . my-hydra-smerge/body))
  )

(with-eval-after-load 'git-timemachine
  (map! (:map git-timemachine-mode-map
         :desc "Git Timemachine Hydra"
         :nv "gt." #'my-hydra-timemachine/body))
        )

(with-eval-after-load 'org
  (map!
   (:map org-mode-map
    :desc "Org Babel Hydra"
    :g "C-c C-v ." #'my-hydra-org-babel/body)
  (:map org-agenda-mode-map
   :localleader
   :desc "Org Agenda Hydra" "." #'my-hydra-org-agenda/body)
  )
)

(map!
 (:leader
  :desc "Bookmark Hydra" "f z" #'my-hydra-bm/body
  :desc "Code Fold Hydra" "z." #'my-hydra-fold/body)
 (:map pdf-view-mode-map
  :localleader
  :desc "PDF View Hydra" "." #'my-hydra-pdf-tools/body)
 )
