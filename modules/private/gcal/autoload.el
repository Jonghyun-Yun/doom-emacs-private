;;; private/gcal/autoload/gcal.el -*- lexical-binding: t; -*-
;;;###if (and (featurep! :lang org) (featurep! :app calendar))

;;;###autoload
;; (defun sync-gcal-after-capture ()
;;   "Sync calendar after an event was added with org-capture.
;; The function can be run automatically with the 'org-capture-after-finalize-hook'."
;;   ;; (if (not (equal "SA" (org-capture-get :key)))
;;   (when (equal "s" (org-capture-get :key))
;;     (progn
;;       (require 'org-gcal)
;;       (when-let (
;;                  (cal-files (mapcar 'f-expand (mapcar 'cdr org-gcal-file-alist)))
;;                  (cal-file-exists (and (mapcar 'f-file? cal-files)))
;;                  (capture-target-isfile (eq (car (org-capture-get :target)) 'file))
;;                  (capture-target (f-expand (car (cdr (org-capture-get :target)))))
;;                  (capture-target-is-cal-file (member capture-target cal-files)))
;;         ;; (org-gcal--refresh-token)
;;         (org-gcal-fetch)
;;         (org-capture-goto-last-stored) ;; https://github.com/kidd/org-gcal.el/issues/62
;;         (org-gcal-post-at-point)))
;;     ) ;; when
;;   )
;; (defun sync-gcal-after-capture ()

(defvar jyun/show-routines 1
  "An indictor of routines in calendar.")

;;;###autoload
(defun cfw:hide-routines (no-resize)
  "Skip DONE agenda items and open calfw calendar view.
   Hide items in routines.org."
  (interactive "P")
  (let ((org-agenda-skip-scheduled-if-done t)
        (org-agenda-skip-deadline-if-done t)
        ;; (org-agenda-files (add-to-list 'org-agenda-files "~/org/routines.org"))
        (org-agenda-files (remove "~/org/routines.org" org-agenda-files)))
    (cfw:refresh-calendar-buffer no-resize)
    )
  )

;; ;;;###autoload
;; (defun cfw:hide-clutter-v1 ()
;;   "Skip DONE agenda items and open calfw calendar view.
;;    Hide items in routines.org."
;;   (interactive)
;;   (let ((org-agenda-window-setup calfw-calendar-window-setup)
;;         (org-agenda-skip-scheduled-if-done t)
;;         (org-agenda-skip-deadline-if-done t)
;;         )
;;     (let ((org-agenda-files (remove org-routines-file org-agenda-files)))

;;       (google-calendar/calfw-prepare-window)
;;       ;;; If non nil, overload agenda window setup with the desired setup for calfw

;;       (org-agenda nil calfw-org-agenda-view)
;;       (cfw:open-org-calendar))))

;;;###autoload
;; (defun my-open-calendar ()
;;   (interactive)
;;   (org-gcal-fetch)
;;   (if (featurep! :ui workspaces)
;;       (+workspace-switch +my-cfw-workspace-name t)
;;     (setq +my-cfw--old-wconf (current-window-configuration))
;;     (delete-other-windows)
;;     (switch-to-buffer (doom-fallback-buffer)))
;;   (let
;;       ((org-agenda-files (remove "~/org/routines.org" org-agenda-files)))
;;     (cfw:open-calendar-buffer
;;      :contents-sources
;;      (list
;;       ;; (cfw:org-create-source "RoyalBlue")  ; orgmode source
;;       (cfw:org-create-source cfw:org-face-agenda-item-foreground-color)  ; orgmode source
;;       (cfw:ical-create-source "family" family-ical-secret "goldenrod2") ;family calendar
;;       ;; (cfw:ical-create-source "UTA" "https://outlook.office365.com/owa/calendar/a66ad81c4e1e4d04bf004ff7e3aa85cf@uta.edu/394d55612b0345e3b25351f3e5f91f274369194296398689097/calendar.ics" "Magenta")  ; UTA
;;       (cfw:ical-create-source "routines" routines-ical-secret "burlywood4") ;routines
;;       ;; (cfw:howm-create-source "Blue")  ; howm source
;;       ;; (cfw:cal-create-source "Orange") ; diary source
;;       ))))

;;;###autoload
(defun +jyun/open-calendar ()
  "TODO"
  (interactive)
  (progn
    ;; (org-gcal-fetch)
    (cfw:open-calendar-buffer
     ;; :custom-map cfw:my-cal-map
     :contents-sources
     (list
      ;; (cfw:org-create-source "RoyalBlue")  ; orgmode source
      (cfw:org-create-source cfw:org-face-agenda-item-foreground-color) ; orgmode source
      (cfw:ical-create-source "family" family-ical-secret "goldenrod2") ;family calendar
      ;; (cfw:ical-create-source "UTA" "https://outlook.office365.com/owa/calendar/a66ad81c4e1e4d04bf004ff7e3aa85cf@uta.edu/394d55612b0345e3b25351f3e5f91f274369194296398689097/calendar.ics" "Magenta")  ; UTA
      (cfw:ical-create-source "routines" routines-ical-secret "burlywood4") ;routines
      ;; (cfw:howm-create-source "Blue")  ; howm source
      ;; (cfw:cal-create-source "Orange") ; diary source
      )
     )))

;;;###autoload
(defun =jyun/calendar ()
  (interactive)
  (let* ((+calendar-open-function #'+jyun/open-calendar))
    (=calendar)
    ))

;; (defvar +my-cfw-workspace-name "Calendar")
;; (defvar +my-cfw--old-wconf nil)

;; (add-hook 'cfw:calendar-mode-hook #'+my-cfw-init-h)


;;;###autoload
;; (defun my-open-org-calendar ()
;;   (interactive)
;;   (org-gcal-fetch)
;;   (if (featurep! :ui workspaces)
;;       (+workspace-switch +my-cfw-workspace-name t)
;;     (setq +my-cfw--old-wconf (current-window-configuration))
;;     (delete-other-windows)
;;     (switch-to-buffer (doom-fallback-buffer)))
;;     (let
;;         ((org-agenda-files (remove "~/org/routines.org" org-agenda-files)))
;;       (cfw:open-org-calendar)
;;       )
;;   )

;;;###autoload
;; (defun +my-cfw-init-h ()
;;   (add-hook 'kill-buffer-hook #'+my-cfw-kill-cfw-h nil t))

;;;###autoload
;; (defun +my-cfw-kill-cfw-h ()
;;   ;; (prolusion-mail-hide)
;;   (cond
;;    ((and (featurep! :ui workspaces) (+workspace-exists-p +my-cfw-workspace-name))
;;     (+workspace/delete +my-cfw-workspace-name))

;;    (+my-cfw--old-wconf
;;     (set-window-configuration +my-cfw--old-wconf)
;;     (setq +my-cfw--old-wconf nil))))
