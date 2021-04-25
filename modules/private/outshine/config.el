;;; private/outshine/config.el -*- lexical-binding: t; -*-
;;; Outshine module config file from Spacemacs.
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Langston Barrett <langston.barrett@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defmacro spacemacs|hide-lighter (mode)
  "Diminish MODE name in mode line to LIGHTER."
  `(eval-after-load 'diminish '(diminish ',mode)))

(use-package outshine
  :defer t
  :init
  (progn
    (add-hook 'prog-mode-hook          'outline-minor-mode)
    (add-hook 'outline-minor-mode-hook 'outshine-mode))
  :config
  (progn
    (spacemacs|hide-lighter outline-minor-mode)
    (spacemacs|hide-lighter outshine-mode)
    (map! :leader
          (:when (featurep! :private outshine)
           (:prefix-map ("aO" . "out(line/org/shine)")
            "."  'outshine-hydra/body
            "S"  'outline-show-all
            "I"  'outshine-imenu
            "K"  'outline-move-subtree-up
            "J"  'outline-move-subtree-down
            ">"  'outline-demote
            "<"  'outline-promote
            (:prefix ("g" . "goto")
             "u" 'outline-up-heading
             "n" 'outline-next-heading
             "j" 'outline-forward-same-level
             "k" 'outline-backward-same-level))
           (:prefix ("aOi" . "insert")
            "h" 'outline-insert-heading)))
    (defhydra outshine-hydra (:hint nil)
      "
Navigate headings^^^^      Move subtrees^^^^               Other^^
─────────────────^^^^────  ─────────────^^^^─────────────  ─────^^─────────────
[_j_/_k_] down/up          [_J_/_K_] move subtree down/up  [_q_] quit
[_n_/_N_] next/up heading  [_>_/_<_] demote/promote        [_i_] insert heading
[_I_]^^   heading imenu"
      ("q" nil :exit t)
      ("i" outline-insert-heading :exit t)
      ("I" outshine-imenu :exit t)
      ;; Navigate headings
      ("n" outline-next-heading)
      ("N" outline-up-heading)
      ("j" outline-forward-same-level)
      ("k" outline-backward-same-level)
      ;; Move headings
      ("J" outline-move-subtree-down)
      ("K" outline-move-subtree-up)
      ;; Move headings
      (">" outline-demote)
      ("<" outline-promote))
    (map! (:map outshine-mode-map
           "<M-up>"    #'drag-stuff-up
           "<M-down>"  #'drag-stuff-down))
    ))

(use-package outorg
  :defer t
  :after outshine
  :config
  (map!
   :leader
   ;; "aOc"  'outorg-copy-edits-and-exit
   "aOe"  'outorg-edit-as-org))

;;; config.el ends here
