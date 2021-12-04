;;; private/ebook/config.el -*- lexical-binding: t; -*-

;;; calibre
(use-package! calibredb
  :commands calibredb
  :config
  (setq calibredb-root-dir "~/Documents/Calibre/"
        calibredb-db-dir (expand-file-name "metadata.db" calibredb-root-dir))
  :init
  (map! (:map calibredb-show-mode-map
         :ne "?" #'calibredb-entry-dispatch
         :ne "o" #'calibredb-find-file
         :ne "O" #'calibredb-find-file-other-frame
         :ne "V" #'calibredb-open-file-with-default-tool
         :ne "s" #'calibredb-set-metadata-dispatch
         :ne "e" #'calibredb-export-dispatch
         :ne "q" #'calibredb-entry-quit
         :ne "." #'calibredb-open-dired
         :ne [tab] #'calibredb-toggle-view-at-point
         :ne "M-t" #'calibredb-set-metadata--tags
         :ne "M-a" #'calibredb-set-metadata--author_sort
         :ne "M-A" #'calibredb-set-metadata--authors
         :ne "M-T" #'calibredb-set-metadata--title
         :ne "M-c" #'calibredb-set-metadata--comments)
        (:map calibredb-search-mode-map
         :ne [mouse-3] #'calibredb-search-mouse
         :ne "RET" #'calibredb-find-file
         :ne "?" #'calibredb-dispatch
         :ne "a" #'calibredb-add
         :ne "A" #'calibredb-add-dir
         :ne "c" #'calibredb-clone
         :ne "d" #'calibredb-remove
         :ne "D" #'calibredb-remove-marked-items
         :ne "j" #'calibredb-next-entry
         :ne "k" #'calibredb-previous-entry
         :ne "l" #'calibredb-virtual-library-list
         :ne "L" #'calibredb-library-list
         :ne "n" #'calibredb-virtual-library-next
         :ne "N" #'calibredb-library-next
         :ne "p" #'calibredb-virtual-library-previous
         :ne "P" #'calibredb-library-previous
         :ne "s" #'calibredb-set-metadata-dispatch
         :ne "S" #'calibredb-switch-library
         :ne "o" #'calibredb-find-file
         :ne "O" #'calibredb-find-file-other-frame
         :ne "v" #'calibredb-view
         :ne "V" #'calibredb-open-file-with-default-tool
         :ne "." #'calibredb-open-dired
         :ne "b" #'calibredb-catalog-bib-dispatch
         :ne "e" #'calibredb-export-dispatch
         :ne "r" #'calibredb-search-refresh-and-clear-filter
         :ne "R" #'calibredb-search-clear-filter
         :ne "q" #'calibredb-search-quit
         :ne "m" #'calibredb-mark-and-forward
         :ne "f" #'calibredb-toggle-favorite-at-point
         :ne "x" #'calibredb-toggle-archive-at-point
         :ne "h" #'calibredb-toggle-highlight-at-point
         :ne "u" #'calibredb-unmark-and-forward
         :ne "i" #'calibredb-edit-annotation
         :ne "DEL" #'calibredb-unmark-and-backward
         :ne [backtab] #'calibredb-toggle-view
         :ne [tab] #'calibredb-toggle-view-at-point
         :ne "M-n" #'calibredb-show-next-entry
         :ne "M-p" #'calibredb-show-previous-entry
         :ne "/" #'calibredb-search-live-filter
         :ne "M-t" #'calibredb-set-metadata--tags
         :ne "M-a" #'calibredb-set-metadata--author_sort
         :ne "M-A" #'calibredb-set-metadata--authors
         :ne "M-T" #'calibredb-set-metadata--title
         :ne "M-c")))

;;; nov
(use-package! nov
  :defer t
  :mode ("\\.epub\\'" . nov-mode)
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
  (map!
   (:map nov-mode-map
   :n "H" #'nov-previous-document
   :n "L" #'nov-next-document
   :n "[" #'nov-previous-document
   :n "]" #'nov-next-document
   :n "d" #'nov-scroll-up
   :n "u" #'nov-scroll-down
   :n "J" #'nov-scroll-up
   :n "K" #'nov-scroll-down
   :n "gm" #'nov-display-metadata
   :n "gr" #'nov-render-document
   :n "gt" #'nov-goto-toc
   :n "gv" #'nov-view-source
   :n "gV" #'nov-view-content-source))
  ;; (map! :map nov-mode-map
  ;;       :n "RET" #'nov-scroll-up)

  (defun doom-modeline-segment--nov-info ()
    (concat
     " "
     (propertize
      (cdr (assoc 'creator nov-metadata))
      'face 'doom-modeline-project-parent-dir)
     " "
     (cdr (assoc 'title nov-metadata))
     " "
     (propertize
      (format "%d/%d"
              (1+ nov-documents-index)
              (length nov-documents))
      'face 'doom-modeline-info)))

  (advice-add 'nov-render-title :override #'ignore)

  (defun +nov-mode-setup ()
    (face-remap-add-relative 'variable-pitch
                             :family "Merriweather"
                             :height 1.4
                             :width 'semi-expanded)
    (face-remap-add-relative 'default :height 1.3)
    (setq-local line-spacing 0.2
                next-screen-context-lines 4
                shr-use-colors nil)
    (require 'visual-fill-column nil t)
    (setq-local visual-fill-column-center-text t
                visual-fill-column-width 83
                nov-text-width 80)
    (visual-fill-column-mode 1)
    (hl-line-mode -1)

    (add-to-list '+lookup-definition-functions #'+lookup/dictionary-definition)

    (setq-local mode-line-format
                `((:eval
                   (doom-modeline-segment--workspace-name))
                  (:eval
                   (doom-modeline-segment--window-number))
                  (:eval
                   (doom-modeline-segment--nov-info))
                  ,(propertize
                    " %P "
                    'face 'doom-modeline-buffer-minor-mode)
                  ,(propertize
                    " "
                    'face (if (doom-modeline--active) 'mode-line 'mode-line-inactive)
                    'display `((space
                                :align-to
                                (- (+ right right-fringe right-margin)
                                   ,(* (let ((width (doom-modeline--font-width)))
                                         (or (and (= width 1) 1)
                                             (/ width (frame-char-width) 1.0)))
                                       (string-width
                                        (format-mode-line (cons "" '(:eval (doom-modeline-segment--major-mode))))))))))
                                    (:eval (doom-modeline-segment--major-mode))))
    )
  (add-hook 'nov-mode-hook #'+nov-mode-setup))

;;; nov
;; (use-package! nov
;;   :defer t
;;   :mode ("\\.epub\\'" . nov-mode)
;;   :config
;;   (map!
;;    :map nov-mode-map
;;    :nvime "H" #'nov-previous-document
;;    :nvime "L" #'nov-next-document
;;    :nvime "[" #'nov-previous-document
;;    :nvime "]" #'nov-next-document
;;    :nvime "d" #'nov-scroll-up
;;    :nvime "u" #'nov-scroll-down
;;    :nvime "J" #'nov-scroll-up
;;    :nvime "K" #'nov-scroll-down
;;    :nvime "gm" #'nov-display-metadata
;;    :nvime "gr" #'nov-render-document
;;    :nvime "gt" #'nov-goto-toc
;;    :nvime "gv" #'nov-view-source
;;    :nvime "gV" #'nov-view-content-source)
;;   (defun +nov-mode-setup ()
;;     (face-remap-add-relative 'variable-pitch
;;                              :family "Merriweather"
;;                              :height 1.4
;;                              :width 'semi-expanded)
;;     (face-remap-add-relative 'default :height 1.3)
;;     (setq-local line-spacing 0.2
;;                 next-screen-context-lines 4
;;                 shr-use-colors nil)
;;     (require 'visual-fill-column nil t)
;;     (setq-local visual-fill-column-center-text t
;;                 visual-fill-column-width 83
;;                 nov-text-width 80)
;;     (visual-fill-column-mode 1)
;;     (hl-line-mode -1)
;;     )
;;   (add-hook 'nov-mode-hook #'+nov-mode-setup)
;;   )

;; ;; epub osx dictionary
;; (defun my-nov-mode-map ()
;;   (define-key nov-mode-map "s" 'osx-dictionary-search-pointer)
;;   t)
;; (add-hook 'nov-mode-hook 'my-nov-mode-map)
