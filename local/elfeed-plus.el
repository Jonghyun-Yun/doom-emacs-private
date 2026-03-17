;;; ../Dropbox/emacs/.doom.d/local/elfeed-plus.el -*- lexical-binding: t; -*-

;;;; ;;; elfeed
;;;; (after! elfeed
;;;;   ;; number of concurrent fetches
;;;;   (elfeed-set-max-connections 5)
;;;;   ;; (run-at-time nil (* 4 60 60) #'elfeed-update)
;;;;                                         ;update every 4 * 60 * 60 sec
;;;;   (setq
;;;;    ;; elfeed-search-title-max-width 100
;;;;    ;; elfeed-search-title-min-width 20
;;;;    ;; elfeed-search-filter "@3-week-ago"
;;;;    elfeed-show-entry-switch #'pop-to-buffer
;;;;    elfeed-show-entry-delete #'+rss/delete-pane
;;;;    ;; elfeed-search-print-entry-function '+rss/elfeed-search-print-entry
;;;;    elfeed-search-print-entry-function 'jyun/score-entry-line-draw
;;;;    ;; shr-max-image-proportion 0.6
;;;;    elfeed-search-date-format '("%m/%d/%y" 10 :left)
;;;;    ))
;;;;
;;;; ;;;; elfeed-summary
;;;; ;; https://github.com/SqrtMinusOne/elfeed-summary
;;;; (use-package! elfeed-summary
;;;;   :after elfeed
;;;;   )
;;;;
;;;; elfeed org-capture
(after! (org-capture elfeed)
  ;; elfeed capture
  (add-to-list 'org-capture-templates
               '("EFE" "Elfeed entry" entry
                 (file+headline +org-capture-inbox-file "Reading")
                 "* TODO %(message jyun/target-elfeed-title-link) :rss:
                  DEADLINE: %(org-insert-time-stamp (org-read-date nil t \"today\"))
                  %(message jyun/target-elfeed-entry-url)
                  %i \n%?"
                 :prepend t
                 :immediate-finish t)))

(after! elfeed
  ;; Pick a font from your Doom setup
  (defvar elfeed-entry-font doom-variable-pitch-font
    "Font spec to use when displaying Elfeed entries.")
  )

;;;;
;;;; ;; ;; A snippet for periodic update for feeds (10 mins since Emacs start, then every
;;;; ;; ;; two hour)
;;;; ;; (run-at-time (* 10 60) (* 2 60 60) #'(lambda () (progn
;;;; ;;                                              (elfeed-set-max-connections 3)
;;;; ;;                                              (elfeed-update))))
;;;;
;;;; ;; (defvar doom-elfeed-dir (concat doom-private-dir ".local/elfeed/")
;;;; ;;   "TODO")
;;;; ;; (after! elfeed
;;;; ;;   (setq elfeed-db-directory (concat doom-elfeed-dir "db/")
;;;; ;;         elfeed-enclosure-default-dir (concat doom-elfeed-dir "enclosures/"))
;;;; ;;   )
;;;;
;;;; ;;;; elfeed-score
;;;; (use-package! elfeed-score
;;;;   :after elfeed
;;;;   :init
;;;;   (setq elfeed-score-score-file (expand-file-name "elfeed.score" doom-private-dir))
;;;;   :config
;;;;   (progn
;;;;     ;; (elfeed-score-enable)
;;;;     (evil-define-key 'normal elfeed-search-mode-map "=" elfeed-score-map)
;;;;     ;; (define-key elfeed-search-mode-map "=" elfeed-score-map)
;;;;     ;; scores displayed in the search buffer
;;;;     ;; (setq elfeed-search-print-entry-function 'jyun/score-entry-line-draw)
;;;;     )
;;;;   )


;; yt-dlp
(defvar yt-dlp-video-dir "/Users/yunj/Desktop/Videos/")
(when IS-LINUX
  (setq yt-dlp-video-dir "/home/yunj/Videos/"))

(defun yt-dlp-elfeed ()
  "Download the current entry's Youtube video using `yt-dlp'. "
  (interactive)
  (let ((link (elfeed-entry-link elfeed-show-entry)))
    (when link
      (message "Downloading the Youtube Video: %s" link)
      (emacs-yt-dlp link))))

(map!
 (:map elfeed-show-mode-map
  :n "g C-o" #'yt-dlp-elfeed
  ))

(defun emacs-yt-dlp (&optional link)
  (interactive)
  (let ((fpath (or link (elfeed-get-link-at-point))))
    (async-start-process "yt-dlp" "yt-dlp" nil (concat  "-o" yt-dlp-video-dir "%(title)s-%(id)s.%(ext)s") fpath)
    (message (concat "Starting download: " fpath))
    )
  )
