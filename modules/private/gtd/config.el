;;; private/gtd/config.el -*- lexical-binding: t; -*-

;; (use-package! org-super-agenda
;;   :after org-agenda
;;   :init
;;   ;; (evil-set-initial-state 'org-agenda-mode 'emacs)
;;   ;; (require 'org-habit)
;;   :config
;;   (org-super-agenda-mode)
;;   ;; (bind-keys ("C-c r s" . my-org-super-agenda-view))
;;   ;; (global-set-key (kbd "C-c r s") 'my-org-super-agenda-view)
;;   ;; (global-set-key (kbd "C-c r i") 'my-org-agenda-inbox)
;;   ;; (load! "lisp/gtd-plus")
;;   )

(use-package org-super-agenda
  :hook (org-agenda-mode . org-super-agenda-mode)
)

(after! org
  (add-to-list 'org-global-properties
               '("Effort_ALL" . "0:05 0:30 1:00 1:30 2:00 3:00 4:00"))

  (setq org-columns-default-format
        "%25ITEM(Task) %5TODO(Todo) %3PRIORITY %TAGS %6Effort(Effort){:}")

  ;; To disable this global tag-alist, put =#+TAGS:= in the org file.
  ;; See [[https://www.reddit.com/r/orgmode/comments/5lluoc/help_error_when_using_tag_hierarchy_startgrouptag/][{help} Error when using tag hierarchy (:startgrouptag) : orgmode]] for the tag hierarchy.
  (setq org-tag-alist '(
                        ;; Context
                        (:startgroup . "Context")
                        ("@work" . ?w) ("@home" . ?h) ("@errand" . ?d) ("@email" . ?s) ("@phone" . ?n)
                        (:endgroup . nil)
                        ;; work-related
                        ("emacs" . ?e) ("literature" . ?l) ("coding" . ?c) ("project" . ?o)
                        ("paper" . ?p) ("grant" . ?g) ("job" . ?j) ("immigration" . ?i)
                        ;; home-related
                        ("fun" . ?u) ("auto" . ?a) ("finance" . ?f) ("buy" . ?b) ("maintenance" . ?m)
                        (:startgroup . nil)
                        ("research" . ?r) ("teaching" . ?t) ("service" . ?s)
                        (:endgroup . nil)
                        ;; noexport
                        ("noexport" . ?x)))

  (setq org-todo-keywords
        '((sequence
           "TODO(t)" ; doing later
           "NEXT(n!)" ; next action
           "GO(g!)" ; active todo
           "|"
           "DONE(d)" ; done
           )
          (sequence
           "WAIT(w@)" ; waiting for some external change (event)
           "HOLD(h@)" ; waiting for some internal change (of mind)
           "IDEA(i)" ; maybe someday
           "|"
           "STOP(s@/!)" ; stopped waiting, decided not to work on it
           ;; "KILL(k@/!)" ; cancel
           )
          (sequence "[ ](T)" "[-](G)" "[?](W)" "|" "[X](D)")
          ;; [-](S) active
          ;; [?](W) onhold
          ))

    (with-no-warnings
    ;; (custom-declare-face '+org-todo-stop  '((t (:inherit (bold font-lock-constant-face org-todo)))) "")
    ;; (custom-declare-face '+org-todo-stop  '((t (:inherit (bold font-lock-string-face org-todo)))) "")
    (custom-declare-face '+org-todo-stop  '((t (:inherit (bold font-lock-doc-face org-todo)))) "")
    ;; (custom-declare-face '+org-todo-stop  '((t (:inherit (bold font-lock-type-face org-todo)))) "")
    ;; (custom-declare-face '+org-todo-idea '((t (:inherit (bold font-lock-doc-face org-todo)))) "")
    (custom-declare-face '+org-todo-next '((t (:inherit (bold org-level-7 org-todo)))) "")
    (custom-declare-face '+org-todo-idea '((t (:inherit (bold org-level-6 org-todo)))) "")
    (custom-declare-face '+org-todo-onhold  '((t (:inherit (bold warning org-todo)))) "")
    )

    ;; font-lock-builtin-face
    ;; font-lock-comment-delimiter-face
    ;; font-lock-constant-face
    ;; font-lock-doc-face
    ;; font-lock-function-name-face
    ;; font-lock-keyword-face
    ;; font-lock-negation-char-face
    ;; font-lock-preprocessor-face
    ;; font-lock-regexp-grouping-backslash
    ;; font-lock-regexp-grouping-construct
    ;; font-lock-string-face
    ;; font-lock-type-face
    ;; font-lock-variable-name-face

  (setq org-todo-keyword-faces (quote (
                                       ("[-]" . +org-todo-active)
                                       ("GO" . +org-todo-active)
                                       ("NEXT" . +org-todo-next)
                                       ("[?]" . +org-todo-onhold)
                                       ("WAIT" . +org-todo-onhold)
                                       ("HOLD" . +org-todo-onhold)
                                       ("IDEA" . +org-todo-idea)
                                       ("STOP" . +org-todo-stop)
                                       ;; ;; ("PROJ" . +org-todo-project)
                                       ;; ;; ("FAIL" :weight bold :foreground "#f2241f")
                                       ;; ;; ("TODO" :weight bold :foreground "tomato")
                                       ;; ;; ("NEXT" :weight bold :foreground "SlateGray")
                                       ;; ("NEXT" :weight bold :foreground "tomato")
                                       ;; ;; ("GO" :weight bold :foreground "orchid")
                                       ;; ;; ("GO" :weight bold :foreground "HotPink")
                                       ;; ;; ("GO" :weight bold :foreground "DarkGoldenrod3")
                                       ;; ;; ("REVIEW" :weight bold :foreground "gold")
                                       ;; ;; ("REVIEW" :weight bold :foreground "orange")
                                       ;; ;; ("REVIEW" :weight bold :foreground "DarkGoldenrod")
                                       ;; ;; ("WAIT" :weight bold :foreground "DarkOrchid")
                                       ;; ;; ("WAIT" :weight bold :foreground "pink")
                                       ;; ;; ("HOLD" :weight bold :foreground "moccasin")
                                       ;; ;; ("HOLD" :weight bold :foreground "DarkOrchid")
                                       ;; ;; ("IDEA" :weight bold :foreground "salmon1")
                                       ;; ("IDEA" :weight bold :foreground "Mocha")
                                       ;; ("STOP" :weight bold :foreground "SlateGray")
                                       ;; ;; ("STOP" :weight bold :foreground "turquoise")
                                       )))
  )

(after! org-agenda
  ;; Org agenda files
  (setq org-agenda-default-appointment-duration 60)


  (setq org-agenda-skip-deadline-prewarning-if-scheduled t
        org-agenda-skip-scheduled-if-deadline-is-shown 'not-today)

  ;; agenda should be in a full window
  ;; (add-hook 'org-agenda-finalize-hook (lambda () (delete-other-windows)))
  (setq org-agenda-window-setup 'current-window)

  (setq org-agenda-custom-commands
        '(
          ("Q" . "Custom queries") ;; gives label to "Q"
          ("p" . "Priorities")
          ("g" . "Get things done")
          ("l" . "Open loops")
          ))

  (add-to-list 'org-agenda-custom-commands
               '("gs" "Super View"
                 ((agenda "" (
                              (org-agenda-skip-scheduled-if-done t)
                              (org-agenda-skip-deadline-if-done t)
                              ;; (org-agenda-span 'day)
                              ;; (org-agenda-start-day nil)
                              (org-super-agenda-groups
                               '((:name "Today"
                                  :time-grid t
                                  :date today
                                  :todo "TODAY"
                                  :scheduled today
                                  :order 1)
                                 (:habit t)))
                              ))
                  (alltodo "" ((org-agenda-overriding-header "")
                               (org-super-agenda-groups
                                '(
                                  (:name "In Progress"
                                   :todo "GO"
                                   :order 10)
                                  (:name "Next action items"
                                   :todo "NEXT"
                                   :order 15)
                                  (:name "Needs Review"
                                   :todo "REVIEW"
                                   :order 20)
                                  (:name "Important"
                                   :tag "important"
                                   :priority "A"
                                   :order 60)
                                  (:name "Due Today"
                                   :deadline today
                                   :order 20)
                                  (:name "Due Soon"
                                   :deadline future
                                   :order 80)
                                  (:name "Overdue"
                                   :deadline past
                                   :order 70)
                                  ;; (:name "Assignments"
                                  ;; :tag "Assignment"
                                  ;; :order 10)
                                  ;; (:name "Issues"
                                  ;; :tag "Issue"
                                  ;; :order 12)
                                  (:name "Projects"
                                   :tag "project"
                                   :children todo
                                   :order 140)
                                  (:name "Emacs"
                                   :tag "emacs"
                                   :order 130)
                                  (:name "Research"
                                   :tag "research"
                                   :order 150)
                                  (:name "To read"
                                   :tag "literature"
                                   :order 300)
                                  (:name "Waiting"
                                   :todo ("WAIT" "HOLD")
                                   :order 200)
                                  (:name "Reminder"
                                   :tag ("reminder")
                                   :order 300)
                                  (:name "Routine"
                                   :discard (:tag ("chore" "daily" "weekly"))
                                   :tag ("routine")
                                   :order 500)
                                  (:name "Trivial"
                                   :priority<= "C"
                                   :tag ("trivial" "unimportant")
                                   :todo ("IDEA" )
                                   :order 1000)
                                  (:name "Scheduled earlier"
                                   :scheduled past)
                                  (:discard (:tag ("@errand" "chore" "daily" "weekly")))))))))
               )

  (setq ;; spacemacs-theme-org-agenda-height t
   ;; org-agenda-time-grid '((daily today require-timed) "----------------------" nil)
   ;; org-agenda-skip-scheduled-if-done t
   ;; org-agenda-skip-deadline-if-done t
   ;; org-agenda-include-deadlines t
   ;; org-agenda-include-diary t
   ;; org-agenda-block-separator nil
   ;; org-agenda-compact-blocks t
   org-agenda-start-with-log-mode t)

  (add-to-list 'org-agenda-custom-commands
               '("gP" "Printed agenda"
                 ((agenda "" ((org-agenda-span 7)                      ;; overview of appointments
                              (org-agenda-start-on-weekday nil)         ;; calendar begins today
                              (org-agenda-repeating-timestamp-show-all t)
                              (org-agenda-entry-types '(:timestamp :sexp))))
                  (agenda "" ((org-agenda-span 1)                      ; daily agenda
                              (org-deadline-warning-days 7)            ; 7 day advanced warning for deadlines
                              (org-agenda-todo-keyword-format "[ ]")
                              (org-agenda-scheduled-leaders '("" ""))
                              (org-agenda-prefix-format "%t%s")))
                  (todo "TODO"                                          ;; todos sorted by context
                        ((org-agenda-prefix-format "[ ] %T: ")
                         (org-agenda-sorting-strategy '(tag-up priority-down))
                         (org-agenda-todo-keyword-format "")
                         (org-agenda-overriding-header "\nTasks by Context\n------------------\n"))))
                 ((org-agenda-with-colors nil)
                  (org-agenda-compact-blocks t)
                  (org-agenda-remove-tags t)
                  (ps-number-of-columns 2)
                  (ps-landscape-mode t))
                 ("~/agenda.ps"))
               ;; other commands go here
               )

  (add-to-list 'org-agenda-custom-commands
               '("go" "Project View"
                 (
                  (agenda "" ((org-super-agenda-groups
                               '((:name "Today"
                                  :time-grid t)))))
                  (todo "" ((org-agenda-overriding-header "Projects")
                               (org-super-agenda-groups
                                '((
                                   :name none  ; Disable super group header
                                   :children todo)
                                   ;;(:discard (:anything t))
                                  ))
                               ))
                  )))

  (add-to-list 'org-agenda-custom-commands
               '("gi" "Inbox"
                 ((alltodo ""
                           ((org-agenda-files '("~/org/inbox.org"))
                            (org-agenda-overriding-header "Inbox")
                            (org-super-agenda-groups
                             '((:auto-ts t))))))))

  (add-to-list 'org-agenda-custom-commands
               '("gx" "Get to someday"
                 ((todo ""
                        ((org-agenda-overriding-header "Someday / Maybe")
                         (org-agenda-files '("~/org/someday.org"))
                         (org-super-agenda-groups
                          '((:auto-ts t))))))))

  (add-to-list 'org-agenda-custom-commands
               '("gu" "Unscheduled TODOs"
                 ((todo ""
                        ((org-agenda-overriding-header "\nUnscheduled TODO")
                         (org-agenda-skip-function '(org-agenda-skip-entry-if 'timestamp 'todo '("DONE" "STOP" "IDEA" "WAIT" "HOLD"))))))) t)

  (add-to-list 'org-agenda-custom-commands
               '("lr" "Recent Open Loops" agenda ""
                 ((org-agenda-start-day "-2d")
                  (org-agenda-span 4)
                  (org-agenda-start-with-log-mode t))))

  (add-to-list 'org-agenda-custom-commands
               '("ll" "Longer Open Loops" agenda ""
                 ((org-agenda-start-day "-14d")
                  (org-agenda-span 28)
                  (org-agenda-start-with-log-mode t))))

  (add-to-list 'org-agenda-custom-commands
               '("Qa" "Archive search" search ""
                 ((org-agenda-files (file-expand-wildcards "~/org/*.org_archive")))))

  (add-to-list 'org-agenda-custom-commands
               '("Qw" "Website search" search ""
                 ((org-agenda-files (file-expand-wildcards "~/website/*.org")))))

  (add-to-list 'org-agenda-custom-commands
               '("Qb" "Projects and Archive" search ""
                 ((org-agenda-text-search-extra-files (file-expand-wildcards "~/archive/*.org_archive")))))

  (add-to-list 'org-agenda-custom-commands
               '("QA" "Archive tags search" org-tags-view ""
                 ((org-agenda-files (file-expand-wildcards "~/org/*.org_archive"))))
               )

  (add-to-list 'org-agenda-custom-commands
               '("pa" "A items" tags-todo "+PRIORITY=\"A\""))

  (add-to-list 'org-agenda-custom-commands
               '("pb" "B items" tags-todo "+PRIORITY=\"B\""))

  (add-to-list 'org-agenda-custom-commands
               '("pc" "C items" tags-todo "+PRIORITY=\"C\""))

  ;; (bind-keys :prefix-map review-map
  ;;            :prefix "C-c r"
  ;;            ("d" . my-new-daily-review)
  ;;            ("w" . my-new-weekly-review)
  ;;            ("m" . my-new-monthly-review))
  )

;; (global-set-key (kbd "C-c r d") 'my-new-daily-review)
;; (global-set-key (kbd "C-c r w") 'my-new-weekly-review)
;; (global-set-key (kbd "C-c r m") 'my-new-monthly-review)

;; (bind-keys
;;  ("C-c r d" . my-new-daily-review)
;;  ("C-c r w" . my-new-weekly-review)
;;  ("C-c r m" . my-new-monthly-review))

;; (f-touch "~/org/reviews.org")

;; (provide 'gtd-plus)
;;; gtd-plus.el ends here
