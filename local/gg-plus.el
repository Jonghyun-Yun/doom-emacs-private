;;; ../Dropbox/emacs/.doom.d/local/gg-plus.el -*- lexical-binding: t; -*-

(map! :leader
      "s G y" #'search-your-gg-all
      "s G o" #'search-op-gg-all
      "s G m" #'multi-search-your-gg)

(defun search-your-gg (beg end)
  "message region or \"empty string\" if none highlighted"
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list (point-min) (point-min))))
  (let ((selection (buffer-substring-no-properties beg end)))
    (if (= (length selection) 0)
        (message "empty string")
      (browse-url (format "https://your.gg/na/profile/%s" selection)))))

(defun search-op-gg-all ()
  (interactive)
  (search-gg-all "https://na.op.gg/summoner/userName=%s"))

(defun search-your-gg-all ()
  (interactive)
  (search-gg-all "https://your.gg/na/profile/%s"))

;; (defun serach-your-gg-all ()
;; (interactive)
;;   ;; list to string, seperated by comma
;;   (make-user-name-list)
;;   (let ((query-format "https://your.gg/na/profile/%s"))
;;     (dolist (name your-gg-multi-selection)
;;       (shell-command (concat "open -a safari " (format query-format name)))
;;       )
;;     )
;;   )

(defun make-user-name-list ()
  (mark-paragraph)
  (next-line 1)
  (beginning-of-line)
  (setq your-gg-multi-selection '())
  (let (
        (beg (region-beginning))
        (end (region-end)))
    (save-excursion
      (save-restriction
        (narrow-to-region beg end)
        ;; remove joined the lobby strings
        (let ((case-fold-search nil))
          (goto-char (point-min))
          (while (search-forward " joined the lobby" nil t)
            (replace-match "")))
        ;; mark lines and search them in your.gg
        (goto-char (point-min))
        (while (< (point) (point-max))
          (let ((selection (buffer-substring-no-properties
                            (line-beginning-position)
                            (line-end-position))))
            (when (not (= (length selection) 0))
              (progn
                (add-to-list 'your-gg-multi-selection selection)
                (sit-for 0.1)
                ))
            )
          (forward-line 1)
          )
        )
      ))
  your-gg-multi-selection)

(defun multi-search-your-gg ()
  (interactive)
  ;; list to string, seperated by comma
  (make-user-name-list)
  (let ((multi-selection (reduce (lambda (a b)
                                   (concatenate 'string a "," b))
                                 your-gg-multi-selection))
        (query-format "https://your.gg/na/ai/multisearch/result?text=%s"))
    (shell-command (concat "open -a safari \"" (format query-format multi-selection) "\""))
    ))

(defun search-gg-all (query-format)
  "Search all user names using `query-format'."
  (mark-paragraph)
  (next-line)
  (beginning-of-line)
  (let ((beg (region-beginning))
        (end (region-end)))
    (save-excursion
      (save-restriction
        (narrow-to-region beg end)
        ;; remove joined the lobby strings
        (let ((case-fold-search nil))
          (goto-char (point-min))
          (while (search-forward " joined the lobby" nil t)
            (replace-match "")))
        ;; mark lines and search them in your.gg
        (goto-char (point-min))
        (while (not (eobp))
          (let ((selection (buffer-substring-no-properties
                            (line-beginning-position)
                            (line-end-position))))
            (when (and (not (= (length selection) 0)) (not (string-match "lov3pinky" selection)))
              (progn
                (shell-command (concat "open -a safari \"" (format query-format selection) "\""))
                ;; (browse-url (format query-format selection))
                (sit-for 0.1)
                )
              )
            (next-line 1)
            ))))))
