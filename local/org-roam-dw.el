;;; ../Dropbox/emacs/.doom.d/local/org-roam-dw.el -*- lexical-binding: t; -*-

;;; org-roam
(after! org-roam
  (defun dw/org-roam-filter-by-tag (tag-name)
    (lambda (node)
      (member tag-name (org-roam-node-tags node))))

  (defun dw/org-roam-list-notes-by-tag (tag-name)
    (mapcar #'org-roam-node-file
            (seq-filter
             (dw/org-roam-filter-by-tag tag-name)
             (org-roam-node-list))))

  (defun dw/org-roam-refresh-agenda-list ()
    (interactive)
    (setq org-agenda-files (dw/org-roam-list-notes-by-tag "roadmap")))

  ;; Build the agenda list the first time for the session
  (dw/org-roam-refresh-agenda-list)

  (defun dw/org-roam-project-finalize-hook ()
    "Adds the captured project file to `org-agenda-files' if the
                  capture was not aborted."
    ;; Remove the hook since it was added temporarily
    (remove-hook 'org-capture-after-finalize-hook #'dw/org-roam-project-finalize-hook)

    ;; Add project file to the agenda list if the capture was confirmed
    (unless org-note-abort
      (with-current-buffer (org-capture-get :buffer)
        (add-to-list 'org-agenda-files (buffer-file-name)))))

  (defun dw/org-roam-find-project ()
    (interactive)
    ;; Add the project file to the agenda after capture is finished
    (add-hook 'org-capture-after-finalize-hook #'dw/org-roam-project-finalize-hook)

    ;; Select a project file to open, creating it if necessary
    (org-roam-node-find
     nil
     nil
     (dw/org-roam-filter-by-tag "roadmap")
     :templates
     '(("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
        :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+category: ${title}\n#+filetags: roadmap")
        :unnarrowed t))))

  ;; (defun dw/org-roam-capture-inbox ()
  ;;   (interactive)
  ;;   (org-roam-capture- :node (org-roam-node-create)
  ;;                      :templates '(("i" "inbox" plain "* %?"
  ;;                                    :if-new (file+head "Inbox.org" "#+title: Inbox\n")))))

  (defun dw/org-roam-capture-task ()
    (interactive)
    ;; Add the project file to the agenda after capture is finished
    (add-hook 'org-capture-after-finalize-hook #'dw/org-roam-project-finalize-hook)

    ;; Capture the new task, creating the project file if necessary
    (org-roam-capture- :node (org-roam-node-read
                              nil
                              (dw/org-roam-filter-by-tag "roadmap"))
                       :templates '(("p" "project" plain "** TODO %?"
                                     :if-new (file+head+olp "%<%Y%m%d%H%M%S>-${slug}.org"
                                                            "#+title: ${title}\n#+category: ${title}\n#+filetags: roadmap"
                                                            ("Tasks [/]")))))))
