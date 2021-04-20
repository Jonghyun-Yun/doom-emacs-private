;;; scimax-elfeed.el --- scimax configuration for elfeed

;;; Commentary:
;; This just sets up elfeed for scimax. It sets some default feeds and
;; categories, and some new org-mode integration and keybindings.
(after! elfeed-show
  (require 'url)

  (defvar elfeed-pdf-dir
    (expand-file-name "pdfs/"
                      (file-name-directory (directory-file-name elfeed-enclosure-default-dir))))

  (defvar elfeed-link-pdfs
    '(("https://www.jstatsoft.org/index.php/jss/article/view/v0\\([^/]+\\)" . "https://www.jstatsoft.org/index.php/jss/article/view/v0\\1/v\\1.pdf")
      ("http://arxiv.org/abs/\\([^/]+\\)" . "https://arxiv.org/pdf/\\1.pdf"))
    "List of alists of the form (REGEX-FOR-LINK . FORM-FOR-PDF)")

  (defun elfeed-show-pdf (entry)
    (interactive
     (list (or elfeed-show-entry (elfeed-search-selected :ignore-region))))
    (let ((link (elfeed-entry-link entry))
          (feed-name (plist-get (elfeed-feed-meta (elfeed-entry-feed entry)) :title))
          (title (elfeed-entry-title entry))
          (file-view-function
           (lambda (f)
             (when elfeed-show-entry
               (elfeed-kill-buffer))
             (pop-to-buffer (find-file-noselect f))))
          pdf)

      (let ((file (expand-file-name
                   (concat (subst-char-in-string ?/ ?, title) ".pdf")
                   (expand-file-name (subst-char-in-string ?/ ?, feed-name)
                                     elfeed-pdf-dir))))
        (if (file-exists-p file)
            (funcall file-view-function file)
          (dolist (link-pdf elfeed-link-pdfs)
            (when (and (string-match-p (car link-pdf) link)
                       (not pdf))
              (setq pdf (replace-regexp-in-string (car link-pdf) (cdr link-pdf) link))))
          (if (not pdf)
              (message "No associated PDF for entry")
            (message "Fetching %s" pdf)
            (unless (file-exists-p (file-name-directory file))
              (make-directory (file-name-directory file) t))
            (url-copy-file pdf file)
            (funcall file-view-function file))))))
  )

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
