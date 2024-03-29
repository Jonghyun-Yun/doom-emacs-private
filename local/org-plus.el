;;; ../Dropbox/emacs/.doom.d/local/org-plus.el -*- lexical-binding: t; -*-

;; https://gitlab.com/oer/org-re-reveal-ref/-/blob/master/org-re-reveal-ref.el
;; it changes some of org-ref custom variables
(use-package! org-re-reveal-ref
  :when (modulep! :lang org +present)
  :after org-re-reveal
  )

;; (use-package! org-appear
;;   ;; :hook (org-mode . org-appear-mode)
;;   :defer t
;;   :config
;;   (setq org-appear-autoemphasis t
;;         org-appear-autosubmarkers t
;;         org-appear-autolinks nil)
;;   ;; for proper first-time setup, `org-appear--set-elements'
;;   ;; needs to be run after other hooks have acted.
;;   (run-at-time nil nil #'org-appear--set-elements))

(use-package org-cv
  ;; :load-path "~/Dropbox/emacs/packages/org-cv"
  :defer t
  ;; :after ox
  :config
  ;; (require 'ox-moderncv)
  (require 'ox-altacv)
  ;; (require 'ox-hugocv)
  )

;;; ox-ravel
;; `ox-hugo' depends on this
(use-package ox-ravel
  :after org
  :load-path "~/.doom.d/local/ox-ravel"
  ;; :after ox
  :config
  ;; (require 'ob-R)
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

(eval-after-load 'ox-html
  (progn
    ;; inderting <kbd> tags interactively
    ;; If you prefer to use ~ for <code> tags. Replace "code" with
    ;; "verbatim" here, and replace "~" with "=" below.
    '(push '(code . "<kbd>%s</kbd>") org-html-text-markup-alist)
    ;; table to html
    (setq org-html-table-row-close-tag "</tr align=\"right\">"
          ;; org-html-htmlize-output-type 'css
          ))
  )

;;;; KOMA-SCript letter
(eval-after-load 'ox '(require 'ox-koma-letter))
(eval-after-load 'ox-koma-letter
  '(progn
     (add-to-list 'org-latex-classes
                  '("my-koma-letter"
                    "\\documentclass\{scrlttr2\}
\[NO-DEFAULT-PACKAGES]
\[NO-PACKAGES]
\[EXTRA]"))
     (setq org-koma-letter-default-class "my-koma-letter")))

;;; org-latex
(with-eval-after-load 'ox-latex
  ;; do not put in \hypersetup. Use your own if you want it e.g.
  ;; \hypersetup{pdfkeywords={%s},\n pdfsubject={%s},\n pdfcreator={%}}
  (setq org-latex-hyperref-template nil)

  ;; this is for code syntax highlighting in export. you need to use
  ;; -shell-escape with latex, and install pygments.
  (setq org-latex-listings 'minted)
  (setq org-latex-minted-options
        '(("frame" "lines")
          ("fontsize" "\\scriptsize")
          ("linenos" "")))

  ;; avoid getting \maketitle right after begin{document}
  ;; you should put \maketitle if and where you want it.
  (setq org-latex-title-command "\\maketitle")

  ;; custom_id -> \label
  (setq org-latex-prefer-user-labels t)

  ;; highlight lco file
  (add-to-list 'auto-mode-alist '("\\.lco" . LaTeX-mode))

  ;; ;; https://orgmode.org/manual/LaTeX-specific-export-settings.html
  ;; (add-to-list 'org-latex-packages-alist
  ;;              '("AUTO" "babel" t ("pdflatex")))
  ;; (add-to-list 'org-latex-packages-alist
  ;;              '("AUTO" "polyglossia" t ("xelatex" "lualatex")))

;;; org-latex-packages
  ;; `t' means the package also needs to be included compiling LaTeX snippets
  ;;   into images for inclusion into when non-LaTeX output.
  (setq org-latex-default-packages-alist
        '(
          ("utf8" "inputenc" t
           ("pdflatex"))
          ("T1" "fontenc" t
           ("pdflatex"))
          ("" "graphicx" t)
          ("" "longtable" nil)
          ("" "wrapfig" nil)
          ("" "rotating" nil)
          ("normalem" "ulem" t)
          ("" "amsmath" t)
          ("" "textcomp" t)
          ("" "amssymb" t)
          ("" "capt-of" nil)
          ("" "xcolor" t)
          ("" "hyperref" nil)
          ))
  (setq org-latex-packages-alist
        '(
          ;;   ("AUTO" "inputenc" t ("pdflatex")) ; for basic font and character selection

          ;; ;; This is for handling accented characters
          ;; ("T1" "fontenc" t ("pdflatex"))

          ;; ("" "lmodern" nil)            ;

          ("AUTO" "babel" t ("pdflatex"))
          ("AUTO" "polyglossia" t ("xelatex" "lualatex"))
          ("" "csquotes" t)            ; Context sensitive quotation facil ities

          ;; This makes standard margins
          ("top=1in, bottom=1.in, left=1in, right=1in" "geometry" nil)

          ;; 	("" "graphicx" t)
          ;; 	("" "longtable" nil) ; For multipage tables
          ;; 	("" "wrapfig" nil)	  ;makes it possible to wrap text around figures
          ;; 	("" "rotating" nil)
          ;; 	("normalem" "ulem" t) ; for underline and strike-through
          ("" "booktabs" nil)
          ("" "float" nil)
          ("" "subfig" nil)

          ;; 	;; These provide math symbols
          ;; 	("" "amsmath" t)
          ;; 	("" "amssymb" t)
          ;; 	("" "textcomp" t)
          ("" "marvosym" t)
          ;; 	("" "wasysym" t)
          ;; ("" "amsbsy" t)
          ("" "bm" t ("pdflatex"))      ; doesn't work well with unicode-math
          ;; FIXME: =cool= conflict with another package
          ;; ("" "cool" t)         ; for math operators & symbols e.g. partial diff
          ("" "mathtools" t)            ; for math aligning & spacing
          ("" "physics" t)              ; derivative, dx, operators
          ("" "cancel" t)
          ("theorems, skins" "tcolorbox" t)
          ("mathbf=sym" "unicode-math" t ("xelatex" "lualatex"))

          ;; 	("numbers,super,sort&compress" "natbib" nil)
          ;; 	("" "natmove" nil)

          ("" "url" nil)
          ;; this is used for syntax highlighting of code
          ("cache=false" "minted" nil)

          ;; 	;; enables you to embed files in pdfs
          ;; 	("" "attachfile" nil)

          ;; 	;; set default spacing
          ;; 	("" "setspace" nil)

          ;; what engine am i using?
          ("" "iftex" t)
          ))

;;;; Bare-bones template
  (add-to-list 'org-latex-classes
               '("no-article"
                 "\\documentclass{article}
\[DEFAULT-PACKAGES]
\[NO-PACKAGES]
\[EXTRA]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  (add-to-list 'org-latex-classes
               '("scr-article"
                 "\\documentclass{scrartcl}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  (add-to-list 'org-latex-classes
               '("scr-report"
                 "\\documentclass{scrreprt}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;;;; org-export: Remove additional latex temporary files.
  (setq org-latex-logfiles-extensions
        (append '("dvi" "bbl") org-latex-logfiles-extensions))
  )

(defvar +org-capture-inbox-file "inbox.org"
  "Default target for todo entries.

Is relative to `org-directory', unless it is absolute. Is used in Doom's default
`org-capture-templates'.")

;;;###autoload
(defun +org-capture-inbox-file ()
  "Expand `+org-capture-inbox-file' from `org-directory'.
If it is an absolute path return `+org-capture-inbox-file' verbatim."
  (expand-file-name +org-capture-inbox-file org-directory))

(defvar +org-capture-tickler-file "tickler.org"
  "Default target for todo entries.

Is relative to `org-directory', unless it is absolute. Is used in Doom's default
`org-capture-templates'.")

;;;###autoload
(defun +org-capture-tickler-file ()
  "Expand `+org-capture-tickler-file' from `org-directory'.
If it is an absolute path return `+org-capture-tickler-file' verbatim."
  (expand-file-name +org-capture-tickler-file org-directory))

;;; Org capture templates
(defun jyun/org-capture-template-h ()
  "Load org-capture-templates."
  (progn
    (setq org-capture-templates
          '(
            ("r" "Reminder" entry
             (file+headline +org-capture-tickler-file "Reminders")
             "* TODO %^{Reminder for...} \nSCHEDULED: %^t \n%i \n%a"
             :prepend t)
            ("c" "Clock a task" entry
             (file+headline +org-capture-inbox-file "Clocked")
             "* NEXT %(jyun/org-link-truncate-initial-content-or-description 70) \n%?"
             :clock-in t
             :clock-keep t
             :prepend t
             ;; :immediate-finish t
             )
            ("t" "Todo")
            ("tt" "Todo" entry
             (file+headline +org-capture-inbox-file "Tasks")
             "* TODO %? \n%i \n%a"
             :prepend t)
            ("td" "Todo deadline" entry
             (file+headline +org-capture-inbox-file "Task Deadlines")
             "* TODO %? \nDEADLINE: %^t \n%i \n%a"
             :prepend t)
            ("tr" "Rapid task" entry
             (file+headline +org-capture-inbox-file "Rapid Tasks")
             "* TODO %(jyun/org-link-truncated-description-or-annotation) \nDEADLINE: %(org-insert-time-stamp (org-read-date nil t \"+1d\")) \n%i \n%?"
             :prepend t)
            ("tj" "Apply for jobs" entry
             (file+headline +org-capture-job-file "Job posting")
             "* TODO %(jyun/org-link-truncated-description-or-annotation) :job:\nDEADLINE: %(org-insert-time-stamp (org-read-date nil t \"+1d\")) \n%i \n%?"
             :prepend t)
            ("ti" "Jobs: initial to link description" entry
             (file+headline +org-capture-job-file "Job posting")
             "* TODO %(jyun/org-link-truncate-initial-content-or-description) :job:\nDEADLINE: %(org-insert-time-stamp (org-read-date nil t \"+1d\")) \n%?"
             :prepend t)
            ("ts" "Clocked subtask" entry (clock)
             "* TODO %? \n:PROPERTIES: \n:CAPTURED: %U \n:END: \n%i \n%a")
            ("b" "Bookmark")
            ("bc" "Custom bookmark" entry
             (file+headline +org-capture-bookmark-file "Bookmark")
             "* %u %(jyun/org-link-truncated-description-or-annotation 70) %? \n%i"
             :empty-lines 1
             )
            ("bb" "Quick bookmark" entry
             (file+headline +org-capture-bookmark-file "Bookmark")
             "* %u %(jyun/org-link-truncated-description-or-annotation 70) \n%i"
             :empty-lines 1
             :immediate-finish t
             )
            ("bf" "Finance bookmark" entry
             (file+headline +org-capture-bookmark-file "Bookmark - finance")
             "* %u %(jyun/org-link-truncated-description-or-annotation 70) :fin: \n%i"
             :empty-lines 1
             :immediate-finish t
             )
            ("n" "Note" entry
             (file+headline +org-capture-notes-file "Inbox")
             "* %u %? \n%i \n%a"
             :prepend t)
            ("j" "Journal" entry
             (file+olp+datetree +org-capture-journal-file)
             "* %U %? \n%i \n%a"
             :prepend t
             ;; :tree-type week
             ;; :clock-in :clock-resume
             ;; :empty-lines 1
             )
            ;; ("je" "General Entry" entry
            ;;  (file+olp+datetree +org-capture-journal-file)
            ;;  "\n* %<%I:%M %p> - %^{Title} \n\n%?\n\n"
            ;;  ;; :tree-type week
            ;;  :clock-in :clock-resume
            ;;  :empty-lines 1)
            ;; ("jt" "Task Entry" entry
            ;;  (file+olp+datetree +org-capture-journal-file)
            ;;  "\n* %<%I:%M %p> - Task Notes: %a\n\n%?\n\n"
            ;;  ;; :tree-type week
            ;;  :clock-in :clock-resume
            ;;  :empty-lines 1)
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
            ("p" "Project")
            ("pt" "Project todo" entry
             #'+org-capture-central-project-todo-file
             "* TODO %? \n%i \n%a"
             :heading "Tasks"
             :prepend nil)
            ("pn" "Project note" entry
             #'+org-capture-central-project-notes-file
             "* %U %? \n%i \n%a"
             :heading "Notes"
             :prepend t)
            ("pc" "Project changelog" entry
             #'+org-capture-central-project-changelog-file
             "* %U %? \n%i \n%a"
             :heading "Changelog"
             :prepend t)
            ("pp" "New Project" entry
             (file+headline +org-capture-todo-file "Projects")
             "* %^{Project for...} [/] %^{GOAL}p \n%i"
             :prepend t)))
    ;; (require 'org-gcal)
    (when (modulep! :private gcal)
                     (add-to-list 'org-capture-templates org-gcal-capture-templates))
    (when (modulep! :private reference)
                     (jyun/org-capture-skim-template-h))
    ))
(with-eval-after-load 'org-capture
  (jyun/org-capture-template-h))
;; (jyun/org-capture-template-h)

;;; org-config
(setq org-structure-template-alist
      '(("a" . "export ascii")
        ("c" . "center")
        ("C" . "comment")
        ("e" . "example")
        ("E" . "export")
        ("h" . "export html")
        ("l" . "export latex")
        ("q" . "quote")
        ("s" . "src")
        ("v" . "verse")
        ("se" . "src emacs-lisp")
        ("sr" . "src R")
        ("sm" . "src matlab")
        ("sp" . "src python")
        ("sh" . "src sh")
        ))

;; get unicode math work!
(setq org-latex-inputenc-alist '(("utf8" . "utf8x")))

;; Org-mode: Source block doesn't respect parent buffer indentation
;; http://emacs.stackexchange.com/questions/9472/org-mode-source-block-doesnt-respect-parent-buffer-indentation
(setq org-edit-src-content-indentation 0)

;; no extra indentation in the source blocks
(setq org-src-preserve-indentation t)

;; By using unique ID’s for links in Org-mode, links will work even if you move them across files.
;; (require 'org-id)
(setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id
      org-clone-delete-id t)

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
                     ("convert -density %D -trim -antialias %f -quality 100 %O")))))

;;; view org output: SPC m v
  (map! :map org-mode-map
        :localleader
        :desc "View exported file" "v" #'org-view-output-file)
  (defvar org-view-output-file-extensions '("pdf" "md" "docx" "rst" "txt" "tex" "html")
    "Search for output files with these extensions, in order, viewing the first that matches")
  (defvar org-view-external-file-extensions '("html" "docx")
    "File formats that should be opened externally.")

(with-eval-after-load 'org
;;; org-refile
  (setq org-refile-targets '(("~/org/todo.org" :maxlevel . 3)
                             ("~/org/projects.org" :maxlevel . 3)
                             ("~/org/tickler.org" :maxlevel . 1)
                             ("~/org/someday.org" :maxlevel . 1)
                             ("~/org/notes.org" :maxlevel . 2)
                             ("~/org/jobs.org" :maxlevel . 1)
                             ("~/org/finance.org" :maxlevel . 1)
                             ))

  ;; (add-to-list 'org-refile-targets '(("~/org/someday.org" :level . 3) ("~/org/notes.org" :maxlevel . 3)))

;;; program for org latex preview
  ;; ;; fast, no unicode-math
  ;; (setq org-preview-latex-default-process 'dvipng)
  ;; ;; slow, supprts unicode-math
  ;; (setq org-preview-latex-default-process 'dvisvgm)

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
          ;; ("\\.pdf\\'" . emacs)
          ("\\.pdf\\'" . "open -a Skim %s")
          ;; ("\\.pdf\\'" . default)
          ;; ("\\.pdf\\'" . emacs)
          ("\\.docx\\'" . default)
          ("\\.xlsx\\'" . default)
          ("\\.pptx\\'" . default)
          ))

  (when IS-LINUX
    ;; org-mode apps to open files
    (setq org-file-apps
          '((auto-mode . emacs)
            (directory . emacs)
            ("\\.mm\\'" . default)
            ("\\.x?html?\\'" . default)
            ;; ("\\.pdf\\'" . "open -a Skim %s")
            ("\\.pdf\\'" . default)
            ;; ("\\.pdf\\'" . emacs)
            ("\\.docx\\'" . default)
            ("\\.xlsx\\'" . default)
            ("\\.pptx\\'" . default)
            ))
    )

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
              ))

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

  (defvar org-agenda-base-files `("~/org/inbox.org"
                                  "~/org/todo.org"
                                  "~/org/gcal.org"
                                  "~/org/projects.org"
                                  "~/org/tickler.org"
                                  "~/org/routines.org"
                                  "~/org/journal.org"
                                  "~/org/jobs.org"
                                  "~/org/notes.org"
                                  "~/workspace/cyber.org"
                                  "~/workspace/swap.org"
                                  )
    "A list of org-agneda files that are not resided in `org-roam-directory'.")

  (setq org-agenda-files (append org-agenda-base-files (list org-roam-directory)))

  ;; Don't ask to evaluate code block
  ;; (setq org-confirm-babel-evaluate nil)

  ;; https://gist.github.com/ertwro/4e1fde4ddcd989ad7e3277df8b7f611a
  ;; (setq inferior-julia-program-name "/opt/homebrew/bin/julia")
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

;;; org-latex fragment
  ;; https://stackoverflow.com/questions/43149119/how-to-regenerate-latex-fragments-in-org-mode
  (defvar my/org-latex-toggle-fragment-has-been-called nil
    "Tracks if org-toggle-latex-fragment has ever been called (updated locally).")

  (defadvice org-toggle-latex-fragment (before my/latex-fragments-advice activate)
    "Keep Org LaTeX fragments in a directory with background color name."
    (if (not my/org-latex-toggle-fragment-has-been-called) (jyun/org-latex-set-options))
    (setq-local my/org-latex-toggle-fragment-has-been-called t)
    (jyun/org-latex-set-directory-color))

  (defadvice load-theme (after my/load-theme-advice-for-latex activate)
    "Conditionally update Org LaTeX fragments for current background."
    (if my/org-latex-toggle-fragment-has-been-called (jyun/org-latex-update-fragments-color)))

  (defadvice disable-theme (after my/disable-theme-advice-for-latex activate)
    "Conditionally update Org LaTeX fragments for current background."
    (if my/org-latex-toggle-fragment-has-been-called (jyun/org-latex-update-fragments-color)))
  )
