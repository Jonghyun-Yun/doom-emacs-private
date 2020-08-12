;;; ~/Dropbox/emacs/.doom.d/+binding.el -*- lexical-binding: t; -*-

(map! :map cdlatex-mode-map
      :ie "TAB" #'cdlatex-tab)

;; (map! :ni "C-k" #'kill-line)

(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)
(global-set-key (kbd "C-c l") #'org-store-link)

(when (featurep! :lang org +roam)
  (global-set-key (kbd "C-c l") #'org-roam-store-link)
  )

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

(map!  :g "M-1"   #'winum-select-window-1
       :g "M-2"   #'winum-select-window-2
       :g "M-3"   #'winum-select-window-3
       :g "M-4"   #'winum-select-window-4
       :g "M-5"   #'winum-select-window-5
       :g "M-6"   #'winum-select-window-6
       :g "M-7"   #'winum-select-window-7
       :g "M-8"   #'winum-select-window-8
       :g "M-9"   #'winum-select-window-9
       :g "M-0"   #'winum-select-window-0-or-10

       :n "SPC 1"   #'winum-select-window-1
       :n "SPC 2"   #'winum-select-window-2
       :n "SPC 3"   #'winum-select-window-3
       :n "SPC 4"   #'winum-select-window-4
       :n "SPC 5"   #'winum-select-window-5
       :n "SPC 6"   #'winum-select-window-6
       :n "SPC 7"   #'winum-select-window-7
       :n "SPC 8"   #'winum-select-window-8
       :n "SPC 9"   #'winum-select-window-9
       :n "SPC 0"   #'winum-select-window-0-or-10
       )
