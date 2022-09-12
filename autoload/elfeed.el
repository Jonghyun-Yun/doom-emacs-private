;; ;;; ../Dropbox/emacs/.doom.d/autoload/elfeed.el -*- lexical-binding: t; -*-
;; ;;;###if (modulep! :app rss)


;; (defvar +my-elfeed-workspace-name "*elfeed*")
;; (defvar +my-elfeed--old-wconf nil)

;; (add-hook 'elfeed-search-mode-hook #'+my-elfeed-init-h)

;; ;;;###autoload
;; (defun my-elfeed ()
;;   (interactive)
;;   (if (modulep! :ui workspaces)
;;       (+workspace-switch +my-elfeed-workspace-name t)
;;     (setq +my-elfeed--old-wconf (current-window-configuration))
;;     (delete-other-windows)
;;     (switch-to-buffer (doom-fallback-buffer)))
;;   (elfeed)
;;   )

;; ;;;###autoload
;; (defun +my-elfeed-init-h ()
;;   (add-hook 'kill-buffer-hook #'+my-elfeed-kill-elfeed-h nil t))

;; ;;;###autoload
;; (defun +my-elfeed-kill-elfeed-h ()
;;   ;; (prolusion-mail-hide)
;;   (cond
;;    ((and (modulep! :ui workspaces) (+workspace-exists-p +my-elfeed-workspace-name))
;;     (+workspace/delete +my-elfeed-workspace-name))

;;    (+my-elfeed--old-wconf
;;     (set-window-configuration +my-elfeed--old-wconf)
;;     (setq +my-elfeed--old-wconf nil))))

(defcustom elfeed-entry-font '(;; :family "Roboto Slab"
                               ;; :family "Alegreya"
                               ;; :family "Merriweather"
                               :family "Libre Baskerville"
                               :height 1.0)
  "A font to be used as `shr-current-font' for elfeed entires."
  :group 'elfeed)

