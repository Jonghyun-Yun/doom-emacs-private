;;; private/gcal/config.el -*- lexical-binding: t; -*-

(after! org-gcal
  ;; sync gcal.org and google calendar
  (setq org-gcal-file-alist '(
                              ("jonghyun.yun@gmail.com" . "~/org/gcal.org") ;; google calendar
                              )
        )
  (after! pass
    (setq org-gcal-client-id (password-store-get "org-gcal/client-id")
          org-gcal-client-secret (password-store-get "org-gcal/client-secret")
          ))

;; "ags" 'org-gcal-sync
;; "agf" 'org-gcal-fetch
;; "agD" 'org-gcal-delete-at-point

;; (setq org-gcal-down-days 365)   ;; Set org-gcal to download events a year in advance
;; (add-hook 'org-agenda-mode-hook 'evil-emacs-state)
;; (add-hook 'org-agenda-mode-hook (lambda () (org-gcal-sync) ))
;;
;; (add-hook 'after-init-hook 'org-gcal-fetch)
;; (add-hook 'kill-emacs-hook 'org-gcal-sync)

;; only one of these hooks needs to post an event after capture.
;; org-gcal--capture-post throws an error
(remove-hook 'org-capture-before-finalize-hook #'org-gcal--capture-post)
(add-hook 'org-capture-after-finalize-hook #'sync-gcal-after-capture)

(run-with-idle-timer 1800 t 'org-gcal-fetch)

;; (with-eval-after-load 'org-capture
;;   (add-to-list 'org-capture-templates org-gcal-capture-templates)

;; ;; cfw capture template
;; ;; to do org-capture in calendar
;; (setq cfw:org-capture-templates org-gcal-capture-templates)
)

(setq cfw:display-calendar-holidays nil)

;; (use-package! calfw-ical
;;   :defer t
;;   :commands
;;   (cfw:ical-create-source))

(evil-set-initial-state 'cfw:details-mode 'emacs)
