;;;###autoload
(defun jyun/langtool-goto-next-error (count)
  (interactive "p")
  (dotimes (_ count) (langtool-goto-next-error))
  (when languagetool-show-error-on-jump (langtool-show-message-at-point)))

;;;###autoload
(defun jyun/langtool-goto-previous-error (count)
  (interactive "p")
  (dotimes (_ count) (langtool-goto-previous-error))
  (when languagetool-show-error-on-jump (langtool-show-message-at-point)))

;;;###autoload
;; (defun langtool-autoshow-force-message (overlays)
;;   ;; Interrupt current message
;;   (let ((msg (langtool-simple-error-message overlays)))
;;     (message "%s" msg)))

;;;###autoload
;; (defun langtool-autoshow-detail-popup (overlays)
;;   (when (require 'popup nil t)
;;     ;; Do not interrupt current popup
;;     (unless (or popup-instances
;;                 ;; suppress popup after type `C-g` .
;;                 (memq last-command '(keyboard-quit)))
;;       (let ((msg (langtool-details-error-message overlays)))
;;         (popup-tip msg)))))