(defcustom elfeed-goodies/feed-source-column-width 16
  "Width of the feed source column."
  :group 'elfeed-goodies
  :type 'integer)

(defcustom elfeed-goodies/tag-column-width 24
  "Width of the tags column."
  :group 'elfeed-goodies
  :type 'integer)

(defcustom elfeed-goodies/wide-threshold 0.5
  "Minimum width of the window (percent of the frame) to start using the wide layout from."
  :group 'elfeed-goodies
  :type 'float)

;;;###autoload
(defun jyun/score-entry-line-draw (entry)
  "Print ENTRY to the buffer."

  (let* ((title (or (elfeed-meta entry :title) (elfeed-entry-title entry) ""))
         (title-faces (elfeed-search--faces (elfeed-entry-tags entry)))
         (feed (elfeed-entry-feed entry))
         (feed-title
          (when feed
            (or (elfeed-meta feed :title) (elfeed-feed-title feed))))
         (tags (mapcar #'symbol-name (elfeed-entry-tags entry)))
         ;; (tags-str (concat "[" (mapconcat 'identity tags ",") "]"))
         (tags-str (concat (mapconcat 'identity tags ",")))
         (date (elfeed-search-format-date (elfeed-entry-date entry)))
         (score
          (elfeed-score-format-score
           (elfeed-score-scoring-get-score-from-entry entry)))
         (title-width (- (window-width) elfeed-goodies/feed-source-column-width
                         elfeed-goodies/tag-column-width 4))
         (title-column (elfeed-format-column
                        title (elfeed-clamp
                               elfeed-search-title-min-width
                               title-width
                               title-width)
                        :left))
         (tag-column (elfeed-format-column
                      tags-str (elfeed-clamp (length tags-str)
                                             elfeed-goodies/tag-column-width
                                             elfeed-goodies/tag-column-width)
                      :left))
         (feed-column (elfeed-format-column
                       feed-title (elfeed-clamp elfeed-goodies/feed-source-column-width
                                                elfeed-goodies/feed-source-column-width
                                                elfeed-goodies/feed-source-column-width)
                       :left)))

    (if (>= (window-width) (* (frame-width) elfeed-goodies/wide-threshold))
        (progn
          (when score (insert score))
          (insert (propertize date 'face 'elfeed-search-date-face) " ")
          (insert (propertize feed-column 'face 'elfeed-search-feed-face) " ")
          (insert (propertize tag-column 'face 'elfeed-search-tag-face) " ")
          (insert (propertize title 'face title-faces 'kbd-help title)))
      (insert (propertize title 'face title-faces 'kbd-help title)))
    (setq-local line-spacing 0.1)
    ))

;;;###autoload
(defun jyun/elfeed-org-capture-entry ()
  "Capture Elfeed entry to `inbox.org'."
  (interactive)
  (when elfeed-show-entry
    (setq jyun/target-elfeed-entry elfeed-show-entry
          jyun/target-elfeed-entry-title (elfeed-entry-title jyun/target-elfeed-entry)
          jyun/target-elfeed-entry-url (elfeed-entry-link jyun/target-elfeed-entry)
          jyun/target-elfeed-title-link
          (concat "Read - [[" (plist-get org-store-link-plist :link)
                  "]["
                  (truncate-string-to-width jyun/target-elfeed-entry-title
                                            70 nil nil t)
                  "]] "))
    (org-capture nil "EFE")
    ;; (org-update-parent-todo-statistics)
    )
  )

;;;###autoload
(defadvice! +rss-elfeed-wrap-h-nicer ()
  "Enhances an elfeed entry's readability by wrapping it to a width of
`fill-column' and centering it with `visual-fill-column-mode'."
  :override #'+rss-elfeed-wrap-h
  (setq-local truncate-lines nil
              shr-width 120
              ;; visual-fill-column-center-text t
              default-text-properties '(line-height 1.1)
              )
  (let ((inhibit-read-only t)
        (inhibit-modification-hooks t))
    ;; (visual-fill-column-mode)
    (setq-local shr-current-font elfeed-entry-font)
    (set-buffer-modified-p nil)))

;;;; get pdf from elfeed entry
;; https://tecosaur.github.io/emacs-config/config.html
(defvar elfeed-pdf-dir
  (expand-file-name "pdfs/"
                    (file-name-directory (directory-file-name elfeed-enclosure-default-dir))))

(defvar elfeed-link-pdfs
  '(("https://www.jstatsoft.org/index.php/jss/article/view/v0\\([^/]+\\)" . "https://www.jstatsoft.org/index.php/jss/article/view/v0\\1/v\\1.pdf")
    ("http://arxiv.org/abs/\\([^/]+\\)" . "https://arxiv.org/pdf/\\1.pdf"))
  "List of alists of the form (REGEX-FOR-LINK . FORM-FOR-PDF)")

;;;###autoload
(defun elfeed-show-pdf (entry)
  (interactive
   (list (or elfeed-show-entry (elfeed-search-selected :ignore-region))))
  (require 'url)
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

;;; elfeed-db-compact takes > 10 sec
;;;###autoload
(defadvice! jyun/rss-cleanup-h ()
  :override #'+rss-cleanup-h
  "Disable db compression. Clean up after an elfeed session. Kills all elfeed and elfeed-org files."
  (interactive)
  ;; `delete-file-projectile-remove-from-cache' slows down `elfeed-db-compact'
  ;; tremendously, so we disable the projectile cache:
  ;; (let (projectile-enable-caching)
  ;;   (elfeed-db-compact))
  (let ((buf (previous-buffer)))
    (when (or (null buf) (not (doom-real-buffer-p buf)))
      (switch-to-buffer (doom-fallback-buffer))))
  (let ((search-buffers (doom-buffers-in-mode 'elfeed-search-mode))
        (show-buffers (doom-buffers-in-mode 'elfeed-show-mode))
        kill-buffer-query-functions)
    (dolist (file (bound-and-true-p rmh-elfeed-org-files))
      (when-let (buf (get-file-buffer (expand-file-name file org-directory)))
        (kill-buffer buf)))
    (dolist (b search-buffers)
      (with-current-buffer b
        (remove-hook 'kill-buffer-hook #'+rss-cleanup-h :local)
        (kill-buffer b)))
    (mapc #'kill-buffer show-buffers))
  (if (modulep! :ui workspaces)
      (+workspace/delete "rss")
    (when (window-configuration-p +rss--wconf)
      (set-window-configuration +rss--wconf))
    (setq +rss--wconf nil))
  )

;;;###autoload
(defun jyun/elfeed-search-org-capture-entry (entry)
  "elfeed-search-mode: Capture Elfeed entry to `inbox.org'."
  (interactive
   (list (or elfeed-show-entry (elfeed-search-selected :ignore-region))))
  (setq jyun/target-elfeed-entry-title (elfeed-entry-title entry)
        jyun/target-elfeed-entry-url (elfeed-entry-link entry)
        jyun/target-elfeed-entry-id (elfeed-entry-id entry)
        jyun/target-elfeed-org-link (concat "elfeed:" (car jyun/target-elfeed-entry-id) "#" (cdr jyun/target-elfeed-entry-id))
        jyun/target-elfeed-title-link
        (concat "Read - [["
                ;; (plist-get org-store-link-plist :link)
                jyun/target-elfeed-org-link
                "]["
                (truncate-string-to-width jyun/target-elfeed-entry-title
                                          70 nil nil t)
                "]] "))
  (when elfeed-show-entry
    (elfeed-kill-buffer))
  (org-capture nil "EFE")
  ;; (org-update-parent-todo-statistics)
  )

;;;###autoload
(defun jyun/email-elfeed-entry (entry)
  "Capture the elfeed entry and put it in an email."
  (interactive
   (list (or elfeed-show-entry (elfeed-search-selected :ignore-region))))
  (let* ((title (elfeed-entry-title entry))
         (url (elfeed-entry-link entry))
         (content (elfeed-entry-content entry))
         (entry-id (elfeed-entry-id entry))
         (entry-link (elfeed-entry-link entry))
         (entry-id-str (concat (car entry-id)
                               "|"
                               (cdr entry-id)
                               "|"
                               url)))
    (when elfeed-show-entry
      (elfeed-kill-buffer))

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
