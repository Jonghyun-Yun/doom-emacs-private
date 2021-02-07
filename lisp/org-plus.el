;;; org-plus.el --- description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2020 Jonghyun Yun
;;
;; Author: Jonghyun Yun <http://github/yunj>
;; Maintainer: Jonghyun Yun <jonghyun.yun@gmail.com>
;; Created: June 08, 2020
;; Modified: June 08, 2020
;; Version: 0.0.1
;; Keywords:
;; Homepage: https://github.com/yunj/org-plus
;; Package-Requires: ((emacs 27.0.91) (cl-lib "0.5"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  description
;;
;;; Code:

(use-package org-cv
  :load-path "~/Dropbox/emacs/packages/org-cv"
  :after ox
  :init
  ;; (require 'ox-moderncv)
  (require 'ox-altacv)
  ;; (require 'ox-hugocv)
  :defer t
  )

(use-package ox-ravel
  :load-path "~/.doom.d/packages/ox-ravel"
  :after ox
  :config
  (require 'ob-R)
  (setq org-ravel-engines
        '(("R" . "engine='R'")
          ("c" . "engine='c'")
          ("c++" . "engine='Rcpp'")
          ("C" . "engine='c'")
          ("C++" . "engine='Rcpp'"))
        )
  )

;; (use-package ox-hugo
;;   :load-path "~/.doom.d/packages/ox-hugo"
;;   :after org
;;   )

(with-eval-after-load 'org-protocol
  (defun my-org-protocol-focus-advice (orig &rest args)
    (x-focus-frame nil)
    (apply orig args))
  (advice-add 'org-roam-protocol-open-ref :around
              #'my-org-protocol-focus-advice)
  (advice-add 'org-roam-protocol-open-file :around
              #'my-org-protocol-focus-advice)
  (advice-add 'org-protocol-capture :around
              #'my-org-protocol-focus-advice)
)

;; inderting <kbd> tags interactively
(eval-after-load 'ox-html
  ;; If you prefer to use ~ for <code> tags. Replace "code" with
  ;; "verbatim" here, and replace "~" with "=" below.
  '(push '(code . "<kbd>%s</kbd>") org-html-text-markup-alist))

;; KOMA-SCript letter
(eval-after-load 'ox '(require 'ox-koma-letter))

(with-eval-after-load 'ox-latex
  ;; code highlight
  (setq org-latex-listings 'minted)
  (setq org-latex-minted-options
        '(("frame" "lines")
          ("linenos" "true")))

  (eval-after-load 'ox-koma-letter
    '(progn
       (add-to-list 'org-latex-classes
                    '("my-koma-letter"
                      "\\documentclass\{scrlttr2\}
\[NO-DEFAULT-PACKAGES]
\[PACKAGES]
\[EXTRA]"))

       (setq org-koma-letter-default-class "my-koma-letter")))

  ;; highlight lco file
  (add-to-list 'auto-mode-alist '("\\.lco" . LaTeX-mode))

  ;; ;; https://orgmode.org/manual/LaTeX-specific-export-settings.html
  ;; (add-to-list 'org-latex-packages-alist
  ;;              '("AUTO" "babel" t ("pdflatex")))
  ;; (add-to-list 'org-latex-packages-alist
  ;;              '("AUTO" "polyglossia" t ("xelatex" "lualatex")))

  ;; Bare-bones template
  (add-to-list 'org-latex-classes
               '("no-article"
                 "\\documentclass{article}
 [NO-DEFAULT-PACKAGES]
 [PACKAGES]
 [EXTRA]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  ;; org-export: Remove additional latex temporary files.
  (setq org-latex-logfiles-extensions
        (append '("dvi" "bbl") org-latex-logfiles-extensions))
  )

(eval-after-load 'ox-html
  (setq org-html-table-row-close-tag "</tr align=\"right\">"
        ;; org-html-htmlize-output-type 'css
        )
  )

  ;; Org capture templates
  (with-eval-after-load 'org-capture
    ;; sheduleing
    (setq org-capture-templates
          '(
            ("r" "Reminder" entry
             (file+headline "~/org/tickler.org" "Reminders")
             "* [ ] %^{Reminder for...} \nSCHEDULED: %^t \n:PROPERTIES: \n:CREATED: %U \n:LINK: %a \n:END: \n%i \n%?"
             :prepend t
             )
             ("a" "Attach as sub-heading" entry
             (file+function buffer-name org-back-to-heading)
             "* %?\n :PROPERTIES: \n:CREATED: %U \n:END: \n%i \n")
            ("t" "Templates for todos")
            ("tt" "Todo" entry
             (file+headline "~/org/inbox.org" "Tasks")
             "* [ ] %^{Todo for...} \n:PROPERTIES: \n:CAPTURED: %U \n:LINK: %a \n:END: \n%i \n%?"
             :prepend t
             )
            ("td" "Todo deadline" entry
             (file+headline "~/org/inbox.org" "Task Deadlines")
             "* [ ] %^{Deadline for...} \nDEADLINE: %^t \n:PROPERTIES: \n:LINK: %a \n:END: \n%i \n%?"
             :prepend t
             )
             ("tr" "Rapid task" entry
             (file+headline "~/org/inbox.org" "Rapid Tasks")
             "* [ ] %^{Rapid task for...} \nDEADLINE: %(org-insert-time-stamp (org-read-date nil t \"+1d\")) \n%i \n%a \n%?"
             :prepend t
             )
             ("n" "Note" entry
             (file+headline +org-capture-notes-file "Inbox")
             "* %u %^{Note for...} \n:PROPERTIES: \n:LINK: %a \n:END: \n%i \n%?"
             :prepend t
             )
             ("j" "Journal" entry
             (file+olp+datetree +org-capture-journal-file)
             "* %U %^{Journal for...} \n:PROPERTIES: \n:LINK: %a \n:END: \n%i \n%?"
             :prepend t
             )
            ;; ;; Will use {project-root}/{todo,notes,changelog}.org, unless a
            ;; ;; {todo,notes,changelog}.org file is found in a parent directory.
            ;; ;; Uses the basename from `+org-capture-todo-file',
            ;; ;; `+org-capture-changelog-file' and `+org-capture-notes-file'.
            ;; ("p" "Templates for projects")
            ;; ("pt" "Project-local todo" entry  ; {project-root}/todo.org
            ;;  (file+headline +org-capture-project-todo-file "Inbox")
            ;;  "* TODO %?\n%i\n%a" :prepend t)
            ;; ("pn" "Project-local notes" entry  ; {project-root}/notes.org
            ;;  (file+headline +org-capture-project-notes-file "Inbox")
            ;;  "* %U %?\n%i\n%a" :prepend t)
            ;; ("pc" "Project-local changelog" entry  ; {project-root}/changelog.org"
            ;;  (file+headline +org-capture-project-changelog-file "Unreleased")
            ;;  "* %U %?\n%i\n%a" :prepend t)

            ;; Will use {org-directory}/{+org-capture-projects-file} and store
            ;; these under {ProjectName}/{Tasks,Notes,Changelog} headings. They
            ;; support `:parents' to specify what headings to put them under, e.g.
            ;; :parents ("Projects")
            ("o" "Centralized templates for projects")
            ("ot" "Project todo" entry
             (function +org-capture-central-project-todo-file)
             "* TODO %^{Todo for...} \n:PROPERTIES: \n:CAPTURED: %U \n:LINK: %a \n:END: \n%i \n%?"
             :heading "Tasks"
             :prepend nil)
            ("on" "Project notes" entry
             (function +org-capture-central-project-notes-file)
             "* %U %^{Note for...} \n:PROPERTIES: \n:LINK: %a \n:END: \n%i \n%?"
             :heading "Notes"
             :prepend t
             )
            ("oc" "Project changelog" entry
             (function +org-capture-central-project-changelog-file)
             "* %U %^{Changelog for...} \n:PROPERTIES: \n:LINK: %a \n:END: \n%i \n%?"
             :heading "Changelog"
             :prepend t
             )
            ("op" "New Project" entry
             (file+headline +org-capture-todo-file "Projects")
             "* %^{Project for...} [/] %^{GOAL}p \n:PROPERTIES:\n:CAPTURED: %U \n:END: \n%i \n%?"
             :prepend t
             )
            ))

    (add-to-list 'org-capture-templates
                 '("GSA" "General Skim Annotation" entry
                   (file+function (lambda () (buffer-file-name)) +org-move-point-to-heading)
                   "* %^{Note for...}
   :PROPERTIES:
   :CREATED: %U
   :SKIM_NOTE: %(+reference/skim-get-annotation)
   :SKIM_PAGE: %(+reference/get-skim-page-number)
   :END:
   %i \n%?"))

    (add-to-list 'org-capture-templates
                 '("SA" "Skim Annotation" entry
                   (file+function org-ref-bibliography-notes +reference/org-move-point-to-capture-skim-annotation)
                   "* %^{Note for...}
   :PROPERTIES:
   :CREATED: %U
   :CITE: cite:%(+reference/skim-get-bibtex-key)
   :SKIM_NOTE: %(+reference/skim-get-annotation)
   :SKIM_PAGE: %(+reference/get-skim-page-number)
   :END:
   %i \n%?"))

    (setq org-gcal-capture-templates
          '("s" "Scedule an event" entry
            (file "~/org/gcal.org")
            "* %^{Scheduling...} \n:PROPERTIES: \n:calendar-id: jonghyun.yun@gmail.com \n:LOCATION: %^{Location} \n:END: \n:org-gcal: \n%^T \n%i\n%? \n:END:\n\n"
            :prepend t))

    (add-to-list 'org-capture-templates org-gcal-capture-templates)
    (with-eval-after-load 'calfw
      (setq cfw:org-capture-template org-gcal-capture-templates)
      ))

(with-eval-after-load 'org
;;; program for org latex preview
  ;; (setq org-preview-latex-default-process 'dvipng)
  (setq org-preview-latex-default-process 'dvisvgm)

  ;; get unicode math work!
  (setq org-latex-inputenc-alist '(("utf8" . "utf8x")))

  ;; (evil-set-initial-state 'org-agenda-mode 'emacs)
  ;; (add-to-list 'evil-emacs-state-modes 'org-agenda-mode)
  ;; (add-hook 'org-agenda-mode-hook 'evil-emacs-state)

  ;; ;;; latex support
  ;; (setq org-latex-pdf-process
  ;;  '("%latex -interaction nonstopmode -output-directory %o %f"
  ;;    "bibtex %b"
  ;;    "%latex -interaction nonstopmode -output-directory %o %f"
  ;;    "%latex -interaction nonstopmode -output-directory %o %f"))

  (setq org-latex-pdf-process
        '("latexmk -shell-escape -bibtex -f -pdflatex=%latex -pdf %f"))
  ;; '("latexmk -pdflatex=%latex -pdf %f"))

  ;; (add-hook 'org-mode-hook 'turn-on-org-cdlatex)

  ;; org-mode apps to open files
  (setq org-file-apps
        '((auto-mode . emacs)
          (directory . emacs)
          ("\\.mm\\'" . default)
          ("\\.x?html?\\'" . default)
          ("\\.pdf\\'" . "open -a Skim %s")
          ;; ("\\.pdf\\'" . emacs)
          ("\\.docx\\'" . default)
          ))

  ;; (org-defkey org-mode-map [(meta return)] 'org-meta-return)  ;; The actual fix

  ;; M-RET broken in org-mode
  ;; (use-package org
  ;; :bind (:map spacemacs-org-mode-map-root-map ("M-RET" . nil)))

  ;; Spell-checking exceptions
  ;; (add-to-list 'ispell-skip-region-alist '(":\\(PROPERTIES\\|LOGBOOK\\):" . ":END:"))
  ;; (add-to-list 'ispell-skip-region-alist '("#\\+BEGIN_SRC" . "#\\+END_SRC"))
  ;; (add-to-list 'ispell-skip-region-alist '("#\\+BEGIN_EXAMPLE" . "#\\+END_EXAMPLE"))

  (after! ispell

    ;; some org elements
    (pushnew! ispell-skip-region-alist
              '("~" . "~")
              '("=" . "=")
              ;; '(org-property-drawer-re)
              '(org-ref-cite-re)
              ;; '(org-ref-ref-re)
              ;; '(org-ref-label-re)
              ;; '(org-latex-math-environments-re)
              )

    ;; latex math
    (pushnew! ispell-skip-region-alist
              '("\\$" . "\\$")
              '("\\\\(" . "\\\\)")
              '("\\\[" . "\\\]")
              '("\\\\begin{\\(?:align\\(?:at\\)?\\|d\\(?:array\\|group\\|isplaymath\\|math\\|series\\)\\|e\\(?:mpheq\\|q\\(?:narray\\|uation\\)\\)\\|flalign\\|gather\\|m\\(?:ath\\|ultline\\)\\|subequations\\|x\\(?:x?alignat\\)\\)\\*?}"
                . "\\\\end{\\(?:align\\(?:at\\)?\\|d\\(?:array\\|group\\|isplaymath\\|math\\|series\\)\\|e\\(?:mpheq\\|q\\(?:narray\\|uation\\)\\)\\|flalign\\|gather\\|m\\(?:ath\\|ultline\\)\\|subequations\\|x\\(?:x?alignat\\)\\)\\*?}")
              '("\\\\begin\{align\*\}" . "\\\\end\{align\*\}")
              '("\\\\begin\{equation\*\}" . "\\\\end\{equation\*\}")
              '("\\\\begin\{eqnarray\*\}" . "\\\\end\{eqnarray\*\}")
              )

    ;; latex ref
      (pushnew! ispell-skip-region-alist
                '("\\\\ref\{" . "\}")
                '("\\\\cref\{" . "\}")
                '("\\\\eqref\{" . "\}")
                '("\\\\label\{" . "\}")
                '("\\\\printbibliography\\[" . "\\]")
                )

    )

  (setq org-highlight-latex-and-related '(native))

  ;; org-mode and knitr
  ;; (require 'ox-md) ;; required to markdown export
  ;; (require 'ox-ravel)

  ;; ;; this hook saves an ics file once an org-buffer is saved
  ;; (defun my-icalendar-agenda-export()
  ;;   (if (string= (file-name-extension (buffer-file-name)) "org")
  ;;       (org-icalendar-combine-agenda-files))
  ;;   )
  ;; (add-hook 'after-save-hook 'my-icalendar-agenda-export)

  ;; ;; Org export to iCalendar
  ;; (setq org-icalendar-combined-agenda-file "~/Dropbox/MobileOrg/notes.ics")
  ;; (setq org-icalendar-include-todo t)
  ;; (setq org-icalendar-use-scheduled '(event-if-todo event-if-not-todo))
  ;; (setq org-icalendar-use-deadline '(event-if-todo event-if-not-todo))
  ;; (setq org-icalendar-date-time-format ";TZID=%Z:%Y%m%dT%H%M%S")
  ;; (setq org-icalendar-timezone "America/Chicago")

  (setq org-agenda-files '(
                           "~/org/inbox.org"
                           "~/org/todo.org"
                           "~/org/gcal.org"
                           "~/org/projects.org"
                           "~/org/tickler.org"
                           "~/org/routines.org"
                           ))

  ;; Don't ask to evaluate code block
  ;; (setq org-confirm-babel-evaluate nil)

  ;; https://gist.github.com/ertwro/4e1fde4ddcd989ad7e3277df8b7f611a
  ;; (setq inferior-julia-program-name "/usr/local/bin/julia")
  ;; (org-babel-do-load-languages
  ;;  'org-babel-load-languages
  ;;  '(
  ;;    (julia . t)
  ;;    ))

  ;; (add-to-list 'org-src-lang-modes '("plantuml" . plantuml))

  ;;;; ob-async needs??
  ;; (require 'ob-async)

  ;; ;; execute source code in org-mode
  ;; (org-babel-do-load-languages
  ;;  'org-babel-load-languages
  ;;  '((latex . t)
  ;;    (python . t)
  ;;    (R . t)
  ;;    (org . t)
  ;;    (http . t)
  ;;    (ruby . t)
  ;;    (js . t)
  ;;    (matlab . t)
  ;;    (emacs-lisp . t)
  ;;    (shell . t)
  ;;    (plantuml . t)))

  ;; ;; read project todos
  ;; (with-eval-after-load 'org-agenda
  ;;   (require 'org-projectile)
  ;;   (mapcar #'(lambda (file)
  ;;               (when (file-exists-p file)
  ;;                 (push file org-agenda-files)))
  ;;           (org-projectile-todo-files)))

  ;; Add org-pomodoro to global evil-leader mappings.
  ;; (spacemacs/set-leader-keys "aoCp" 'org-pomodoro)

  ;; org-structure-template
  ;; (with-eval-after-load 'org
  ;;   (require 'org-tempo)
  ;;   )

  (setq org-structure-template-alist
        (append org-structure-template-alist
                '(("se" . "src emacs-lisp")
                  ("sr" . "src R")
                  ("sm" . "src matlab")
                  ("sp" . "src python")
                  ("ss" . "src sh"))))

  ;; Org-mode: Source block doesn't respect parent buffer indentation
  ;; http://emacs.stackexchange.com/questions/9472/org-mode-source-block-doesnt-respect-parent-buffer-indentation
  (setq org-edit-src-content-indentation 0
        org-src-preserve-indentation nil
        )

  ;; Org-mode
  ;; M-RET broken in org-mode
  ;; (use-package org
  ;; :bind (:map spacemacs-org-mode-map-root-map ("M-RET" . nil)))

  ;; company-mode
  ;; 1. remove those non-ANSII candidates.
  ;; 2. remove any completion containing numbers.
  ;; 3. remove any candidate which is longer than 15 in org-mode.

  ;; (require 'company)
  ;; (push (apply-partially #'cl-remove-if
  ;;                        (lambda (c)
  ;;                          (or (string-match-p "[^\x00-\x7F]+" c)
  ;;                              (string-match-p "[0-9]+" c)
  ;;                              (if (equal major-mode "org")
  ;;                                  (>= (length c) 15)))))
  ;;       company-transformers)
  ;; (delete 'company-dabbrev company-backends)

  ;; (setq org-startup-truncated nil)

  ;; By using unique ID’s for links in Org-mode, links will work even if you move them across files.
  (require 'org-id)
  (setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id
        org-clone-delete-id t)

  (setq org-refile-targets '(("~/org/todo.org" :maxlevel . 3)
                             ("~/org/projects.org" :maxlevel . 3)
                             ("~/org/someday.org" :level . 1)
                             ("~/org/tickler.org" :maxlevel . 1)
                             ("~/org/notes.org" :maxlevel . 2)
                             ))

  ;; org ess
  ;; (setq org-babel-R-command "R --silent --no-save")

  ;;; OrgMode functions
  ;; run a paragraph in src block
  ;; (defun org-ess-mode-config ()
  ;; (local-set-key (kbd "C-M-x") 'ess-eval-region-or-function-or-paragraph))

  ;; babel yaml execution
  ;; (defun org-babel-execute:yaml (body params) body)

  ;;; orgmode project to publish
  ;; (with-eval-after-load 'ox-publish
  ;;   (setq org-publish-project-alist
  ;;         '(
  ;;           ;; ("org"
  ;;           ;;  :base-directory "~/Dropbox/website/"
  ;;           ;;  :base-extension "org"
  ;;           ;;  ;; :publishing-directory "~/Dropbox/Public/html/" ;;"/ssh:user@host:~/html/notebook/"
  ;;           ;;  :publishing-directory "~/uta.webdav"
  ;;           ;;  :recursive t
  ;;           ;;  :publishing-function org-html-publish-to-html
  ;;           ;;  :headline-levels 4             ; Just the default for this project.
  ;;           ;;  :auto-preamble t
  ;;           ;;  :exclude "demo\\|README.org\\|readtheorg.org"
  ;;           ;;  )
  ;;           ;; ("static"
  ;;           ;;  :base-directory "~/Dropbox/website/"
  ;;           ;;  :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
  ;;           ;;  ;; :publishing-directory "~/Dropbox/Public/html/"
  ;;           ;;  :publishing-directory "~/uta.webdav"
  ;;           ;;  :recursive t
  ;;           ;;  :publishing-function org-publish-attachment
  ;;           ;;  :exclude "webfiles\\|demo\\|readtheorg.png\\|bigblow.png"
  ;;           ;;  )
  ;;           ;; ("website" :components ("org" "static"))

  ;;           ;; ;; math3315 Statistical Inference
  ;;           ;; ("math3316-org"
  ;;           ;;  :base-directory "~/MATH3316/"
  ;;           ;;  :base-extension "org"
  ;;           ;;  :publishing-directory "~/blackboard/math3316-fa18/MATH3316"
  ;;           ;;  :recursive t
  ;;           ;;  :publishing-function org-html-publish-to-html
  ;;           ;;  :headline-levels 4             ; Just the default for this project.
  ;;           ;;  :auto-preamble t
  ;;           ;;  :exclude "quiz\\|exam\\|slides\\|doc\\|sol\\|noexport"
  ;;           ;;  )
  ;;           ;; ("math3316-website-static"
  ;;           ;;  :base-directory "~/website/"
  ;;           ;;  :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
  ;;           ;;  :publishing-directory "~/blackboard/math3316-fa18/MATH3316"
  ;;           ;;  :recursive t
  ;;           ;;  :publishing-function org-publish-attachment
  ;;           ;;  :exclude "webfiles\\|demo\\|readtheorg.png\\|bigblow.png"
  ;;           ;;  )
  ;;           ;; ("math3316-static"
  ;;           ;;  :base-directory "~/MATH3316/"
  ;;           ;;  :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
  ;;           ;;  :publishing-directory "~/blackboard/math3316-fa18/MATH3316"
  ;;           ;;  :publishing-function org-publish-attachment
  ;;           ;;  :recursive t
  ;;           ;;  :exclude "quiz\\|exam\\|doc\\|slides\\|sol\\|noexport"
  ;;           ;;  )
  ;;           ;; ("math3316-doc"
  ;;           ;;  :base-directory "~/MATH3316/doc"
  ;;           ;;  :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|html\\|txt\\|csv"
  ;;           ;;  :publishing-directory "~/blackboard/math3316-fa18/MATH3316/doc"
  ;;           ;;  :publishing-function org-publish-attachment
  ;;           ;;  :recursive t
  ;;           ;;  :exclude "quiz\\|exam\\|slides\\|noexport\\|sol-*\\|sol\\|site_libs"
  ;;           ;;  )
  ;;           ;; ("math3316-sol"
  ;;           ;;  :base-directory "~/MATH3316/doc"
  ;;           ;;  :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|html\\|txt\\|csv"
  ;;           ;;  :publishing-directory "~/blackboard/math3316-fa18/MATH3316/doc"
  ;;           ;;  :publishing-function org-publish-attachment
  ;;           ;;  :recursive t
  ;;           ;;  :exclude "quiz\\|exam\\|slides\\|noexport\\|sol\\|site_libs"
  ;;           ;;  )
  ;;           ;; ("math3316" :components ("math3316-org" "math3316-static" "math3316-doc"))

  ;;           ;; hugo website test
  ;;           ("website"
  ;;            :base-directory "~/website/public/"
  ;;            ;; :base-extension "html\\|css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
  ;;            :base-extension "html\\|css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|rmd\\|xml\\|json\\|webmanifest\\|ttf\\|woff2\\|svg\\|woff\\|eot"
  ;;            :publishing-directory "~/uta.webdav/"
  ;;            :publishing-function org-publish-attachment
  ;;            :recursive t
  ;;            :exclude "course\\|_notes\\|.DS_Store"
  ;;            )
  ;;           ;; hugo math6312-sp19
  ;;           ("math6312"
  ;;            :base-directory "~/website/public/course/math6312-sp19/"
  ;;            :base-extension "html\\|css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|rmd\\|xml\\|json\\|webmanifest\\|ttf\\|woff2\\|svg\\|woff\\|eot"
  ;;            ;; :base-extension "*"
  ;;            ;; :publishing-directory "~/uta.webdav/test/course/math6312-sp19/"
  ;;            :publishing-directory "~/uta.webdav/course/math6312-sp19/"
  ;;            :publishing-function org-publish-attachment
  ;;            :recursive t
  ;;            :exclude "_notes//|.DS_Store"
  ;;            )
  ;;           )))

  (setq org-preview-latex-process-alist
        (quote
         ((dvipng :programs
                  ("latex" "dvipng")
                  :description "dvi > png" :message "you need to install the programs: latex and dvipng." :image-input-type "dvi" :image-output-type "png" :image-size-adjust
                  (1.0 . 1.0)
                  :latex-compiler
                  ("latex -interaction nonstopmode -output-directory %o %f")
                  :image-converter
                  ("dvipng -D %D -T tight -o %O %f"))
          (dvisvgm :programs
                   ("latex" "dvisvgm")
                   :description "xdv > svg" :message "you need to install the programs: xelatex and dvisvgm." :use-xcolor t :image-input-type "xdv" :image-output-type "svg" :image-size-adjust
                   (1.7 . 1.5)
                   :latex-compiler
                   ("xelatex -no-pdf -interaction nonstopmode -output-directory %o %f")
                   :image-converter
                   ("dvisvgm %f -n -b min -c %S -o %O"))
          (imagemagick :programs
                       ("latex" "convert")
                       :description "pdf > png" :message "you need to install the programs: latex and imagemagick." :image-input-type "pdf" :image-output-type "png" :image-size-adjust
                       (1.0 . 1.0)
                       :latex-compiler
                       ("pdflatex -interaction nonstopmode -output-directory %o %f")
                       :image-converter
                       ("convert -density %D -trim -antialias %f -quality 100 %O")))
         ))

  ;; suppress warning
  ;; org-protocol-check-filename-for-protocol from release_9.3.7
;;   (with-eval-after-load 'org-protocol
;;     (defvar org-protocol-warn-about-old-links t
;;       "If non-nil (the default), issue a warning when org protocol
;; receives old style links.")

;;     (setq org-protocol-warn-about-old-links nil)

;;     ;; override 'org-protocol-check-filename-for-protocol to suppress warnings

;;     (load (expand-file-name "autoload/org" doom-private-dir))
;;     )

  )

(provide 'org-plus)
;;; org-plus.el ends here
