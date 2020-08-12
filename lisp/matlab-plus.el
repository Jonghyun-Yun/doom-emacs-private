;; matlab-shell-run-paragraph
(eval-after-load "ess"
  '(progn
     (defun my-matlab-shell-run-region--normalise-region (start end)
       "Clean the region for evaluation.
This trims newlines at beginning and end of the region because
they might throw off the debugger."
       (save-excursion
         (goto-char start)
         (skip-chars-forward "\n\t ")
         (setq start (point))

         (unless mark-active
           (ess-blink-region start end))

         (goto-char end)
         (skip-chars-backward "\n\t ")
         (setq end (point))))

     (defun my-matlab-shell--eval-region (start end &optional noshow)
       "Helper function for `ess-eval-region', which see.
START, END, TOGGLE, MESSAGE, and TYPE described there."
       (my-matlab-shell-run-region--normalise-region start end)
         (save-excursion
           (matlab-shell-run-region start end noshow))
       (when 'ess-eval-deactivate-mark
         (ess-deactivate-mark))
       (list start end))

     (defun my-matlab-shell-run-region (start end &optional noshow)
       "Send the region from START to END to the inferior MATLAB process."
       (interactive "r\nP")
       (my-matlab-shell--eval-region start end noshow))

     (defun matlab-shell-run-line ()
       "Send the current line to the matlab-shell."
       (interactive)
       (save-excursion
         (end-of-line)
         (let ((end (point)))
           (beginning-of-line)
           (my-matlab-shell-run-region (point) end))))

     (defun matlab-shell-run-line-and-step ()
       "Evaluate the current line and step to the \"next\" line."
       (interactive)
       (matlab-shell-run-line)
       (ess-next-code-line 1))

  (defun matlab-shell-run-paragraph ()
    "Send the current paragraph to the inferior MATLAB process."
    (interactive)
    (save-excursion
      (forward-paragraph)
      ;; Skip blank code to avoid sending surrounding comments
      (ess-skip-blanks-backward 'multiline)
      (let ((end (point)))
        (backward-paragraph)
        (ess-skip-blanks-forward 'multiline)
        (my-matlab-shell-run-region (point) end))))

  (defun matlab-shell-run-paragraph-and-step ()
    "Evaluate the current paragraph and move point to the next line.
If not inside a paragraph, evaluate the next one."
    (interactive)
    (let ((beg-end (matlab-shell-run-paragraph)))
      (goto-char (cadr beg-end))
      (if ess-eval-empty
          (forward-line 1)
        (ess-next-code-line 1))))

  (defun matlab-shell-run-region-or-paragraph-and-step ()
    "Send the region or paragraph depending on context.
Send the region if it is active. If not, send function if `point'
is inside one, otherwise the current paragraph. After evaluation
step to the next code line or to the end of region if region was
active."
    (interactive)
    (if (use-region-p)
        (let ((end (region-end)))
          (my-matlab-shell-run-region (region-beginning) end)
          (goto-char end))
      (matlab-shell-run-paragraph-and-step)))
  ))

(eval-after-load "matlab"
'(defun gud-matlab-marker-filter (string)
  "Filters STRING for the Unified Debugger based on MATLAB output. This function overide the same function in matlab.el to fix the remote toolbox directory in math-yun.uta.edu."

  ;; Setup the toolbox directory
  (setq toolbox-dir (expand-file-name "toolbox"
				                              (file-name-directory
				                               (locate-library "matlab"))))

  ;; Modify toolbox-dir path if matlab-shell is launched in the remote
  (if (string= (file-remote-p default-directory 'host) "math-yun")
      (setq toolbox-dir (s-replace "\/Users" "\/home" toolbox-dir)))

  (if matlab-prompt-seen
      nil
    (when (string-match ">> " string)
      (if matlab-shell-use-emacs-toolbox
	        ;; Use our local toolbox directory.
	        (process-send-string
	         (get-buffer-process gud-comint-buffer)
	         (format "addpath('%s','-begin'); rehash; emacsinit('%s');\n"
                   ;; change the path of tooldbox for remote connection.
		               ;; (expand-file-name "toolbox"
				           ;; (file-name-directory
				           ;; (locate-library "matlab")))
                   toolbox-dir
		               matlab-shell-emacsclient-command))
        ;; Setup is misconfigured - we need emacsinit because it tells us how to debug
        (error "unable to initialize matlab, emacsinit.m and other files missing"))
      (if matlab-custom-startup-command
          (process-send-string
	         (get-buffer-process gud-comint-buffer)
           (concat matlab-custom-startup-command "\n")))
      ;; Mark that we've seen at least one prompt.
      (setq matlab-prompt-seen t)
      ))
  (let ((garbage (concat "\\(" (regexp-quote "\C-g") "\\|"
 			                   (regexp-quote "\033[H0") "\\|"
 			                   (regexp-quote "\033[H\033[2J") "\\|"
 			                   (regexp-quote "\033H\033[2J") "\\)")))
    (while (string-match garbage string)
      (if (= (aref string (match-beginning 0)) ?\C-g)
	        (beep t))
      (setq string (replace-match "" t t string))))

  (setq gud-marker-acc (concat gud-marker-acc string))
  (let ((output "") (frame nil))

    (when (not frame)
      (when (string-match gud-matlab-marker-regexp-1 gud-marker-acc)
	      (when (not frame)
	        ;; If there is a debug prompt, and no frame currently set,
	        ;; go find one.
	        (let ((url gud-marker-acc)
		            ef el)
	          (cond
	           ((string-match "^error:\\(.*\\),\\([0-9]+\\),\\([0-9]+\\)$" url)
	            (setq ef (substring url (match-beginning 1) (match-end 1))
		                el (substring url (match-beginning 2) (match-end 2)))
	            )
	           ((string-match "opentoline('\\([^']+\\)',\\([0-9]+\\),\\([0-9]+\\))" url)
	            (setq ef (substring url (match-beginning 1) (match-end 1))
		                el (substring url (match-beginning 2) (match-end 2)))
	            )
	           ;; If we have the prompt, but no match (as above),
	           ;; perhaps it is already dumped out into the buffer.  In
	           ;; that case, look back through the buffer.

	           )
	          (when ef
	            (setq frame (cons ef (string-to-number el)))))))
      )
    ;; This if makes sure that the entirety of an error output is brought in
    ;; so that matlab-shell-mode doesn't try to display a file that only partially
    ;; exists in the buffer.  Thus, if MATLAB output:
    ;;  error: /home/me/my/mo/mello.m,10,12
    ;; All of that is in the buffer, and it goes to mello.m, not just
    ;; the first half of that file name.
    ;; The below used to match against the prompt, not \n, but then text that
    ;; had error: in it for some other reason wouldn't display at all.
    (if (and matlab-prompt-seen ;; Don't collect during boot
	           (not frame) ;; don't collect debug stuff
	           (let ((start (string-match gud-matlab-marker-regexp-prefix gud-marker-acc)))
	             (and start
		                (not (string-match "\n" gud-marker-acc start))
		                ;;(not (string-match "^K?>>\\|\\?\\?\\?\\s-Error while evaluating" gud-marker-acc start))
		                )))
	      ;; We could be collecting something.  Wait for a while.
	      nil
      ;; Finish off this part of the output.  None of our special stuff
      ;; ends with a \n, so display those as they show up...
      (while (string-match "^[^\n]*\n" gud-marker-acc)
	      (setq output (concat output (substring gud-marker-acc 0 (match-end 0)))
	            gud-marker-acc (substring gud-marker-acc (match-end 0))))

      (setq output (concat output gud-marker-acc)
	          gud-marker-acc "")
      ;; Check our output for a prompt, and existence of a frame.
      ;; If t his is true, throw out the debug arrow stuff.
      (if (and (string-match "^>> $" output)
	             gud-last-last-frame)
	        (progn
	          (setq overlay-arrow-position nil
		              gud-last-last-frame nil
		              gud-overlay-arrow-position nil)
	          (sit-for 0)
	          )))

    (if frame (setq gud-last-frame frame))

    ;;(message "[%s] [%s]" output gud-marker-acc)

    output))
)
