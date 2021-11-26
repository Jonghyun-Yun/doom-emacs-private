;;; private/write/autoload.el -*- lexical-binding: t; -*-

(defface +write/dict-face
  '((t (:family "Roboto Slab" :height 1.1)))
  "A face to display dictionaries."
  :group 'basic-faces)


;;;###autoload
(defun +write/buffer-face-mode-dict ()
  "Better fonts and spacing."
  (interactive)
  (setq buffer-face-mode-face '+write/dict-face)
  (buffer-face-mode)
  (setq-local line-spacing 0.5))

;;;###autoload
(defadvice! jyun/mw-thesaurus--create-buffer (word data)
  :override #'mw-thesaurus--create-buffer
  "Disply in a popup buffer."
  (let ((dict-str (mw-thesaurus--parse data)))
    (if (< (length dict-str) 1)
        (message (concat "Sadly, Merriam-Webster doesn't seem to have anything for " word))
      (let ((temp-buf (get-buffer-create mw-thesaurus-buffer-name)))
        ;; (print temp-buf)
        (when (not (bound-and-true-p mw-thesaurus-mode))
          (pop-to-buffer temp-buf))
        (set-buffer temp-buf)
        (with-current-buffer temp-buf
          (read-only-mode -1)
          (setf (buffer-string) "")
          (setf org-hide-emphasis-markers t)
          (funcall 'org-mode)
          (funcall 'mw-thesaurus-mode)
          (insert (decode-coding-string dict-str 'dos))
          (goto-char (point-min))
          (read-only-mode))))))

;;;###autoload
(defadvice! jyun/mw-learner--create-buffer (word data)
  :override #'mw-learner--create-buffer
  "Disply in a popup buffer."
  (let ((dict-str (mw-learner--parse data)))
    (if (< (length dict-str) 1)
        (message (concat "Sadly, Merriam-Webster doesn't seem to have anything for " word))
      (let ((temp-buf (get-buffer-create mw-learner-buffer-name)))
        ;; (print temp-buf)
        (when (not (bound-and-true-p mw-learner-mode))
          (pop-to-buffer temp-buf))
        (set-buffer temp-buf)
        (with-current-buffer temp-buf
          (read-only-mode -1)
          (setf (buffer-string) "")
          (setf org-hide-emphasis-markers t)
          (funcall 'org-mode)
          (funcall 'mw-learner-mode)
          (insert (decode-coding-string dict-str 'dos))
          (goto-char (point-min))
          (read-only-mode))))))

;;;###autoload
(defun wordnut-lookup-dwim ()
  "If a region is selected use `wordnut-search'
if a thing at point is not empty use `wordnut-lookup-current-word'
otherwise as for word using `wordnut-search'."
  (interactive)
  (let (beg end)
    (if (use-region-p)
        (progn
          (setq beg (region-beginning)
                end (region-end))
          (ignore-errors
            (wordnut--history-update-cur wordnut-hs))
          (wordnut--lookup (buffer-substring beg end))
          )
      (if (thing-at-point 'word)
          (wordnut-lookup-current-word)
        (progn
          (ignore-errors
            (wordnut--history-update-cur wordnut-hs))
          (wordnut--lookup (wordnut--completing nil))
          )))))
