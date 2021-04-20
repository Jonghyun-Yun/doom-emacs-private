;;; scimax-elfeed.el --- scimax configuration for elfeed

;;; Commentary:
;; This just sets up elfeed for scimax. It sets some default feeds and
;; categories, and some new org-mode integration and keybindings.

(after! elfeed
;; scimax
;; (define-key elfeed-show-mode-map (kbd "e") 'email-elfeed-entry)
;; (define-key elfeed-show-mode-map (kbd "p") 'elfeed-show-pdf)
;; (define-key elfeed-show-mode-map (kbd "c") (lambda () (interactive) (org-capture nil "e")))
;; ;; (define-key elfeed-show-mode-map (kbd "d") 'doi-utils-add-entry-from-elfeed-entry)

;; help me alternate fingers in marking entries as read
(define-key elfeed-search-mode-map (kbd "f") 'elfeed-search-untag-all-unread)
(define-key elfeed-search-mode-map (kbd "j") 'elfeed-search-untag-all-unread)
(define-key elfeed-search-mode-map (kbd "o") 'elfeed-search-show-entry)

(defun email-elfeed-entry ()
  "Capture the elfeed entry and put it in an email."
  (interactive)
  (let* ((title (elfeed-entry-title elfeed-show-entry))
         (url (elfeed-entry-link elfeed-show-entry))
         (content (elfeed-entry-content elfeed-show-entry))
         (entry-id (elfeed-entry-id elfeed-show-entry))
         (entry-link (elfeed-entry-link elfeed-show-entry))
         (entry-id-str (concat (car entry-id)
                               "|"
                               (cdr entry-id)
                               "|"
                               url)))
    (compose-mail)
    (message-goto-subject)
    (insert title)

    (if (featurep 'org-msg)
    (let ((re-content
           (with-temp-buffer
             (insert (elfeed-deref content))

             (goto-char (point-min))
             (while (re-search-forward "<br>" nil t)
               (replace-match "\n\n"))

             (goto-char (point-min))
             (while (re-search-forward "<.*?>" nil t)
               (replace-match ""))

             (fill-region (point-min) (point-max))
             (buffer-string)
             )))

      (org-msg-goto-body)
      (insert (format "You may find this interesting:
%s\n\n" url))
      (insert re-content))

    (progn
      (message-goto-body)
      (insert (format "You may find this interesting:
%s\n\n" url))
      (insert (elfeed-deref content))

      (message-goto-body)
      (while (re-search-forward "<br>" nil t)
        (replace-match "\n\n"))

      (message-goto-body)
      (while (re-search-forward "<.*?>" nil t)
        (replace-match ""))

      (message-goto-body)
      (fill-region (point) (point-max))
      ))

    (message-goto-to)
    ;; (ivy-contacts nil)
    ))
)

(provide 'scimax-elfeed)

;;; scimax-elfeed.el ends here
