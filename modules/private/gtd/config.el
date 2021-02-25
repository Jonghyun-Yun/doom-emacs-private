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
  :defer t
  :hook (org-agenda-mode . org-super-agenda-mode)
)

(after! org
  (add-to-list 'org-global-properties
               '("Effort_ALL" . "0:05 0:15 0:30 1:00 1:30 2:00 3:00 4:00"))

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
                        (:startgroup . nil)
                        ("noexport" . ?x) ("export" . ?y)
                        (:endgroup . nil)
                        ))

  (setq org-todo-keywords
        '((sequence
           "TODO(t)" ; doing later
           "NEXT(n!)" ; next action
           "GO(g!)" ; active todo
           "|"
           "DONE(d)" ; done
           )
          (sequence
           "WAIT(w@)" ; waiting to be actionalble again
           "IDEA(i)" ; maybe someday
           "|"
           "HOLD(h@/!)" ; to be done some day but not now
           "KILL(k@/!)" ; Task was cancelled, aborted or is no longer applicable
           )
          ;; (sequence "[ ](T)" "[-](G)" "[?](W)" "|" "[X](D)")
          ;; [-](S) active
          ;; [?](W) onhold
          ))

    (with-no-warnings
    ;; (custom-declare-face '+org-todo-stop  '((t (:inherit (bold font-lock-constant-face org-todo)))) "")
    ;; (custom-declare-face '+org-todo-stop  '((t (:inherit (bold font-lock-doc-face org-todo)))) "")
    ;; (custom-declare-face '+org-todo-stop  '((t (:inherit (bold font-lock-type-face org-todo)))) "")
    ;; (custom-declare-face '+org-todo-idea '((t (:inherit (bold font-lock-doc-face org-todo)))) "")
    (custom-declare-face '+org-todo-idea  '((t (:inherit (bold font-lock-type-face org-todo)))) "")
    (custom-declare-face '+org-todo-kill  '((t (:inherit (bold font-lock-doc-face org-todo)))) "")
    (custom-declare-face '+org-todo-next '((t (:inherit (bold org-level-7 org-todo)))) "")
    (custom-declare-face '+org-todo-hold '((t (:inherit (bold org-level-6 org-todo)))) "")
    (custom-declare-face '+org-todo-wait  '((t (:inherit (bold warning org-todo)))) "")
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
                                       ;; ("[-]" . +org-todo-active)
                                       ;; ("GO" . +org-todo-active)
                                       ("NEXT" . +org-todo-active)
                                       ;; ("[?]" . +org-todo-onhold)
                                       ("WAIT" . +org-todo-wait)
                                       ("HOLD" . +org-todo-hold)
                                       ("IDEA" . +org-todo-idea)
                                       ("STOP" . +org-todo-stop)
                                       ("KILL" . +org-todo-kill)
                                       )))
  )

