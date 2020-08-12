;;; mouse scrolling mechanism
(cond ((eq system-type 'darwin )
       (setq mouse-wheel-progressive-speed t)

       (defun up-single () (interactive) (scroll-up 1))
       (defun up-double () (interactive) (scroll-up 2))
       (defun up-triple () (interactive) (scroll-up 3))
       (defun down-single () (interactive) (scroll-down 1))
       (defun down-double () (interactive) (scroll-down 2))
       (defun down-triple () (interactive) (scroll-down 3))

       (global-set-key [wheel-down] 'up-single)
       (global-set-key [double-wheel-down] 'up-double)
       (global-set-key [triple-wheel-down] 'up-triple)
       (global-set-key [wheel-up] 'down-single)
       (global-set-key [double-wheel-up] 'down-double)
       (global-set-key [triple-wheel-up] 'down-triple)))

;;; Grip-export (GFM-export)
(defun grip-export ()
  (interactive)
  (setq send-to-shell (format "grip %s --export --quiet" (buffer-name)))
  (setq file-to-open (format "file://%s.html" (file-name-sans-extension buffer-file-name)))
  (shell-command-to-string send-to-shell)
  (browse-url file-to-open))

;; custom function
(defun switch-to-minibuffer ()
  "Switch to minibuffer window."
  (interactive)
  (if (active-minibuffer-window)
      (select-window (active-minibuffer-window))
    (error "Minibuffer is not active")))

(global-set-key "\C-co" 'switch-to-minibuffer) ;; Bind to `C-c o'

;; browse rendered html
(defun browse-rendered-html ()
  (interactive)
  (setq file-to-open (format "file://%s.html" (file-name-sans-extension buffer-file-name)))
  (browse-url file-to-open))

;; TRAMP respect the PATH in the remote machine
(with-eval-after-load 'tramp
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

;; dired-listing-switches issue in TRAMP (manually change by 'C-u s' in dired)
;; Remote host does not understand default options for directory listing
;; Emacs computes the dired options based on the local host but if the remote host cannot understand the same ls command, then set them with a hook as follows:
(add-hook
 'dired-before-readin-hook
 (lambda ()
   (when (file-remote-p default-directory)
     (setq dired-actual-switches "-aBhlF"))))

;; enable impatient-mode when edit files in web-mode
;; M-x httpd-start, then http://localhost:8080/imp/
;; (add-hook 'impatient-mode 'web-mode)

;; Emacs server for windows
(if window-system
    (add-hook 'server-done-hook
              (lambda () (shell-command "stumpish 'eval (stumpwm::return-es-called-win stumpwm::*es-win*)'"))))

;; add project buffers to persp names
(defun spacemacs//add-project-buffers-to-persp (persp _persp-hash)
  (if-let ((buffers (and (projectile-project-p)
                         (projectile-project-buffers))))
      (persp-add-buffer buffers persp nil nil)))

  ;; Show the full path in the frame bar (title bar)
  ;; http://stackoverflow.com/questions/8945056/emacs-how-to-show-the-current-directory-in-the-frame-bar
  ;; (setq frame-title-format '(:eval (if (buffer-file-name) (abbreviate-file-name (buffer-file-name)) "%b")))

  ;; ;; Fewer garbage collection
  ;; ;; Number of bytes of consing between garbage collections.
  ;; (setq garbage-collection-messages nil)
  ;; ;; Set different gc-cons-threshold values depending on the context.
  ;; ;; http://bling.github.io/blog/2016/01/18/why-are-you-changing-gc-cons-threshold/
  ;; (defun set-gc-cons-threshold-max ()
  ;;   "Set gc-cons-threshold to maximum"
  ;;   (setq gc-cons-threshold most-positive-fixnum))
  ;; (set-gc-cons-threshold-max)

  ;; (defun set-gc-cons-threshold-normal (mb)
  ;;   "Set gc-cons-threshold in MB"
  ;;   (setq gc-cons-threshold (round (* mb 1000 1000))))
  ;; (add-hook 'after-init-hook #'(lambda () (set-gc-cons-threshold-normal 0.8)))
  ;; ;; (add-hook 'minibuffer-setup-hook #'set-gc-cons-threshold-max)
  ;; ;; (add-hook 'minibuffer-exit-hook #'(lambda () (set-gc-cons-threshold-normal 8)))
  ;; ;;
  ;; ;; GC on losing focus
  ;; ;; https://www.reddit.com/r/emacs/comments/4j828f/til_setq_gcconsthreshold_100000000/?st=j8t2pj66&sh=efe26f70
  ;; (add-hook 'focus-out-hook #'garbage-collect)

(provide 'misc-config)
;;; misc-config.el ends here
