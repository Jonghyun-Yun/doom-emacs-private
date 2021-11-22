;;; ~/.doom.d/autoload/misc.el -*- lexical-binding: t; -*-

;; no bug-fix in doom loaded pdf-tools yet.
;;;###autoload
(defun pdf-misc-print-program (&optional interactive-p)
  (or (and pdf-misc-print-program
           (executable-find pdf-misc-print-program))
      (when interactive-p
        (let* ((default (car (delq nil (mapcar
                                        'executable-find
                                        '("gtklp" "xpp" "gpr")))))
               buffer-file-name
               (program
                (expand-file-name
                 (read-file-name
                  "Print with: " default nil t nil 'file-executable-p))))
          (when (and program
                     (executable-find program))
            (when (y-or-n-p "Save choice using customize ?")
              (customize-save-variable
               'pdf-misc-print-program program))
            (setq pdf-misc-print-program program))))))

;;; make function (SPC c m)
;;;###autoload
(defun jyun/make (&optional arg)
  "Run a make task in the current project. If multiple makefiles are available,
you'll be prompted to select one.
With a `\\[universal-argument]' prefix argument ARG, execute `+make/run-last'."
  (interactive "P")
  (cond
   ((equal arg '(4))
    (+make/run-last)
    )
   ;; +make/run
   (t
    (+make/run)
    )))
