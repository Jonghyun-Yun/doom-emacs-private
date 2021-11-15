;;; super-agenda-custom-commands.el

;;;; super
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
                             (:name "Someday / Maybe" ; Disable super group header
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

;;; print agenda
(add-to-list 'org-agenda-custom-commands
             '("gP" "Printed agenda"
               (
                ;; (agenda "" ((org-agenda-span 7)                      ;; overview of appointments
                ;;             (org-agenda-start-on-weekday nil)         ;; calendar begins today
                ;;             (org-agenda-repeating-timestamp-show-all t)
                ;;             (org-agenda-entry-types '(:timestamp :sexp))))
                (agenda "" ((org-agenda-span 1) ; daily agenda
                            (org-deadline-warning-days 7) ; 7 day advanced warning for deadlines
                            (org-agenda-todo-keyword-format "[ ]")
                            (org-agenda-scheduled-leaders '("" ""))
                            (org-agenda-prefix-format "%t%s")))
                (todo "TODO" ;; todos sorted by context
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

;;;; projects
(add-to-list 'org-agenda-custom-commands
             '("gc" "Current project"
               (
                (search (concat "+" (projectile-project-name))
                 ((org-agenda-files '("~/org/projects.org"))
                  (org-agenda-overriding-header (concat "Current project: " (projectile-project-name)))
                  (org-super-agenda-groups
                   '(
                     (:name none        ; Disable super group header
                      :auto-outline-path t)
                     (:discard (:anything t))
                     ))
                  ))
                )))

(add-to-list 'org-agenda-custom-commands
             '("go" "All projects"
               (
                (alltodo ""
                         ((org-agenda-files '("~/org/projects.org"))
                          (org-agenda-overriding-header "All projects")
                          (org-super-agenda-groups
                           '(
                             (:name none ; Disable super group header
                              :auto-outline-path t)
                             (:discard (:anything t))
                             ))
                          ))
                (alltodo ""
                         ((org-agenda-files '("~/org/todo.org"))
                          (org-agenda-overriding-header "Projects in todo-file")
                          (org-super-agenda-groups
                           '(
                             (:name none ; Disable super group header
                              :tag "project")
                             (:discard (:anything t))
                             ))
                          ))
                )))

;;;; inbox
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

;;;; misc
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

;;;; not using super agenda
(setq org-agenda-custom-commands
      (append org-agenda-custom-commands
              '(
                ;; open loops
                ("lr" "Recent open loops" agenda ""
                 ((org-agenda-start-day "-2d")
                  (org-agenda-span 4)
                  (org-agenda-start-with-log-mode t)))
                ("ll" "Longer open loops" agenda ""
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

(provide 'super-agenda-custom-commands)

;;; super-agenda-custom-commands.el ends here
