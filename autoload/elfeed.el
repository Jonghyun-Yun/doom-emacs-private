;; ;;; ../Dropbox/emacs/.doom.d/autoload/elfeed.el -*- lexical-binding: t; -*-
;; ;;;###if (featurep! :app rss)


;; (defvar +my-elfeed-workspace-name "*elfeed*")
;; (defvar +my-elfeed--old-wconf nil)

;; (add-hook 'elfeed-search-mode-hook #'+my-elfeed-init-h)

;; ;;;###autoload
;; (defun my-elfeed ()
;;   (interactive)
;;   (if (featurep! :ui workspaces)
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
;;    ((and (featurep! :ui workspaces) (+workspace-exists-p +my-elfeed-workspace-name))
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
