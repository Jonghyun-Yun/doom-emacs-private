;;; ../Dropbox/emacs/.doom.d/local/mu4e-plus.el -*- lexical-binding: t; -*-

;; (map! :map mu4e-view-mode-map
;;       :nme "H-c" #'(lambda ()
;;                    (interactive)
;;                    (let* ((mu4e-subject (mu4e-message-field-at-point :subject)))
;;                      (setq jyun/target-mu4e-subject mu4e-subject)
;;                      (org-capture nil "ATE"))))

(set-email-account! "Gmail"
                    '(
                      ( user-mail-address  . "jonghyun.yun@gmail.com"  )
                      ;; ( mu4e-sent-messages-behavior 'delete)
                      ( mu4e-sent-folder   . "/gmail/[Gmail]/Sent Mail")
                      ( mu4e-drafts-folder . "/gmail/[Gmail]/Drafts")
                      ( mu4e-trash-folder  . "/gmail/[Gmail]/Trash")
                      ( mu4e-refile-folder . "/gmail/[Gmail]/Starred")
                      ( user-full-name     . "Jonghyun Yun" )
                      ( mu4e-compose-signature .  (concat
                                                   "Jonghyun Yun, PhD\n"
                                                   "Statistical Data Scientist\n"
                                                   "https://jyun.rbind.io\n"
                                                   )))
                    t)                  ; default email

(set-email-account! "UTA"
                    '(
                      ( user-mail-address  . "j.yun@uta.edu" )
                      ;; (mu4e-sent-messages-behavior delete)
                      ( mu4e-sent-folder   . "/uta/Sent")
                      ( mu4e-drafts-folder . "/uta/Drafts")
                      ( mu4e-trash-folder  . "/uta/Trash")
                      ( mu4e-refile-folder . "/uta/Archive")
                      ( user-full-name     . "Jonghyun Yun" )
                      ( mu4e-compose-signature . (concat
                                                  "Jonghyun Yun, Ph.D.\n"
                                                  "Assistant Professor\n"
                                                  "UT Arlington, Dept. of Mathematics\n\n"
                                                  "655 W Mitchell St, SEIR 218\n"
                                                  "Arlington, TX 76010\n"
                                                  "Phone: 817-272-9045\n"
                                                  "Fax: 817-272-5802\n")))
                    nil)

  ;;; email attachment from dired: C-c RET C-a
