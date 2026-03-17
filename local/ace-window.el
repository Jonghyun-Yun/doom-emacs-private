;;; ../Dropbox/emacs/.doom.d/local/ace-window.el -*- lexical-binding: t; -*-


;;;;  ace-window
(setq aw-scope 'global
      aw-dispatch-always t
      aw-keys avy-keys)
;; C-w C-w ? to aw-show-dispath-help
(setq aw-dispatch-alist
      '((?x aw-delete-window "Delete Window")
        (?w aw-swap-window "Swap Windows")
        ;; (?M aw-move-window "Move Window")
        (?c aw-copy-window "Copy Window")
        (?i aw-switch-buffer-in-window "Select Buffer")
        (?p aw-flip-window)
        (?b aw-switch-buffer-other-window "Switch Buffer Other Window")
        (?m aw-execute-command-other-window "Execute Command Other Window")
        (?f aw-split-window-fair "Split Fair Window")
        (?v aw-split-window-vert "Split Vert Window")
        (?h aw-split-window-horz "Split Horz Window")
        (?o delete-other-windows "Delete Other Windows")
        (?T aw-transpose-frame "Transpose Frame")
        (?? aw-show-dispatch-help)))

;;; ace-window + embark
;; https://karthinks.com/software/fifteen-ways-to-use-embark/
(eval-when-compile
  (defmacro kerthinks/embark-ace-action (fn)
    `(defun ,(intern (concat "kerthinks/embark-ace-" (symbol-name fn))) ()
       (interactive)
       (with-demoted-errors "%s"
         (require 'ace-window)
         (let ((aw-dispatch-always t))
           (aw-switch-to-window (aw-select nil))
           (call-interactively (symbol-function ',fn)))))))

(after! embark
  (define-key embark-file-map     (kbd "C-w") (kerthinks/embark-ace-action find-file))
  (define-key embark-buffer-map   (kbd "C-w") (kerthinks/embark-ace-action switch-to-buffer))
  (define-key embark-bookmark-map (kbd "C-w") (kerthinks/embark-ace-action bookmark-jump)))

;; https://localauthor.github.io/posts/aw-select.html
(map! (:map org-mode-map
       :leader "s C-l" #'link-hint-aw-select))
(defun link-hint-aw-select ()
  "Use avy to open a link in a window selected with ace-window."
  (interactive)
  (unless
      (avy-with link-hint-aw-select
        (link-hint--one :aw-select))
    (message "No visible links")))

(defun link-hint--aw-select-org-link (_link)
  (let ((org-link-frame-setup
         '((file . find-file))))
    (with-demoted-errors "%s"
      (if (and (> (length (aw-window-list)) 1)
               (not (member (org-element-property
                             :type (org-element-context))
                       '("http" "https"))))
          (let ((window (aw-select nil))
                (buffer (current-buffer))
                (new-buffer))
            (org-open-at-point)
            (setq new-buffer
                  (current-buffer))
            (switch-to-buffer buffer)
            (aw-switch-to-window window)
            (switch-to-buffer new-buffer))
        (link-hint-open-link-at-point)))))

(link-hint-define-type 'file-link
  :aw-select #'link-hint--aw-select-file-link)

(defmacro define-link-hint-aw-select (link-type fn)
  `(progn
     (link-hint-define-type ',link-type
       :aw-select #',(intern (concat "link-hint--aw-select-"
                                     (symbol-name link-type))))
     (defun ,(intern (concat "link-hint--aw-select-"
                             (symbol-name link-type))) (_link)
       (with-demoted-errors "%s"
         (if (> (length (aw-window-list)) 1)
             (let ((window (aw-select nil))
                   (buffer (current-buffer))
                   (new-buffer))
               (,fn)
               (setq new-buffer (current-buffer))
               (switch-to-buffer buffer)
               (aw-switch-to-window window)
               (switch-to-buffer new-buffer))
           (link-hint-open-link-at-point))))))

(define-link-hint-aw-select button push-button)
(define-link-hint-aw-select dired-filename dired-find-file)
(define-link-hint-aw-select org-link org-open-at-point)
(link-hint-define-type 'org-link :aw-select #'link-hint--aw-select-org-link)
