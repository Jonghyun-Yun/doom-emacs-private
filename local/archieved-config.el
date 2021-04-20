(use-package bm
  :defer t
  :commands
  (bm-buffer-restore)
  :init
  (progn
    ;; restore on load (even before you require bm)
    (setq bm-restore-repository-on-load t)
    ;; Allow cross-buffer 'next'
    (setq bm-cycle-all-buffers t)
    ;; save bookmarks
    (setq-default bm-buffer-persistence t)
    ;; where to store persistent files
    (setq bm-repository-file (format "%sbm-repository"
                                     doom-etc-dir))
    (setq bm-highlight-style 'bm-highlight-only-fringe
          bm-repository-size 500)
    ;; (evil-leader/set-key
    ;;   "atb" 'spacemacs/bm-transient-state/body)
    (advice-add 'my-hydra-bm/body
                :before #'bm-buffer-restore))
  (map!
   :leader
   :desc "Bookmark Hydra" "atb" #'my-hydra-bm/body)
  :config
  (progn
    ;; Saving bookmarks
    (add-hook 'kill-buffer-hook #'bm-buffer-save)
    ;; Saving the repository to file when on exit.
    ;; kill-buffer-hook is not called when Emacs is killed, so we
    ;; must save all bookmarks first.
    (add-hook 'kill-emacs-hook #'(lambda nil
                                   (bm-buffer-save-all)
                                   (bm-repository-save)))
    ;; Restoring bookmarks
    (add-hook 'find-file-hooks   #'bm-buffer-restore)
    ;; Make sure bookmarks is saved before check-in (and revert-buffer)
    (add-hook 'vc-before-checkin-hook #'bm-buffer-save)))