(after! dired
  (require 'gnus-dired)
  ;; ;; make the `gnus-dired-mail-buffers' function also work on
  ;; ;; message-mode derived modes, such as mu4e-compose-mode
  ;; (defun gnus-dired-mail-buffers ()
  ;;   "Return a list of active message buffers."
  ;;   (let (buffers)
  ;;     (save-current-buffer
  ;;       (dolist (buffer (buffer-list t))
  ;;         (set-buffer buffer)
  ;;         (when (and (derived-mode-p 'message-mode)
  ;;                    (null message-sent-message-via))
  ;;           (push (buffer-name buffer) buffers))))
  ;;     (nreverse buffers)))

  (setq gnus-dired-mail-mode 'mu4e-user-agent)
  (add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode))

;; no accumulating drafts
(add-hook 'mu4e-compose-mode-hook #'(lambda () (auto-save-visited-mode -1)))

(after! org-msg
  (setq org-msg-options
        (concat org-msg-options " num:nil tex:dvipng ^:{} \\n:t")
        org-msg-startup "hidestars indent inlineimages"
        org-msg-default-alternatives '(text html)
        org-msg-convert-citation t
        ;; msg auto completion
        ;; org-msg-greeting-fmt "\nHi *%s*,\n\n"
        ;; org-msg-greeting-name-limit 3
        org-msg-recipient-names '(("jonghyun.yun@gmail.com" . "Jonghyun"))
        org-msg-signature "

 Best wishes,

 #+begin_signature
 -- *Jonghyun* \\\\
 #+end_signature")
  )

(with-eval-after-load 'mu4e
  ;; set mu4e-use-maildirs-extension-load to be evaluated after mu4e has been loaded.
  (require 'mu4e-maildirs-extension)
  (mu4e-maildirs-extension)
  (setq mu4e-maildirs-extension-action-key ""
        mu4e-maildirs-extension-action-text nil)

  ;; ;; set a full-path of mu binary
  ;; (setq mu4e-mu-binary "/usr/local/bin/mu")

  ;; to use mu4e-headers-mark-all
  (require 'mu4e-contrib)

  ;; Turn off auto-fill-mode when compose an email.
  (add-hook 'mu4e-compose-mode-hook 'turn-off-auto-fill)

  (setq mu4e-headers-results-limit 100
        mu4e-headers-visible-lines 10
        mu4e-sent-messages-behavior 'delete
        ;; mu4e-user-mail-address-list '("jonghyun.yun@gmail.com" "j.yun@uta.edu")
        )

  ;; Set up some common mu4e variables
  (setq ;; mu4e-maildir "~/.mail"
   mu4e-get-mail-command "mbsync --pull-new --push gmail"
   ;; mu4e-get-mail-command "mbsync -a"
   ;; mu4e-get-mail-command "mbsync gmail"
   ;; update database every x seconds
   mu4e-update-interval 1800
   mu4e-compose-signature-auto-include nil
   mu4e-view-show-images t ;; slow rendering with t
   mu4e-view-show-addresses t
   mu4e-use-fancy-chars nil
   mu4e-attachment-dir "~/Downloads"
   ;; for mbsync
   ;; rename files when moving - NEEDED FOR MBSYNC not to duplicate UIDs
   mu4e-change-filenames-when-moving t
   mu4e-confirm-quit nil
   mu4e-headers-skip-duplicates t
   message-kill-buffer-on-exit t
   )

  ;; use imagemagick, if available
  (when (fboundp 'imagemagick-register-types)
    (imagemagick-register-types))

  ;; open message in external browse if it's too long
  (defun jyun/mu4e-html2text (msg)
    "My html2text function; shows short message inline, show
  long messages in some external browser (see `browse-url-generic-program')."
    (let ((html (or (mu4e-message-field msg :body-html) "")))
      (if (< (length html) 10000)
          (mu4e-shr2text msg)
        (if (yes-or-no-p "View in external browser? ")
            (progn
              (mu4e-action-view-in-browser msg)
              "[Viewing message in external browser]")
          (mu4e-shr2text msg)
          ))))

  (setq mu4e-html2text-command 'jyun/mu4e-html2text)

  ;; tell mu4e to use w3m for html rendering
  ;; (setq mu4e-html2text-command "w3m -T text/html")
  ;; (setq mu4e-html2text-command
  ;; "textutil -stdin -format html -convert txt -stdout") ;; for OSX only, no html link
  ;; (setq mu4e-html2text-command "html2text -utf8 -width 72") ;; poor visibility
  ;; (setq mu4e-html2text-command
  ;; "html2markdown | grep -v '&nbsp_place_holder;'") ;; don't know how to install
  ;; (setq mu4e-html2text-command 'mu4e-shr2text) ;; slow rendering with images

  ;; read emails in dark theme.
  ;; this should be after (setq mu4e-html2text-command 'jyun/mu4e-html2text) to be effective.
  ;; https://www.reddit.com/r/emacs/comments/6ul9rz/email_html_rendering_mu4e_with_html2text_how_to/
  (setq shr-color-visible-luminance-min 80
        shr-color-visible-distance-min 5)

  ;; (add-hook 'mu4e-view-mode-hook
  ;;           (lambda()
  ;;             ;; try to emulate some of the eww key-bindings
  ;;             (local-set-key (kbd "<tab>") 'shr-next-link)
  ;;             (local-set-key (kbd "<backtab>") 'shr-previous-link)))

  ;; (require 'mu4e-context)
  ;; (setq mu4e-contexts
  ;;       `(
  ;;         ,(make-mu4e-context
  ;;           :name "Gmail"
  ;;           :enter-func (lambda () (mu4e-message "Switch to the Gmail context"))
  ;;           ;; leave-func not defined
  ;;           :match-func (lambda (msg)
  ;;                         (when msg
  ;;                           ;; (string-prefix-p "/gmail" (mu4e-message-field msg :maildir))))
  ;;                           (mu4e-message-contact-field-matches msg
  ;;                                                               :to "jonghyun.yun@gmail.com")))
  ;;           :vars '(  ( user-mail-address      . "jonghyun.yun@gmail.com"  )
  ;;                     ;; ( mu4e-sent-messages-behavior 'delete)
  ;;                     ( mu4e-sent-folder . "/gmail/[Gmail]/Sent Mail")
  ;;                     ( mu4e-drafts-folder . "/gmail/[Gmail]/Drafts")
  ;;                     ( mu4e-trash-folder . "/gmail/[Gmail]/Trash")
  ;;                     ( mu4e-refile-folder . "/gmail/[Gmail]/Starred")
  ;;                     ( user-full-name     . "Jonghyun Yun" )
  ;;                     ( mu4e-compose-signature .  (concat
  ;;                                                  "Jonghyun Yun, PhD\n"
  ;;                                                  "Statistical Data Scientist\n"
  ;;                                                  "https://jyun.rbind.io\n"
  ;;                                                  ))))
  ;;         ,(make-mu4e-context
  ;;           :name "UTA"
  ;;           :enter-func (lambda () (mu4e-message "Switch to the UTA context"))
  ;;           ;; leave-fun not defined
  ;;           :match-func (lambda (msg)
  ;;                         (when msg
  ;;                           ;; (string-prefix-p "/uta" (mu4e-message-field msg :maildir))))
  ;;                           (mu4e-message-contact-field-matches msg
  ;;                                                               :to "j.yun@uta.edu")))
  ;;           :vars '(  ( user-mail-address      . "j.yun@uta.edu" )
  ;;                     ;; (mu4e-sent-messages-behavior delete)
  ;;                     ( mu4e-sent-folder . "/uta/Sent")
  ;;                     ( mu4e-drafts-folder . "/uta/Drafts")
  ;;                     ( mu4e-trash-folder . "/uta/Trash")
  ;;                     ( mu4e-refile-folder . "/uta/Archive")
  ;;                     ( user-full-name     . "Jonghyun Yun" )
  ;;                     ( mu4e-compose-signature . (concat
  ;;                                                 "Jonghyun Yun, Ph.D.\n"
  ;;                                                 "Assistant Professor\n"
  ;;                                                 "UT Arlington, Dept. of Mathematics\n\n"
  ;;                                                 "655 W Mitchell St, SEIR 218\n"
  ;;                                                 "Arlington, TX 76010\n"
  ;;                                                 "Phone: 817-272-9045\n"
  ;;                                                 "Fax: 817-272-5802\n"))
  ;;                     ))
  ;;         ))

  ;; set `mu4e-context-policy` and `mu4e-compose-policy` to tweak when mu4e should
  ;; guess or ask the correct context, e.g.

  ;; start with the first (default) context;
  ;; default is to ask-if-none (ask when there's no context yet, and none match)
  (setq mu4e-context-policy 'pick-first)

  ;; compose with the current context is no context matches;
  ;; default is to ask
  (setq mu4e-compose-context-policy
        nil
        ;; 'always-ask
        )

  ;; setup some handy shortcuts
  ;; you can quickly switch to your Inbox -- press ``jg'' or ``ju''
  ;; then, when you want archive some messages, move them to
  ;; the 'All Mail' folder by pressing ``ma''.
  (setq mu4e-maildir-shortcuts
        '(("/gmail/INBOX" . ?g)
          ("/uta/INBOX" . ?u)
          ))

  ;; move to trash
  ;; (fset 'mu4e-move-to-trash "mt")
  ;; (define-key mu4e-headers-mode-map (kbd "d") 'mu4e-move-to-trash)
  ;; (define-key mu4e-view-mode-map (kbd "d") 'mu4e-move-to-trash)

  ;; ;; Bookmarks
  (setq mu4e-bookmarks
        `(("flag:unread AND NOT flag:trashed" "All unread messages" ?a)
          ("date:today..now" "Today's messages" ?t)
          ("date:7d..now" "Last 7 days" ?w)
          ("mime:image/*" "Messages with images" ?p)
          (,(mapconcat 'identity
                       (mapcar
                        (lambda (maildir)
                          (concat "maildir:" (car maildir)))
                        mu4e-maildir-shortcuts) " OR ")
           "All inboxes" ?i)
          (,(concat
             "flag:unread"
             " AND NOT flag:trashed"
             " AND maildir:"
             "\"/uta/INBOX\""
             ) "Unread UTA messages" ?u)
          (,(concat
             "flag:unread"
             " AND NOT flag:trashed"
             " AND maildir:"
             "\"/gmail/INBOX\""
             ) "Unread Gmail messages" ?g)
          ))

  ;; ;; change the behavior of "trash" mark "+T-N" to "+S-N" (read and move to trash)
  ;; ;; change only a partial definition failed, so redefine the whole
  ;; (defvar mu4e-marks
  ;;   '((refile
  ;;      :char ("r" . "▶")
  ;;      :prompt "refile"
  ;;      :dyn-target (lambda (target msg) (mu4e-get-refile-folder msg))
  ;;      :action (lambda (docid msg target) (mu4e~proc-move docid
  ;;                                                         (mu4e~mark-check-target target) "-N")))
  ;;     (delete
  ;;      :char ("D" . "❌")
  ;;      :prompt "Delete"
  ;;      :show-target (lambda (target) "delete")
  ;;      :action (lambda (docid msg target) (mu4e~proc-remove docid)))
  ;;     (flag
  ;;      :char ("+" . "✚")
  ;;      :prompt "+flag"
  ;;      :show-target (lambda (target) "flag")
  ;;      :action (lambda (docid msg target) (mu4e~proc-move docid nil "+F-u-N")))
  ;;     (move
  ;;      :char ("m" . "▷")
  ;;      :prompt "move"
  ;;      :ask-target  mu4e~mark-get-move-target
  ;;      :action (lambda (docid msg target) (mu4e~proc-move docid
  ;;                                                         (mu4e~mark-check-target target) "-N")))
  ;;     (read
  ;;      :char    ("!" . "◼")
  ;;      :prompt "!read"
  ;;      :show-target (lambda (target) "read")
  ;;      :action (lambda (docid msg target) (mu4e~proc-move docid nil "+S-u-N")))
  ;;     (trash
  ;;      :char ("d" . "▼")
  ;;      :prompt "dtrash"
  ;;      :dyn-target (lambda (target msg) (mu4e-get-trash-folder msg))
  ;;      :action (lambda (docid msg target) (mu4e~proc-move docid
  ;;                                                         (mu4e~mark-check-target target) "+S-N")))
  ;;     (unflag
  ;;      :char    ("-" . "➖")
  ;;      :prompt "-unflag"
  ;;      :show-target (lambda (target) "unflag")
  ;;      :action (lambda (docid msg target) (mu4e~proc-move docid nil "-F-N")))
  ;;     (untrash
  ;;      :char   ("=" . "▲")
  ;;      :prompt "=untrash"
  ;;      :show-target (lambda (target) "untrash")
  ;;      :action (lambda (docid msg target) (mu4e~proc-move docid nil "-T")))
  ;;     (unread
  ;;      :char    ("?" . "◻")
  ;;      :prompt "?unread"
  ;;      :show-target (lambda (target) "unread")
  ;;      :action (lambda (docid msg target) (mu4e~proc-move docid nil "-S+u-N")))
  ;;     (unmark
  ;;      :char  " "
  ;;      :prompt "unmark"
  ;;      :action (mu4e-error "No action for unmarking"))
  ;;     (action
  ;;      :char ( "a" . "◯")
  ;;      :prompt "action"
  ;;      :ask-target  (lambda () (mu4e-read-option "Action: " mu4e-headers-actions))
  ;;      :action  (lambda (docid msg actionfunc)
  ;;                 (save-excursion
  ;;                   (when (mu4e~headers-goto-docid docid)
  ;;                     (mu4e-headers-action actionfunc)))))
  ;;     (something
  ;;      :char  ("*" . "✱")
  ;;      :prompt "*something"
  ;;      :action (mu4e-error "No action for deferred mark")))

;;; mu4e-actions
  ;; ;; overide default mu4e-action-view-as-pdf
  ;; ;; msg2pdf isn't easy to make working
  ;; (defvar mu4e-message-to-pdf-dir "~/Downloads/"
  ;;   "A directory to save messages in PDF.")
  ;; (defun mu4e-action-view-as-pdf (msg)
  ;;   (let* ((date (mu4e-message-field msg :date))
  ;;          (infile (mu4e~write-body-to-html msg))
  ;;          (pdf (concat mu4e-message-to-pdf-dir (format-time-string "mu4e_%Y-%m-%d_%H%M%S_%Z.pdf" date))))
  ;;     (with-temp-buffer
  ;;       (shell-command
  ;;        (format "wkhtmltopdf %s %s" infile pdf) "*mu4e-to-pdf*"))
  ;;     (unless (and pdf (file-exists-p pdf))
  ;;       (mu4e-warn "Failed to create PDF file"))
  ;;     (find-file pdf)))

;;; org-capture
  (defun jyun/mu4e-org-capture-message (MSG)
    "Call org-capture to capture a message in `mu4e-view-mode'."
    (interactive)
    (let ((from (plist-get MSG :from)))
      (setq jyun/target-mu4e-subject (mu4e-message-field MSG :subject))
      (setq jyun/target-mu4e-from-subject
            (concat "Respond to "
                    "[[mu4e:msgid:"
                    (plist-get MSG :message-id) "]["
                    (truncate-string-to-width
                     (or (caar from) (cdar from)) 25 nil nil t)
                    " - "
                    (truncate-string-to-width
                     (plist-get MSG :subject) 40 nil nil t)
                    "]] "))
      (org-capture nil "ATE")))

  (defun jyun/mu4e-org-capture-message-in-headers (MSG)
    "Call org-capture to capture a message in `mu4e-headers-mode'."
    (interactive)
    ;; (let
    ;;     ((MSG
    ;;       (mu4e-message-at-point)))
    (when MSG
      (jyun/mu4e-org-capture-message MSG))
    )

  (add-to-list 'mu4e-view-actions
               '("Capture to org-mode" . jyun/mu4e-org-capture-message))

  (add-to-list 'mu4e-headers-actions
               '("Capture to org-mode" . jyun/mu4e-org-capture-message-in-headers))

  (add-to-list 'mu4e-headers-actions
               '("view in browser" . mu4e-action-view-in-browser))


;;; email send
  (setq sendmail-program "/usr/local/bin/msmtp"
        message-send-mail-function 'message-send-mail-with-sendmail
        ;; user-full-name "Jonghyun Yun")
        ;; tell msmtp to choose the SMTP server according to the from field in the outgoing email
        message-sendmail-extra-arguments '("--read-envelope-from")
        message-sendmail-f-is-evil 't)
  )

;;; alert
;; (use-package mu4e-alert
;;   :defer t
;;   :init (with-eval-after-load 'mu4e
;;           (mu4e-alert-enable-notifications)
;;           (mu4e-alert-enable-mode-line-display))
;;   :config
;;   ;; Enable Desktop notifications
;;   ;; (mu4e-alert-set-default-style 'notifications)) ; For linux
;;   ;; (mu4e-alert-set-default-style 'libnotify))  ; Alternative for linux
;;   (mu4e-alert-set-default-style 'notifier) ; For Mac OSX (through the terminal notifier app)
;;   ;; (mu4e-alert-set-default-style 'growl))      ; Alternative for Mac OSX

;;   (setq mu4e-alert-interesting-mail-query
;;         (concat
;;          "flag:unread"
;;          " AND NOT flag:trashed"
;;          " AND NOT maildir:"
;;          "\"/gmail/[Gmail]/Trash\""
;;          " AND NOT maildir:\"/uta/Trash\""
;;          ))

;;   (setq mu4e-alert-email-notification-types '(count)))

(after! (org-capture mu4e)
  ;; email capture
  ;;     (add-to-list 'org-capture-templates
  ;;                  '("ATE" "Attention to Emails" entry
  ;;                    (file+headline +org-capture-inbox-file "Email")
  ;;                    "* TODO %(message jyun/target-mu4e-from-subject) :@email:
  ;; DEADLINE: %(org-insert-time-stamp (org-read-date nil t \"today\"))
  ;; :PROPERTIES:
  ;; :CREATED: %U
  ;; :LINK: %a
  ;; :END:
  ;;   %i \n%?"
  ;;                    :immediate-finish t))

  (add-to-list 'org-capture-templates
               '("ATE" "Attention to Emails" entry
                 (file+headline +org-capture-inbox-file "Email")
                 "* TODO %(message jyun/target-mu4e-from-subject) :@email:
DEADLINE: %(org-insert-time-stamp (org-read-date nil t \"today\")) \n%i \n%?"
                 :empty-lines 1
                 :prepend nil
                 :immediate-finish t))
  )

;;; mu4e-plus.el ends here
