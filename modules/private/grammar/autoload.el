;;;###autoload
(defun jyun/langtool-goto-next-error (count)
  (interactive "p")
  (dotimes (_ count) (langtool-goto-next-error))
  (when languagetool-show-error-on-jump (langtool-show-message-at-point)))

;;;###autoload
(defun jyun/langtool-goto-previous-error (count)
  (interactive "p")
  (dotimes (_ count) (langtool-goto-previous-error))
  (when languagetool-show-error-on-jump (langtool-show-message-at-point)))

;;;###autoload
(defun langtool-autoshow-force-message (overlays)
  ;; Interrupt current message
  (let ((msg (langtool-simple-error-message overlays)))
    (message "%s" msg)))

;;;###autoload
(defun langtool-autoshow-detail-popup (overlays)
  (when (require 'popup nil t)
    ;; Do not interrupt current popup
    (unless (or popup-instances
                ;; suppress popup after type `C-g` .
                (memq last-command '(keyboard-quit)))
      (let ((msg (langtool-details-error-message overlays)))
        (popup-tip msg)))))

;;; posframe

;;;###autoload
(defun langtool-posframe-show-posframe (errors)
  "Display ERRORS, using posframe.el library."
  (posframe-hide langtool-posframe-buffer)
  (when (and errors
             (not (run-hook-with-args-until-success 'langtool-posframe-inhibit-functions)))
    (let ((poshandler (intern (format "posframe-poshandler-%s" langtool-posframe-position))))
      (unless (functionp poshandler)
        (setq poshandler nil))
      (langtool-posframe-check-position)
      (posframe-show
       langtool-posframe-buffer
       :string (langtool-posframe-format-error errors)
       :background-color (face-background 'langtool-posframe-background-face nil t)
       :position (point)
       :internal-border-width langtool-posframe-border-width
       :internal-border-color (face-foreground 'langtool-posframe-border-face nil t)
       :poshandler poshandler
       :left-fringe 4
       :right-fringe 4
       :lines-truncate t
       :hidehandler #'langtool-posframe-hidehandler))))

;;;###autoload
(defun jyun/langtool-details-error-message (overlays)
  "Textify error messages."
  (mapconcat
   (lambda (ov)
     (concat
      (format "%s\n"
              (overlay-get ov 'langtool-simple-message))
      (if (overlay-get ov 'langtool-suggestions)
          (concat
           "Suggestions: ["
           (mapconcat
            'identity
            (overlay-get ov 'langtool-suggestions)
            "; ") "] ")
        "")
      (format "[%s]"
              (overlay-get ov 'langtool-rule-id))
      ))
   overlays
   "\n\n"))

;;;###autoload
(defun langtool-posframe-format-error (err)
  "Formats ERR for display."
  (propertize (concat "! "
                      (jyun/langtool-details-error-message err))
              'face
              `(:inherit 'warning)))

;;;###autoload
(defun langtool-posframe-check-position ()
  "Update langtool-posframe-last-position, returning t if there was no change."
  (equal langtool-posframe-last-position
         (setq langtool-posframe-last-position
               (list (current-buffer) (buffer-modified-tick) (point)))))

;;;###autoload
(defun langtool-posframe-hidehandler (_info)
  "Hide posframe if position has changed since last display."
  (not (langtool-posframe-check-position)))

;;;; posframe variables
(defcustom langtool-posframe-inhibit-functions nil
  "Functions to inhibit display of flycheck posframe."
  :type 'hook
  :group 'langtool-posframe)

(defcustom langtool-posframe-position 'point-bottom-left-corner
  "Where to position the langtool-posframe frame."
  :group 'langtool-posframe
  :type '(choice
          (const :tag "Center of the frame" frame-center)
          (const :tag "Centered at the top of the frame" frame-top-center)
          (const :tag "Left corner at the top of the frame" frame-top-left-corner)
          (const :tag "Right corner at the top of the frame" frame-top-right-corner)
          (const :tag "Left corner at the bottom of the frame" frame-bottom-left-corner)
          (const :tag "Right corner at the bottom of the frame" frame-bottom-right-corner)
          (const :tag "Center of the window" window-center)
          (const :tag "Left corner at the top of the window" window-top-left-corner)
          (const :tag "Right corner at the top of the window" window-top-right-corner)
          (const :tag "Left corner at the bottom of the window" window-bottom-left-corner)
          (const :tag "Right corner at the bottom of the window" window-bottom-right-corner)
          (const :tag "Top left corner of point" point-top-left-corner)
          (const :tag "Bottom left corner of point" point-bottom-left-corner)))

(defcustom langtool-posframe-border-width 1
  "Width of the border for a langtool-posframe frame."
  :group 'langtool-posframe
  :type 'integer)

(defface langtool-posframe-background-face
  '((t))
  "The background color of the langtool-posframe frame.
Only the `background' is used in this face."
  :group 'langtool-posframe)

(defface langtool-posframe-border-face
  '((t (:inherit default :background "gray50")))
  "The border color of the langtool-posframe frame.
Only the `foreground' is used in this face."
  :group 'langtool-posframe)

(defvar langtool-posframe-buffer "*langtool-posframe-buffer*"
  "The posframe buffer name use by langtool-posframe.")

(defvar langtool-posframe-last-position nil
  "Last position for which a langtool posframe was displayed.")
