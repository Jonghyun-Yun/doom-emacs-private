;;; private/gtd/config.el -*- lexical-binding: t; -*-

(use-package org-super-agenda
  :defer t
  :after org-agenda
  ;; :hook (org-agenda-mode . org-super-agenda-mode)
  :config
  (org-super-agenda-mode)
)
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
           ;; "GO(g!)" ; active todo
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
    (custom-declare-face '+org-todo-cancel  '((t (:inherit (bold error org-todo)))) "")
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
                                       ("KILL" . +org-todo-cancle)
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

  (load! "super-agenda-custom-commands")

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
