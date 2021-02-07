;;; lisp/hydra-plus.el -*- lexical-binding: t; -*-
;;;###if (featurep! :ui hydra)

;; (add-hook 'find-file-hook #'jethro/enable-smerge-maybe :append)
(defhydra my-hydra-smerge (
                           :hint nil
                           :pre (smerge-mode 1)
                           ;; Disable `smerge-mode' when quitting hydra if
                           ;; no merge conflicts remain.
                           :post (smerge-auto-leave))
  "
 Movement^^^^         Merge Action^^        Diff^^            Other
 ---------------^^^^  ------------------^^  --------------^^  ---------------------------^^
 [_n_]^^   next hunk  [_b_] keep base       [_<_] upper/base  [_C_] combine curr/next hunks
 [_N_/_p_] prev hunk  [_u_] keep upper      [_=_] upper/lower [_u_] undo
 [_j_]^^   next line  [_a_] keep all        [_>_] base/lower  [_q_] quit
 [_k_]^^   prev line  [_l_] keep lower      [_R_] refine      ^^
 ^^^^                 [_c_] keep current    [_E_] ediff       ^^
 ^^^^                 [_K_] kill current"
  ;; move
  ("n" smerge-next)
  ("N" smerge-prev)
  ("p" smerge-prev)
  ("j" evil-next-line)
  ("k" evil-previous-line)
  ;; merge action (mine = upper, other = lower)
  ("b" smerge-keep-base)
  ("u" smerge-keep-upper)
  ("a" smerge-keep-all)
  ("l" smerge-keep-lower)
  ("c" smerge-keep-current)
  ;; diff
  ("<" smerge-diff-base-upper)
  ("=" smerge-diff-upper-lower)
  (">" smerge-diff-base-lower)
  ("R" smerge-refine)
  ("E" smerge-ediff :exit t)
  ;; other
  ("C" smerge-combine-with-next)
  ("K" smerge-kill-current)
  ("u" undo-fu-only-undo)
  ("q" nil :exit t)
  ;; ("?" spacemacs//smerge-ts-toggle-hint)
  )

(use-package bm
  :defer t
  :commands
  (bm-buffer-restore)
  ;; (bm-buffer-save)
  ;; (bm-buffer-save-all)
  ;; (bm-repository-save)
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
    (setq bm-cycle-all-buffers t
          bm-highlight-style 'bm-highlight-only-fringe
          bm-repository-size 500)
    (defhydra my-hydra-bm
      (
       :hint nil
       )
      "
 Go to bookmark^^^^       Toggle^^                 Other^^
 ──────────────^^^^─────  ──────^^───────────────  ─────^^───
 [_n_/_N_] next/previous  [_t_] bookmark at point  [_q_] quit
^^^^                            ^^                 [_L_] List
"
      ("q" nil :exit t)
      ("L" bm-show-all :exit t)
      ;; Go to bookmark
      ("n" bm-next)
      ("N" bm-previous)
      ;; Toggle
      ("t" bm-toggle))
    ;; (evil-leader/set-key
    ;;   "atb" 'spacemacs/bm-transient-state/body)
    (advice-add 'my-hydra-bm/body
                :before #'bm-buffer-restore))
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

(defhydra my-hydra-org-babel
  (
   :hint nil
   )
  "
[_j_/_k_] navigate src blocks         [_e_] execute src block
[_g_]^^   goto named block            [_'_] edit src block
[_z_]^^   recenter screen             [_q_] quit"
  ("q" nil :exit t)
  ("j" org-babel-next-src-block)
  ("k" org-babel-previous-src-block)
  ("g" org-babel-goto-named-src-block)
  ("z" recenter-top-bottom)
  ("e" org-babel-execute-maybe)
  ("'" org-edit-special :exit t))

(defhydra my-hydra-timemachine
  (
   :hint nil
   :pre (let (golden-ratio-mode)
          (unless (bound-and-true-p git-timemachine-mode)
            (call-interactively 'git-timemachine)))
   :pose (when (bound-and-true-p git-timemachine-mode)
           (git-timemachine-quit))
   :foreign-keys run
   )
  "
[_p_/_N_] previous [_n_] next [_c_] current [_g_] goto nth rev [_Y_] copy hash [_q_] quit"
  ("c" git-timemachine-show-current-revision)
  ("g" git-timemachine-show-nth-revision)
  ("p" git-timemachine-show-previous-revision)
  ("n" git-timemachine-show-next-revision)
  ("N" git-timemachine-show-previous-revision)
  ("Y" git-timemachine-kill-revision)
  ("q" nil :exit t))

(defhydra my-hydra-fold
  (
   :hint nil
   :foreign-keys run
   )
  "
 Close^^          Open^^              Toggle^^             Other^^
 ───────^^──────  ─────^^───────────  ─────^^────────────  ─────^^───
 [_c_] at point   [_o_] at point      [_a_] around point   [_q_] quit
 ^^               [_O_] recursively   ^^
 [_m_] all        [_r_] all"
  ("a" evil-toggle-fold)
  ("c" evil-close-fold)
  ("o" evil-open-fold)
  ("O" evil-open-fold-rec)
  ("r" evil-open-folds)
  ("m" evil-close-folds)
  ("q" nil :exit t)
  ("C-g" nil :exit t)
  ("<SPC>" nil :exit t))

;; scrolling transient state
(defhydra my-hydra-scroll
  (
   :hint nil
   )
  "
 Line/Column^^^^      Half Page^^^^        Full Page^^ Buffer^^^^    Other
 ───────────^^^^───── ─────────^^^^─────── ─────────^^ ──────^^^^─── ─────^^───
 [_k_]^^   up         [_u_/_K_] up         [_b_] up    [_<_/_g_] beg [_q_] quit
 [_j_]^^   down       [_d_/_J_] down       [_f_] down  [_>_/_G_] end
 [_h_/_l_] left/right [_H_/_L_] left/right"
  ;; lines and columns
  ("j" evil-scroll-line-down)
  ("k" evil-scroll-line-up)
  ("h" evil-scroll-column-left)
  ("l" evil-scroll-column-right)
  ;; half page
  ("d" evil-scroll-down)
  ("u" evil-scroll-up)
  ("J" evil-scroll-down)
  ("K" evil-scroll-up)
  ("H" evil-scroll-left)
  ("L" evil-scroll-right)
  ;; full page
  ("f" evil-scroll-page-down)
  ("b" evil-scroll-page-up)
  ;; buffer
  ("<" evil-goto-first-line)
  (">" evil-goto-line)
  ("g" evil-goto-first-line)
  ("G" evil-goto-line)
  ;; other
  ("q" nil :exit t))
(map! :leader
      ;; lines and columns
      "Nj" 'my-hydra-scroll/evil-scroll-line-down
      "Nk" 'my-hydra-scroll/evil-scroll-line-up
      "Nh" 'my-hydra-scroll/evil-scroll-column-left
      "Nl" 'my-hydra-scroll/evil-scroll-column-right
      ;; half page
      "Nd" 'my-hydra-scroll/evil-scroll-down
      "Nu" 'my-hydra-scroll/evil-scroll-up
      "NJ" 'my-hydra-scroll/evil-scroll-down
      "NK" 'my-hydra-scroll/evil-scroll-up
      "NH" 'my-hydra-scroll/evil-scroll-left
      "NL" 'my-hydra-scroll/evil-scroll-right
      ;; full page
      "Nf" 'my-hydra-scroll/evil-scroll-page-down
      "Nb" 'my-hydra-scroll/evil-scroll-page-up
      ;; buffer
      "N<" 'my-hydra-scroll/evil-goto-first-line
      "N>" 'my-hydra-scroll/evil-goto-line
      "Ng" 'my-hydra-scroll/evil-goto-first-line
      "NG" 'my-hydra-scroll/evil-goto-line)

(defhydra my-hydra-window
  (:hint nil)
  "
 Select^^^^               Move^^^^              Split^^^^^^               Resize^^             Other^^
 ──────^^^^─────────────  ────^^^^────────────  ─────^^^^^^─────────────  ──────^^───────────  ─────^^──────────────────
 [_j_/_k_]  down/up       [_J_/_K_] down/up     [_s_]^^^^ horizontal      [_[_] shrink horiz   [_d_] close current
 [_h_/_l_]  left/right    [_H_/_L_] left/right  [_S_]^^^^ horiz & follow  [_]_] enlarge horiz  [_D_] close other
 [_0_.._9_] window 0..9   [_r_]^^   rotate fwd  [_v_]^^^^ vertical        [_{_] shrink verti   [_u_] restore prev layout
 [_a_]^^    ace-window    [_R_]^^   rotate bwd  [_V_]^^^^ verti & follow  [_}_] enlarge verti  [_U_] restore next layout
 [_o_]^^    other frame   ^^^^                  [_m_/_|_/___] maximize    [_g_] golden ratio   [_q_] quit
 [_w_]^^    other window"
  ;; Select
  ("j" evil-window-down)
  ("<down>" evil-window-down)
  ("k" evil-window-up)
  ("<up>" evil-window-up)
  ("h" evil-window-left)
  ("<left>" evil-window-left)
  ("l" evil-window-right)
  ("<right>" evil-window-right)
  ("0" winum-select-window-0)
  ("1" winum-select-window-1)
  ("2" winum-select-window-2)
  ("3" winum-select-window-3)
  ("4" winum-select-window-4)
  ("5" winum-select-window-5)
  ("6" winum-select-window-6)
  ("7" winum-select-window-7)
  ("8" winum-select-window-8)
  ("9" winum-select-window-9)
  ("a" ace-window)
  ("o" other-frame)
  ("w" other-window)
  ;; Move
  ("J" evil-window-move-very-bottom)
  ("<S-down>" evil-window-move-very-bottom)
  ("K" evil-window-move-very-top)
  ("<S-up>" evil-window-move-very-top)
  ("H" evil-window-move-far-left)
  ("<S-left>" evil-window-move-far-left)
  ("L" evil-window-move-far-right)
  ("<S-right>" evil-window-move-far-right)
  ("r" evil-window-rotate-downwards)
  ("R" evil-window-rotate-upwards)
  ;; Split
  ("s" split-window-below)
  ("S" split-window-below-and-focus)
  ("-" split-window-below-and-focus)
  ("v" split-window-right)
  ("V" split-window-right-and-focus)
  ("/" split-window-right-and-focus)
  ("m" doom/window-maximize-buffer)
  ("|" doom/window-maximize-vertically)
  ("_" doom/window-maximize-horizontally)
  ;; Resize
  ("[" shrink-window-horizontally)
  ("]" enlarge-window-horizontally)
  ("{" shrink-window)
  ("}" enlarge-window)
  ("g" golden-ratio)
  ;; Other
  ("d" delete-window)
  ("D" delete-other-windows)
  ("u" winner-undo)
  ("U" winner-redo)
  ("q" nil :exit t))
(map! :leader
      :desc "Window Hydra" "w." #'my-hydra-window/body
      "w[" #'my-hydra-window/shrink-window-horizontally
      "w]" #'my-hydra-window/enlarge-window-horizontally
      "w{" #'my-hydra-window/shrink-window
      "w}" #'my-hydra-window/enlarge-window)

(use-package string-inflection
  :init
  (progn
    (defhydra my-hydra-string-inflection
      (:hint nil)
      "
[_i_] cycle"
      ("i" string_inflection_all_cycle)
      )
    (map!
     :leader
     (:prefix ("zi" . "inflection")
      "c" 'string-inflection-lower-camelcase
      "C" 'string-inflection-camelcase
      :desc "String Inflection Hydra" "i" 'my-hydra-string-inflection/body
      "-" 'string-inflection-kebab-case
      "k" 'string-inflection-kebab-case
      "_" 'string-inflection-underscore
      "u" 'string-inflection-underscore
      "U" 'string-inflection-upcase))))

;; (defhydra my-mc-hydra (
;;                        :hint nil
;;                        :pre (evil-mc-pause-cursors))
;;   "
;; ^Match^            ^Line-wise^           ^Manual^
;; ^^^^^^----------------------------------------------------
;; _Z_: match all              _J_: make & go down   _z_: toggle here
;; _d_/_D_: make & next/prev   _K_: make & go up     _u_: remove last
;; _M_: make & prev            ^ ^                   _R_: remove all
;; _n_: skip & next            ^ ^                   _t_: pause/resume
;; _N_: skip & prev

;; Current pattern: %`evil-mc-pattern
;; "
;;   ("Z" #'evil-mc-make-all-cursors)
;;   ("m" #'evil-mc-make-and-goto-next-match)
;;   ("M" #'evil-mc-make-and-goto-prev-match)
;;   ("n" #'evil-mc-skip-andtgoto-next-match)
;;   ("N" #'evil-mc-skip-andtgoto-prev-match)
;;   ("J" #'evil-mc-make-curtor-move-next-line)
;;   ("K" #'evil-mc-make-cursor-move-prev-line)
;;   ("z" #'+multiple-cursors/evil-mc-toggle-cursor-here)
;;   ("u" #'+multiple-cursors/evil-mc-undo-cursor)
;;   ("R" #'evil-mc-undo-all-cursors)
;;   ("t" #'+multiple-cursors/evil-mc-toggle-cursors)
;;   ("q" #'evil-mc-resume-cursors "quit" :color blue)
;;   ("<escape>" nil :exit t))

;; g z D           evil-mc-make-and-goto-prev-match
;; g z N           evil-mc-make-and-goto-last-cursor
;; g z P           evil-mc-make-and-goto-first-cursor
;; g z d           evil-mc-make-and-goto-next-match
;; g z j           evil-mc-make-cursor-move-next-line
;; g z k           evil-mc-make-cursor-move-prev-line
;; g z m           evil-mc-make-all-cursors
;; g z n           evil-mc-make-and-goto-next-cursor
;; g z p           evil-mc-make-and-goto-prev-cursor
;; g z q           evil-mc-undo-all-cursors
;; g z t           +multiple-cursors/evil-mc-toggle-cursors
;; g z u           +multiple-cursors/evil-mc-undo-cursor
;; g z z           +multiple-cursors/evil-mc-toggle-cursor-here

;; (map!
;;  (:when (featurep! :editor multiple-cursors)
;;   :prefix "g"
;;   :nv "z." #'my-mc-hydra/body))

;;;###autoload
(defun +workspace/rename (new-name)
  "Rename the current workspace."
  (interactive (list (read-from-minibuffer "New workspace name: ")))
  (condition-case-unless-debug ex
      (let* ((current-name (+workspace-current-name))
             (old-name (+workspace-rename current-name new-name)))
        (unless old-name
          (error "Failed to rename %s" current-name))
        (+workspace-message (format "Renamed '%s'->'%s'" old-name new-name) 'success))
    ('error (+workspace-error ex t))))

;;;###autoload
(defun +workspace/new (&optional name clone-p)
  "Create a new workspace named NAME. If CLONE-P is non-nil, clone the current
workspace, otherwise the new workspace is blank."
  (interactive (list nil current-prefix-arg))
  (unless name
    (setq name (format "#%s" (+workspace--generate-id))))
  (condition-case e
      (cond ((+workspace-exists-p name)
             (error "%s already exists" name))
            (clone-p (persp-copy name t))
            (t
             (+workspace-switch name t)
             (+workspace/display)))
    ((debug error) (+workspace-error (cadr e) t))))

(defhydra my-hydra-org-agenda
  (
   :hint nil
   :pre (setq which-key-inhibit t)
   :post (setq which-key-inhibit nil)
   :foreign-keys run
   )
  "
Headline^^            Visit entry^^               Filter^^                    Date^^                  Toggle mode^^        View^^             Clock^^        Other^^
--------^^---------   -----------^^------------   ------^^-----------------   ----^^-------------     -----------^^------  ----^^---------    -----^^------  -----^^-----------
_ht_: set status      _SPC_: in other window      _st_: by tag                _cs_: schedule          _zf_: follow         _zd_: day          _cI_: in       _gr_: reload
_dd_: kill            _TAB_: & go to location     _ss_: limit                 _cS_: un-schedule       _zl_: log            _zw_: week         _cO_: out      _._:  go to today
_hr_: refile          _RET_: & del other windows  _sc_: by category           _cd_: set deadline      _zA_: archive        _zt_: fortnight    _cc_: cancel   _gd_: go to date
_dA_: archive         _o_:   link                 _sh_: by top headline       _cD_: remove deadline   _cr_: clock report   _zm_: month        _cg_: jump     ^^
_ct_: set tags        ^^                          _sr_: by regexp             _p_:  timestamp         _cs_: clock issues   _zy_: year         ^^             ^^
_hp_: set priority    ^^                          _S_:  delete all filters    _L_:  do later          _zD_: diaries        _[_/_]_: prev/next ^^             _q_: quit
^^                    ^^                          ^^                          _H_:  do earlier        ^^                   _zr_: reset        ^^             ^^
"
  ;; Entry
  ("ht" org-agenda-todo)
  ("dd" org-agenda-kill)
  ("hr" org-agenda-refile)
  ("dA" org-agenda-archive-default)
  ("ct" org-agenda-set-tags)
  ("hp" org-agenda-priority)
  ;; Visit entry
  ("SPC" org-agenda-show-and-scroll-up)
  ("<tab>" org-agenda-goto :exit t)
  ("TAB" org-agenda-goto :exit t)
  ("RET" org-agenda-switch-to :exit t)
  ("o"   link-hint-open-link :exit t)
  ("j" org-agenda-next-item)
  ("k" org-agenda-prev-item)
  ;; Filter
  ("sc" org-agenda-filter-by-category)
  ("S" org-agenda-filter-remove-all)
  ("sh" org-agenda-filter-by-top-headline)
  ("ss" org-agenda-limit-interactively)
  ("st" org-agenda-filter-by-tag)
  ("sr" org-agenda-filter-by-regexp)
  ;; Date
  ("cd" org-agenda-deadline)
  ("cD" (lambda () (interactive)
          (let ((current-prefix-arg '(4)))
            (call-interactively 'org-agenda-deadline))))
  ("cs" org-agenda-schedule)
  ("cS" (lambda () (interactive)
          (let ((current-prefix-arg '(4)))
            (call-interactively 'org-agenda-schedule))))
  ("p" org-agenda-date-prompt)
  ("L" org-agenda-do-date-later)
  ("H" org-agenda-do-date-earlier)
  ;; View
  ("zd" org-agenda-day-view)
  ("zm" org-agenda-month-view)
  ("zt" org-agenda-fortnight-view)
  ("zw" org-agenda-week-view)
  ("zy" org-agenda-year-view)
  ("zr" org-agenda-reset-view)
  ("]" org-agenda-later)
  ("[" org-agenda-earlier)
  ;; Clock
  ("cI" org-agenda-clock-in :exit t)
  ("cg" org-agenda-clock-goto :exit t)
  ("cO" org-agenda-clock-out)
  ("cc" org-agenda-clock-cancel)
  ;; Toggle mode
  ("zA" org-agenda-archives-mode)
  ("zD" org-agenda-toggle-diary)
  ("zf" org-agenda-follow-mode)
  ("ci" org-agenda-show-clocking-issues)
  ("zl" org-agenda-log-mode)
  ("cr" org-agenda-clockreport-mode)
  ;; Other
  ("q" nil :exit t)
  ("gr" org-agenda-redo)
  ("." org-agenda-goto-today)
  ("gd" org-agenda-goto-date))

(defhydra my-hydra-pdf-tools
  (:hint nil
   :pre (setq which-key-inhibit t)
   :post (setq which-key-inhibit nil)
   )
  "
 Navigation^^^^                Scale/Fit^^                    Annotations^^       Actions^^           Other^^
 ----------^^^^--------------- ---------^^------------------  -----------^^------ -------^^---------- -----^^---
 [_j_/_k_] scroll down/up      [_W_] fit to width             [_al_] list         [_s_] search         [_q_] quit
 [_h_/_l_] scroll left/right   [_H_] fit to height            [_at_] text         [_o_] outline
 [_d_/_u_] pg down/up          [_P_] fit to page              [_aD_] delete       [_p_] print
 [_J_/_K_] next/prev pg        [_m_] slice using mouse        [_am_] markup       [_F_] open link
 [_0_/_$_] full scroll l/r     [_b_] slice from bounding box  ^^                  [_r_] revert
 [_[_/_]_] history back/for    [_R_] reset slice              ^^                  [_t_] attachments
 ^^^^                          [_z0_] reset zoom              ^^                  [_n_] night mode"
  ;; Navigation
  ("j"  pdf-view-next-line-or-next-page)
  ("k"  pdf-view-previous-line-or-previous-page)
  ("l"  image-forward-hscroll)
  ("h"  image-backward-hscroll)
  ("J"  pdf-view-next-page)
  ("K"  pdf-view-previous-page)
  ("u"  pdf-view-scroll-down-or-previous-page)
  ("d"  pdf-view-scroll-up-or-next-page)
  ("0"  image-bol)
  ("$"  image-eol)
  ("["  pdf-history-backward)
  ("]"  pdf-history-forward)
  ;; Scale/Fit
  ("W"  pdf-view-fit-width-to-window)
  ("H"  pdf-view-fit-height-to-window)
  ("P"  pdf-view-fit-page-to-window)
  ("m"  pdf-view-set-slice-using-mouse)
  ("b"  pdf-view-set-slice-from-bounding-box)
  ("R"  pdf-view-reset-slice)
  ("z0" pdf-view-scale-reset)
  ;; Annotations
  ("al" pdf-annot-list-annotations :exit t)
  ("at" pdf-annot-add-text-annotation)
  ("aD" pdf-annot-delete)
  ("am" pdf-annot-add-markup-annotation)
  ;; Actions
  ("s" pdf-occur :exit t)
  ("o" pdf-outline :exit t)
  ("p" pdf-misc-print-document :exit t)
  ("F" pdf-links-action-perform :exit t)
  ("r" pdf-view-revert-buffer)
  ("t" pdf-annot-attachment-dired :exit t)
  ("n" pdf-view-midnight-minor-mode)
  ;; Other
  ("q" nil :exit t))

;; VCS Hydra
(defhydra my-hydra-vcs
  (:hint nil
   ;; :pre (git-gutter-mode 1)
   )
 "
 Hunk Commands^^^^^^                 Magit Commands^^^^^^                             Others
----------------------------^^^^^^  ------------------------------------------^^^^^^  ------------^^
 [_n_]^^^^      next hunk            [_w_/_u_]^^    stage/unstage in current file     [_z_] recenter
 [_N_/_p_]^^    previous hunk        [_c_/_C_]^^    commit with popup/direct commit   [_q_] quit
 [_r_/_s_/_h_]  revert/stage/show    [_f_/_F_/_P_]  fetch/pull/push popup
 [_t_]^^^^      toggle diff signs    [_l_/_D_]^^    log/diff popup"
  ("C" magit-commit :exit t)
  ("d" magit-ediff :exit t)
  ("D" magit-diff-unstaged :exit t)
  ("F" magit-pull :exit t)
  ("P" magit-push :exit t)
  ("c" magit-commit :exit t)
  ("f" magit-fetch :exit t)
  ("l" magit-log :exit t)
  ("u" magit-unstage-file)
  ("w" magit-stage-file)
  ("n" git-gutter:next-hunk)
  ("N" git-gutter:previous-hunk)
  ("p" git-gutter:previous-hunk)
  ("r" git-gutter:revert-hunk)
  ("s" git-gutter:stage-hunk)
  ("h" git-gutter:show-hunk)
  ("t" git-gutter-mode)
  ("z" recenter-top-bottom)
  ("q" nil :exit t))
