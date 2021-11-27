(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hl-todo-keyword-faces
   '(("TODO" . "#dc752f")
     ("NEXT" . "#dc752f")
     ("THEM" . "#2d9574")
     ("PROG" . "#4f97d7")
     ("OKAY" . "#4f97d7")
     ("DONT" . "#f2241f")
     ("FAIL" . "#f2241f")
     ("DONE" . "#86dc2f")
     ("NOTE" . "#b1951d")
     ("KLUDGE" . "#b1951d")
     ("HACK" . "#b1951d")
     ("TEMP" . "#b1951d")
     ("FIXME" . "#dc752f")
     ("XXX+" . "#dc752f")
     ("\\?\\?\\?+" . "#dc752f")))
 '(mathpix-app-id (password-store-get "mathpix/app-id") nil nil "Customized with use-package mathpix.el")
 '(mathpix-app-key (password-store-get "mathpix/app-key") nil nil "Customized with use-package mathpix.el")
 '(mathpix-screenshot-method "screencapture -i %s" nil nil "Customized with use-package mathpix.el")
 '(safe-local-variable-values
   '((overleaf-auto-sync . "ask")
     (org-preview-latex-default-process . dvisvgm)
     (org-preview-latex-default-process . dvipng)
     (TeX-engine . default)
     (org-babel-default-header-args:R
      (:session . "*R-COR*")
      (:export . "both")
      (:results . "output replace")
      (:width . 700)
      (:height . 700))
     (reftex-default-bibliography "/Users/yunj/Zotero/myref.bib")
     (flyspell-mode . -1)
     (org-babel-default-header-args:R
      (:session . "*R-Org*")
      (:export . "both")
      (:results . "output replace"))
     (TeX-engine . xetex))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:foreground "white" :background "red" :weight bold :height 2.5 :box (:line-width 10 :color "red")))))
 '(font-latex-sectioning-0-face ((t (:inherit 'outline-1))))
 '(font-latex-sectioning-1-face ((t (:inherit 'outline-2))))
 '(font-latex-sectioning-2-face ((t (:inherit 'outline-3))))
 '(font-latex-sectioning-3-face ((t (:inherit 'outline-4))))
 '(font-latex-sectioning-4-face ((t (:inherit 'outline-5))))
 '(font-latex-sectioning-5-face ((t (:inherit 'outline-6))))
 '(font-latex-sectioning-6-face ((t (:inherit 'outline-7))))
 '(font-latex-sectioning-7-face ((t (:inherit 'outline-8))))
 '(org-document-title ((t (:height 1.2))))
 '(outline-1 ((t (:weight semi-bold :height 1.25))))
 '(outline-2 ((t (:weight semi-bold :height 1.15))))
 '(outline-3 ((t (:weight semi-bold :height 1.12))))
 '(outline-4 ((t (:weight semi-bold :height 1.09))))
 '(outline-5 ((t (:weight semi-bold :height 1.06))))
 '(outline-6 ((t (:weight semi-bold :height 1.03))))
 '(outline-8 ((t (:weight semi-bold))))
 '(outline-9 ((t (:weight semi-bold)))))
(put 'narrow-to-region 'disabled nil)