(after! org-agenda
  ;; agenda should be in a full window
  ;; (add-hook 'org-agenda-finalize-hook (lambda () (delete-other-windows)))

  (setq org-agenda-default-appointment-duration 60
        org-agenda-skip-deadline-prewarning-if-scheduled t
        org-agenda-skip-scheduled-if-deadline-is-shown 'not-today
        org-agenda-window-setup 'current-window
        org-agenda-custom-commands
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
                              ;; (org-agenda-span 10)
                              ;; (org-agenda-start-day "-3d")
                              (org-super-agenda-groups
                               '(
                                 (:discard (:and (:tag "routine" :tag ("@errand" "daily" "weekly"))))
                                 (
                                  :name none
                                  :time-grid t
                                  :date today
                                  ;; :todo t
                                  :scheduled today
                                  :deadline today
                                  :order 1)
                                 (:name none
                                  :deadline t
                                  :scheduled t
                                  :order 2)
                                 (:habit t)
                                 (:discard (:anything t))
                                 ))
                              ))
                  (alltodo "" ((org-agenda-overriding-header "")
                               (org-super-agenda-groups
                                '(
                                  (:discard (:and (:tag "routine" :tag ("@errand" "daily" "weekly"))))
                                  (:name "In Progress"
                                   :todo "GO"
                                   :order 10)
                                  (:name "Next action items"
                                   :todo "NEXT"
                                   :order 20)
                                  ;; (:name "Needs Review"
                                  ;;  :todo "REVIEW"
                                  ;;  :order 20)
                                  (:name "Important"
                                   :tag "important"
                                   :priority "A"
                                   :order 30)
                                  (:name "Due Today"
                                   :deadline today
                                   :order 40)
                                  (:name "Due Soon"
                                   :deadline future
                                   :order 50)
                                  (:name "Overdue"
                                   :deadline past
                                   :order 45)
                                  ;; (:name "Assignments"
                                  ;; :tag "Assignment"
                                  ;; :order 10)
                                  ;; (:name "Issues"
                                  ;; :tag "Issue"
                                  ;; :order 12)
                                  (:name "Projects in todo-file"
                                   :tag "project"
                                   ;; :children todo
                                   :order 110)
                                  (:name "Emacs"
                                   :tag "emacs"
                                   :order 200)
                                  (:name "Research"
                                   :tag "research"
                                   :order 110)
                                  (:name "To read"
                                   :tag "literature"
                                   :order 150)
                                  (:name "Waiting"
                                   :todo ("WAIT" "HOLD")
                                   :order 95)
                                  (:name "Reminder"
                                   :and (:tag "reminder")
                                   ;; :scheduled (before ,target-date))
                                   :order 95)
                                  (:name "Trivial"
                                   :priority<= "C"
                                   :tag ("trivial" "unimportant")
                                   :todo ("IDEA" )
                                   :order 1000)
                                  (:name "Not today"
                                   :and (:scheduled future :not (:tag "routine"))
                                   :order 60)
                                  ;; (:name "Projects"
                                  ;; :file-path "projects")
                                  (:name "Unscheduled"
                                   :scheduled nil
                                   :order 100)
                                  (:discard (:scheduled today))
                                  (:discard (:scheduled past))
                                  ;; (:name "Routine"
                                  ;; :discard (:tag ("chore" "daily" "weekly"))
                                  ;; :tag ("routine")
                                  ;; :order 5000)
                                  (:discard (:tag ("routine")))
                                  ))))
                  (alltodo ""
                           ((org-agenda-files '("~/org/someday.org"))
                            (org-agenda-overriding-header "")
                            (org-super-agenda-groups
                             '(
                               (:name "Someday / Maybe"  ; Disable super group header
                                :anything t
                                )
                               ))
                            ))
                  ))
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
                 (
                  ;; (agenda "" ((org-agenda-span 7)                      ;; overview of appointments
                  ;;             (org-agenda-start-on-weekday nil)         ;; calendar begins today
                  ;;             (org-agenda-repeating-timestamp-show-all t)
                  ;;             (org-agenda-entry-types '(:timestamp :sexp))))
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
                  (alltodo ""
                           ((org-agenda-files '("~/org/projects.org"))
                            (org-agenda-overriding-header "Projects")
                            (org-super-agenda-groups
                             '(
                               (:name none  ; Disable super group header
                                :auto-outline-path t)
                               (:discard (:anything t))
                               ))
                            ))
                  (alltodo ""
                           ((org-agenda-files '("~/org/todo.org"))
                            (org-agenda-overriding-header "Projects in todo-file")
                            (org-super-agenda-groups
                             '(
                               (:name none  ; Disable super group header
                                :tag "project")
                               (:discard (:anything t))
                               ))
                            ))
                  )))

  (add-to-list 'org-agenda-custom-commands
               '("gi" "Inbox"
                 ((alltodo ""
                           ((org-agenda-files '("~/org/inbox.org"))
                            (org-agenda-overriding-header "Inbox")
                            (org-super-agenda-groups
                             '(
                               ;; (:auto-parent t)
                               (:auto-ts t)
                               ;;(:anything t)
                               )))))))

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
               '("gr" "Routines"
                 ((alltodo ""
                           ((org-agenda-files '("~/org/routines.org"))
                            (org-agenda-overriding-header "Routines")
                            (org-super-agenda-groups
                             '(
                               ;; (:auto-parent t)
                               (:auto-ts t)
                               ;;(:anything t)
                               )))))))

  (setq org-agenda-custom-commands
        (append org-agenda-custom-commands
                '(
                  ;; open loops
                  ("lr" "Recent Open Loops" agenda ""
                   ((org-agenda-start-day "-2d")
                    (org-agenda-span 4)
                    (org-agenda-start-with-log-mode t)))
                  ("ll" "Longer Open Loops" agenda ""
                   ((org-agenda-start-day "-14d")
                    (org-agenda-span 28)
                    (org-agenda-start-with-log-mode t)))
                  ;; search
                  ("Qh" "Archive search" search ""
                   ((org-agenda-files (file-expand-wildcards "~/org/*.org_archive"))))
                  ("Qw" "Website search" search ""
                   ((org-agenda-files (file-expand-wildcards "~/website/*.org"))))
                  ("Qb" "Projects and Archive" search ""
                   ((org-agenda-text-search-extra-files (file-expand-wildcards "~/archive/*.org_archive"))))
                  ("QA" "Archive tags search" org-tags-view ""
                   ((org-agenda-files (file-expand-wildcards "~/org/*.org_archive"))))
                  ;; priority
                  ("pa" "A items" tags-todo "+PRIORITY=\"A\"")
                  ("pb" "B items" tags-todo "+PRIORITY=\"B\"")
                  ("pc" "C items" tags-todo "+PRIORITY=\"C\"")
                  )))

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
