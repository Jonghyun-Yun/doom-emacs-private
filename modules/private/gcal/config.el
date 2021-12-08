;;; private/gcal/config.el -*- lexical-binding: t; -*-
;;;###if (featurep! :app calendar)

;; sync gcal.org and google calendar
(setq org-gcal-file-alist '(("jonghyun.yun@gmail.com" . "~/org/gcal.org") ;; google calendar
                            ))

;;;###autoload
(defun jyun/get-org-gcal-credential ()
  "Get google calendar credientials."
  (interactive)
  (setq! org-gcal-client-id (funcall #'password-store-get "org-gcal/client-id")
         org-gcal-client-secret (funcall #'password-store-get "org-gcal/client-secret")))

;; (setq org-gcal-down-days 365)   ;; Set org-gcal to download events a year in advance
;; (add-hook 'org-agenda-mode-hook (lambda () (org-gcal-sync) ))
;;
;; (add-hook 'after-init-hook 'org-gcal-fetch)
;; (add-hook 'kill-emacs-hook 'org-gcal-sync)

;; only one of these hooks needs to post an event after capture.
;; org-gcal--capture-post throws an error
;; (remove-hook 'org-capture-before-finalize-hook #'org-gcal--capture-post)
;; (add-hook 'org-capture-after-finalize-hook #'sync-gcal-after-capture)

(run-with-idle-timer 3600 t 'org-gcal-fetch)

(defcustom org-gcal-capture-templates
  '("s" "Scedule an event" entry
    (file+function "gcal.org" (lambda () (progn (require 'org-gcal)
                                           ;; (jyun/get-org-gcal-credential)
                                           )))
    "* %^{Scheduling...} \n:PROPERTIES: \n:calendar-id: jonghyun.yun@gmail.com \n:LOCATION: %^{Location} \n:END: \n:org-gcal: \n%^T \n%i \n%? \n:END:\n\n"
    :prepend t)
  "Templates for the creation of new google calendar entries."
  :group 'org-capture)

;; (add-to-list 'org-capture-templates org-gcal-capture-templates)

(after! (org-capture calfw)
  (setq cfw:org-capture-template org-gcal-capture-templates)
  )

(after! calfw-ical
  (setq family-ical-secret (funcall #'password-store-get "org-gcal/family-secret"))
  (setq routines-ical-secret (funcall #'password-store-get "org-gcal/routines-secret"))
  )
(setq cfw:display-calendar-holidays nil)

;; (use-package! calfw-ical
;;   :defer t
;;   :commands
;;   (cfw:ical-create-source))

(evil-set-initial-state 'cfw:details-mode 'emacs)
