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
(defun langtool-autoshow-force-message (overlays)
  ;; Interrupt current message
  (let ((msg (langtool-simple-error-message overlays)))
    (message "%s" msg)))

;;;###autoload
(defun langtool-autoshow-detail-popup (overlays)
  (when (require 'popup nil t)
    ;; Do not interrupt current popup
    (unless (or popup-instances
                ;; suppress popup after type `C-g` .
                (memq last-command '(keyboard-quit)))
      (let ((msg (langtool-details-error-message overlays)))
        (popup-tip msg)))))

;; ;;;###autoload
;; (defun jyun/langtool-org-exclude-faces ()
;; "  "This function should be run with `emacs-langtool' brance (or pull request) enabling `langtool-generic-check-predicate'. Remove errors for some org-mode faces".
;;     (setq langtool-generic-check-predicate
;;           '(lambda (start end)
;;              ;; set up for `org-mode'
;;              (let* ((begin-regexp "^[ \t]*#\\+begin_\\(src\\|html\\|latex\\|example\\|quote\\)")
;;                     (end-regexp "^[ \t]*#\\+end_\\(src\\|html\\|latex\\|example\\|quote\\)")
;;                     (case-fold-search t)
;;                     (ignored-font-faces '(org-verbatim
;;                                           org-block-begin-line
;;                                           org-meta-line
;;                                           org-tag
;;                                           org-link
;;                                           org-level-1
;;                                           org-document-info
;;                                           ;; the below added by me
;;                                           org-list-dt
;;                                           org-block
;;                                           org-block-begin-line
;;                                           org-block-end-line
;;                                           org-code
;;                                           org-date
;;                                           org-formula
;;                                           org-latex-and-related
;;                                           org-link
;;                                           org-meta-line
;;                                           org-property-value
;;                                           org-ref-cite-face
;;                                           org-special-keyword
;;                                           org-tag
;;                                           org-todo
;;                                           org-todo-keyword-done
;;                                           org-todo-keyword-habt
;;                                           org-todo-keyword-kill
;;                                           org-todo-keyword-outd
;;                                           org-todo-keyword-todo
;;                                           org-todo-keyword-wait
;;                                           org-verbatim
;;                                           org-property-drawer-re
;;                                           org-ref-cite-re
;;                                           org-ref-ref-re
;;                                           org-ref-label-re
;;                                           org-latex-math-environments-re
;;                                           "\\`[ 	]*\\\\begin{\\(?:align*\\|equation*\\|eqnarray*\\)\\*?}"
;;                                           font-lock-comment-face
;;                                           ))
;;                     (rlt t)
;;                     ff
;;                     th
;;                     b e)
;;                (save-excursion
;;                  (goto-char start)
;;                  ;; get current font face
;;                  (setq ff (get-text-property start 'face))
;;                  (if (listp ff) (setq ff (car ff)))
;;                  ;; ignore certain errors by set rlt to nil
;;                  (cond
;;                   ((memq ff ignored-font-faces)
;;                    ;; check current font face
;;                    (setq rlt nil))
;;                   ((string-match "^ *- $" (buffer-substring (line-beginning-position) (+ start 2)))
;;                    ;; dash character of " - list item 1"
;;                    (setq rlt nil))
;;                   ((and (setq th (thing-at-point 'evil-WORD))
;;                         (or (string-match "^=[^=]*=[,.]?$" th)
;;                             (string-match "^\\[\\[" th)))
;;                    ;; embedded cde like =w3m= or org-link [[http://google.com][google]] or [[www.google.com]]
;;                    ;; langtool could finish checking before major mode prepare font face for all texts
;;                    (setq rlt nil))
;;                   (t
;;                    ;; inside source block?
;;                    (setq b (re-search-backward begin-regexp nil t))
;;                    (if b (setq e (re-search-forward end-regexp nil t)))
;;                    (if (and b e (< start e)) (setq rlt nil)))))
;;                ;; (if rlt (message "start=%s end=%s ff=%s" start end ff))
;;                rlt))))

;; ;;;###autoload
;; (defun jyun/langtool-latex-exclude-faces ()
;;   "This function should be run with `emacs-langtool' brance (or pull request) enabling `langtool-generic-check-predicate'. Intended to remove errors for some latex fonts. not working."
;;   (setq langtool-generic-check-predicate
;;         ;; set up for `LaTeX-mode'
;;         '(lambda (start end)
;;            (let* (
;;                   (ignored-font-faces '(
;;                                         font-lock-function-name-face
;;                                         font-lock-variable-name-face
;;                                         font-lock-keyword-face
;;                                         font-lock-constant-face
;;                                         font-lock-comment-face
;;                                         font-latex-math-face
;;                                         font-latex-sedate-face
;;                                         ))
;;                   (f (get-text-property start 'face)))
;;              (not (memq f ignored-font-faces))))))
