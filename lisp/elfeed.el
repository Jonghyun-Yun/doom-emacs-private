;; -*- no-byte-compile: t; -*-
;;; ../Dropbox/emacs/.doom.d/elfeed.el

;;; elfeed
;; (evil-set-initial-state 'elfeed-search-mode 'emacs)
;; (evil-set-initial-state 'elfeed-show-mode 'emacs)

(after! elfeed
  (setq elfeed-search-title-max-width 100
        elfeed-search-title-min-width 20)
  (run-at-time nil (* 8 60 60) #'elfeed-update)
  (setq elfeed-search-filter "@2-week-ago"))

(use-package elfeed-score
  :after elfeed
  :init
  (setq elfeed-score-score-file (expand-file-name "elfeed.score" doom-private-dir))
  :config
  (progn
    (elfeed-score-enable)
    (define-key elfeed-search-mode-map "=" elfeed-score-map)
    ;; scores displayed in the search buffer
    (setq elfeed-search-print-entry-function #'elfeed-score-print-entry)))

(map! :map elfeed-search-mode-map
      :after elfeed-search
      ;; [remap kill-this-buffer] "q"
      ;; [remap kill-buffer] "q"
      ;; :n doom-leader-key nil
      ;; :n "q" #'+rss/quit
      ;; :n "U" #'elfeed-search-untag-all-unread
      ;; :n "u" #'elfeed-search-tag-all-unread
      ;; :n "s" #'elfeed-search-live-filter
      :ne "RET" #'+rss/open
      :n "p" #'elfeed-show-pdf
      ;; :n "+" #'elfeed-search-tag-all
      ;; :n "-" #'elfeed-search-untag-all
      ;; :n "S" #'elfeed-search-set-filter
      ;; :n "M-RET" #'elfeed-search-browse-url
      ;; :n "y" #'elfeed-search-yank
      )
(map! :map elfeed-show-mode-map
      :after elfeed-show
      ;; [remap kill-this-buffer] "q"
      ;; [remap kill-buffer] "q"
      ;; :n doom-leader-key nil
      :nm "q" #'+rss/delete-pane
      ;; :nm "o" #'ace-link-elfeed
      ;; :nm "RET" #'org-ref-elfeed-add
      ;; [remap elfeed-show-next] #'+rss/next
      ;; [remap elfeed-show-prev] #'rss/previous ;;error
      :nm "p" #'elfeed-show-pdf
      ;; :nm "+" #'elfeed-show-tag
      ;; :nm "-" #'elfeed-show-untag
      ;; :nm "s" #'elfeed-show-new-live-search
      ;; :nm "y" #'elfeed-show-yank
      )

(after! elfeed

;;   ;; (elfeed-org)
;;   (use-package! elfeed-link)

  (setq ;; elfeed-search-filter "@1-week-ago +unread"
   ;; elfeed-search-print-entry-function '+rss/elfeed-search-print-entry
   ;;         elfeed-search-title-min-width 80
   elfeed-show-entry-switch #'pop-to-buffer
   elfeed-show-entry-delete #'+rss/delete-pane
   ;; elfeed-show-refresh-function #'+rss/elfeed-show-refresh--better-style
   ;; shr-max-image-proportion 0.6
   )

;;   (add-hook! 'elfeed-show-mode-hook (hide-mode-line-mode 1))
;;   (add-hook! 'elfeed-search-update-hook #'hide-mode-line-mode)

;;   (defface elfeed-show-title-face '((t (:weight ultrabold :slant italic :height 1.5)))
;;     "title face in elfeed show buffer"
;;     :group 'elfeed)
;;   (defface elfeed-show-author-face `((t (:weight light)))
;;     "title face in elfeed show buffer"
;;     :group 'elfeed)
;;   (set-face-attribute 'elfeed-search-title-face nil
;;                       :foreground 'nil
;;                       :weight 'light)

;;   (defadvice! +rss-elfeed-wrap-h-nicer ()
;;     "Enhances an elfeed entry's readability by wrapping it to a width of
;; `fill-column' and centering it with `visual-fill-column-mode'."
;;     :override #'+rss-elfeed-wrap-h
;;     (setq-local truncate-lines nil
;;                 shr-width 120
;;                 visual-fill-column-center-text t
;;                 default-text-properties '(line-height 1.1))
;;     (let ((inhibit-read-only t)
;;           (inhibit-modification-hooks t))
;;       (visual-fill-column-mode)
;;       ;; (setq-local shr-current-font '(:family "Merriweather" :height 1.2))
;;       (set-buffer-modified-p nil)))

;;   (defun +rss/elfeed-search-print-entry (entry)
;;     "Print ENTRY to the buffer."
;;     (let* ((elfeed-goodies/tag-column-width 40)
;;            (elfeed-goodies/feed-source-column-width 30)
;;            (title (or (elfeed-meta entry :title) (elfeed-entry-title entry) ""))
;;            (title-faces (elfeed-search--faces (elfeed-entry-tags entry)))
;;            (feed (elfeed-entry-feed entry))
;;            (feed-title
;;             (when feed
;;               (or (elfeed-meta feed :title) (elfeed-feed-title feed))))
;;            (tags (mapcar #'symbol-name (elfeed-entry-tags entry)))
;;            (tags-str (concat (mapconcat 'identity tags ",")))
;;            (title-width (- (window-width) elfeed-goodies/feed-source-column-width
;;                            elfeed-goodies/tag-column-width 4))

;;            (tag-column (elfeed-format-column
;;                         tags-str (elfeed-clamp (length tags-str)
;;                                                elfeed-goodies/tag-column-width
;;                                                elfeed-goodies/tag-column-width)
;;                         :left))
;;            (feed-column (elfeed-format-column
;;                          feed-title (elfeed-clamp elfeed-goodies/feed-source-column-width
;;                                                   elfeed-goodies/feed-source-column-width
;;                                                   elfeed-goodies/feed-source-column-width)
;;                          :left)))

;;       (insert (propertize feed-column 'face 'elfeed-search-feed-face) " ")
;;       (insert (propertize tag-column 'face 'elfeed-search-tag-face) " ")
;;       (insert (propertize title 'face title-faces 'kbd-help title))
;;       (setq-local line-spacing 0.2)))

;;   (defun +rss/elfeed-show-refresh--better-style ()
;;     "Update the buffer to match the selected entry, using a mail-style."
;;     (interactive)
;;     (let* ((inhibit-read-only t)
;;            (title (elfeed-entry-title elfeed-show-entry))
;;            (date (seconds-to-time (elfeed-entry-date elfeed-show-entry)))
;;            (author (elfeed-meta elfeed-show-entry :author))
;;            (link (elfeed-entry-link elfeed-show-entry))
;;            (tags (elfeed-entry-tags elfeed-show-entry))
;;            (tagsstr (mapconcat #'symbol-name tags ", "))
;;            (nicedate (format-time-string "%a, %e %b %Y %T %Z" date))
;;            (content (elfeed-deref (elfeed-entry-content elfeed-show-entry)))
;;            (type (elfeed-entry-content-type elfeed-show-entry))
;;            (feed (elfeed-entry-feed elfeed-show-entry))
;;            (feed-title (elfeed-feed-title feed))
;;            (base (and feed (elfeed-compute-base (elfeed-feed-url feed)))))
;;       (erase-buffer)
;;       (insert "\n")
;;       (insert (format "%s\n\n" (propertize title 'face 'elfeed-show-title-face)))
;;       (insert (format "%s\t" (propertize feed-title 'face 'elfeed-search-feed-face)))
;;       (when (and author elfeed-show-entry-author)
;;         (insert (format "%s\n" (propertize author 'face 'elfeed-show-author-face))))
;;       (insert (format "%s\n\n" (propertize nicedate 'face 'elfeed-log-date-face)))
;;       (when tags
;;         (insert (format "%s\n"
;;                         (propertize tagsstr 'face 'elfeed-search-tag-face))))
;;       ;; (insert (propertize "Link: " 'face 'message-header-name))
;;       ;; (elfeed-insert-link link link)
;;       ;; (insert "\n")
;;       (cl-loop for enclosure in (elfeed-entry-enclosures elfeed-show-entry)
;;                do (insert (propertize "Enclosure: " 'face 'message-header-name))
;;                do (elfeed-insert-link (car enclosure))
;;                do (insert "\n"))
;;       (insert "\n")
;;       (if content
;;           (if (eq type 'html)
;;               (elfeed-insert-html content base)
;;             (insert content))
;;         (insert (propertize "(empty)\n" 'face 'italic)))
;;       (goto-char (point-min))))

)