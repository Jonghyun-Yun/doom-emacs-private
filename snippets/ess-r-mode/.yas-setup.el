;;; ../Dropbox/emacs/.doom.d/snippets/ess-r-mode/.yas-setup.el -*- lexical-binding: t; -*-

(defvar jyun/apply-commands
  '("apply" "lapply" "sapply" "mapply" "tapply" "vapply" "rapply"))

;;;###autoload
(defun jyun/choose-apply-command (aname)
  "TODO"
  (interactive (list (ido-completing-read "apply: " jyun/apply-commands)))
  (doom-snippets-expand :uuid aname))
(map! (:map ess-r-mode-map
       :g "C-c C-e a" #'jyun/choose-apply-command))

;; `(call-interactively #'jyun/choose-apply-command)`
;; `(yas--expand-or-visit-from-menu 'ess-r-mode (ido-completing-read "apply: " jyun/apply-commands))`
;;  ${1:$$(yas-choose-value jyun/apply-commands)}$0
