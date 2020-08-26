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
)

;; (when (featurep! :lang org +roam)
;;   (global-set-key (kbd "C-c l") #'org-roam-store-link)
;;   )

(bind-keys* :prefix-map gtd-map
            :prefix "C-c g"
           )

(bind-keys :map gtd-map
           ("i" . my-org-agenda-inbox)
           ("s" . my-org-super-agenda-view)
           ;; review
           ("r d" . my-new-daily-review)
           ("r w" . my-new-weekly-review)
           ("r m" . my-new-monthly-review)
           ;; calendar
           ("c c" . my-open-calendar)
           ("c o" . my-open-org-calendar)
           ("c f" . org-gcal-fetch)
           ("c D" . org-gcal-delete-at-point)
           ("c P" . org-gcal-post-at-point)
           )

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
 )

(map! :g "C-c s t" #'+lookup/dictionary-definition)

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

(map! :leader
      "i m" #'mathpix-screenshot)
