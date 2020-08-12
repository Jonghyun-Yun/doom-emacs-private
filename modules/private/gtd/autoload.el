;;; private/gtd/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
;; Detect Internet Connection
(defun internet-up-p (&optional host)
  (= 0 (call-process "ping" nil nil nil "-c" "1" "-W" "1"
                     (if host host "www.google.com"))))

;;;###autoload
(defun fetch-calendar ()
  (when (internet-up-p) (org-gcal-fetch)))

;;;###autoload
(defun org-make-habit ()
  (interactive)
  (org-set-property "STYLE" "habit"))

;;;###autoload
(defun my-new-daily-review ()
  (interactive)
  (let ((org-capture-templates '(("rd" "Review: Daily Review" entry (file+olp+datetree "~/org/reviews.org")
                                  (file "~/org/templates/dailyreviewtemplate.org")))))
    (progn
      (org-capture nil "rd")
      (org-capture-finalize t)
      (org-speed-move-safe 'outline-up-heading)
      (org-narrow-to-subtree)
      (fetch-calendar)
      (org-clock-in))))

;;;###autoload
(defun my-new-weekly-review ()
  (interactive)
  (let ((org-capture-templates '(("rw" "Review: Weekly Review" entry (file+olp+datetree "~/org/reviews.org")
                                  (file "~/org/templates/weeklyreviewtemplate.org")))))
    (progn
      (org-capture nil "rw")
      (org-capture-finalize t)
      (org-speed-move-safe 'outline-up-heading)
      (org-narrow-to-subtree)
      (fetch-calendar)
      (org-clock-in))))

;;;###autoload
(defun my-new-monthly-review ()
  (interactive)
  (let ((org-capture-templates '(("rm" "Review: Monthly Review" entry (file+olp+datetree "~/org/reviews.org")
                                  (file "~/org/templates/monthlyreviewtemplate.org")))))
    (progn
      (org-capture nil "rm")
      (org-capture-finalize t)
      (org-speed-move-safe 'outline-up-heading)
      (org-narrow-to-subtree)
      (fetch-calendar)
      (org-clock-in))))

;;;###autoload
(defun my-org-super-agenda-view ()
  (interactive)
  (let (
        ;;(org-agenda-time-grid '((daily today require-timed) "----------------------" nil))
        (org-agenda-skip-scheduled-if-done t)
        (org-agenda-skip-deadline-if-done t)
        (org-agenda-include-deadlines nil)
        (org-agenda-include-diary t)
        (org-agenda-block-separator nil)
        (org-agenda-compact-blocks t)
        (org-agenda-start-with-log-mode t)
        )
    (org-agenda nil "gs")))

;;;###autoload
(defun my-org-agenda-inbox ()
  (interactive)
  (org-agenda nil "gi"))
