;;; gptel-context-management.el --- Token-aware auto-compaction & sliding window for gptel -*- lexical-binding: t; -*-

;; Provides VS Code-style context management for gptel buffers.
;; Compaction triggers are based on estimated token usage relative to
;; the model's context window, not exchange counts.
;;
;; Chunking is exchange-aware: old text is split at complete exchange
;; boundaries (user prompt + assistant response + tool calls), not at
;; arbitrary character offsets.  Chunks are summarized sequentially,
;; not in parallel, to avoid rate-limiting.
;;
;; Set `gptel-context-management-strategy' to control behavior.

;;; Code:

(require 'gptel)

;;;; User options

(defgroup gptel-context-management nil
  "Context management strategies for gptel chat buffers."
  :group 'gptel
  :prefix "gptel-context-management-")

(defcustom gptel-context-management-strategy 'none
  "Strategy for managing gptel conversation context size.

Possible values:

  `none'           – Send full history every time (gptel default).
  `sliding-window' – Only send the last N exchanges (see
                     `gptel-context-window-size').  Old messages stay
                     in the buffer for reading but are not sent.
  `auto-compact'   – When estimated token usage exceeds a fraction of
                     the model's context window, summarize older text
                     via the LLM and replace it in-buffer.
  `both'           – Auto-compaction for context preservation, plus
                     sliding window as a safety cap."
  :type '(choice (const :tag "None (full history)" none)
                 (const :tag "Sliding window" sliding-window)
                 (const :tag "Auto-compact (LLM summary)" auto-compact)
                 (const :tag "Both (compact + window)" both))
  :group 'gptel-context-management)

(defcustom gptel-context-window-size 15
  "Number of recent exchanges to send when using the sliding-window strategy.
Each exchange is one user prompt + one LLM response."
  :type 'natnum
  :group 'gptel-context-management)

;; --- Token-based compaction knobs ---

(defcustom gptel-auto-compact-token-threshold 0.8
  "Fraction of the model's context window that triggers compaction.
When estimated token usage exceeds this ratio (0.0–1.0) of the
model's context window, auto-compaction fires.

For example, 0.8 means compact when ~80%% of the context window
is consumed."
  :type '(float :tag "Ratio (0.0–1.0)")
  :group 'gptel-context-management)

(defcustom gptel-auto-compact-keep-ratio 0.3
  "Fraction of the model's context window to keep as recent verbatim text.
During compaction, the most recent text worth this fraction of the
context window (in estimated tokens) is preserved as-is.  Older
text is summarized.

For example, 0.3 means keep ~30%% of the context window as recent
exchanges."
  :type '(float :tag "Ratio (0.0–1.0)")
  :group 'gptel-context-management)

(defcustom gptel-auto-compact-chars-per-token 3.5
  "Estimated characters per token for token-count heuristics.
This is a rough average.  English prose is ~4 chars/token; code
with symbols and short identifiers is closer to 3.  The default
of 3.5 is a reasonable middle ground."
  :type '(float :tag "Characters per token")
  :group 'gptel-context-management)

(defcustom gptel-auto-compact-context-window-fallback 128
  "Fallback context window size (in thousands of tokens).
Used when the current model does not have a `:context-window'
property.  128 means 128K tokens."
  :type 'natnum
  :group 'gptel-context-management)

;; --- Summarization knobs ---

(defcustom gptel-auto-compact-chunk-size 'auto
  "Target character count per chunk when summarizing old exchanges.
Old conversation text is split at exchange boundaries into chunks
of roughly this size.  Each chunk contains one or more complete
exchanges (user prompt + assistant response + tool calls).
A single exchange that exceeds this limit becomes its own chunk.

When set to `auto', the chunk size is computed dynamically as 40%
of the model's context window (in characters), with a floor of
30000 chars.  This reduces the number of sequential LLM calls for
models with large context windows.

A numeric value uses that fixed character count directly.
30000 chars ≈ 8.5K tokens."
  :type '(choice (const :tag "Auto (40% of context window)" auto)
                 (natnum :tag "Fixed character count"))
  :group 'gptel-context-management)

(defcustom gptel-auto-compact-summary-prompt
  "You are summarizing a segment of a long conversation for context continuity.
Domain: American Airlines loyalty data science (ML models, Databricks, Python, Org/Emacs workflows).

CRITICAL: Preserve high-value information needed for next exchanges:
- Workflow and execution sequence
- File paths, directories, and artifact locations (exact)
- Function/variable/class names and semantic intent
- Business context, domain assumptions, and rationale
- Decisions made (and why), constraints, and requirements
- Key metrics, run IDs, experiment IDs, and validation outcomes
- Error messages with actionable root-cause context
- Action items, TODOs, and unresolved risks/dependencies

Compression rules:
- Do NOT include raw tool output, long logs, or repetitive command traces unless critical to a decision or error diagnosis.
- Deduplicate aggressively; do not repeat the same fact in multiple sections.
- Keep exact identifiers (paths, symbols, IDs, config values) when they matter.
- [PRESERVED_N] markers: cite them inline only where directly relevant (e.g., \"see [PRESERVED_3]\"). Do NOT list or enumerate all markers. Do NOT say \"Preserved content markers: [PRESERVED_1]…[PRESERVED_N]\".

Output format (strict):
1) Objective & Scope (max 5 bullets)
2) Workflow & Decisions (max 8 bullets)
3) Files/Directories/Artifacts (max 10 bullets)
4) Key Findings & Metrics (max 8 bullets)
5) Open Items / Next Actions (max 8 bullets)

This summary will replace original text. Prefer compact, information-dense bullets.
Target ~60-75%% information retention at much lower verbosity.

Conversation segment to summarize:\n\n%s"
  "Prompt template for auto-compaction summaries.
Must contain one %s placeholder for the old conversation text.
When `gptel-auto-compact-preserve-anchors' is non-nil, the text
will contain [PRESERVED_N] markers in place of code blocks and
links."
  :type 'string
  :group 'gptel-context-management)

(defcustom gptel-auto-compact-backup-dir
  (expand-file-name "gptel-compaction-backups" temporary-file-directory)
  "Directory where full buffer contents are saved before compaction.
Each compaction saves the entire buffer to a timestamped file here
so you can recover if the summary is insufficient."
  :type 'directory
  :group 'gptel-context-management)

(defcustom gptel-auto-compact-preserve-anchors t
  "When non-nil, preserve structural anchors verbatim during compaction.
Structural anchors are code blocks and links whose exact content
must survive summarization (URLs, file paths, source code).

Before each chunk is sent to the LLM for summarization, anchors
are extracted and replaced with numbered placeholders.  After the
LLM returns its summary, the original anchors are appended in a
\"Preserved Content\" section.

Supported formats (detected from the buffer's `major-mode'):
- Org-mode: #+begin_src...#+end_src blocks, [[...]] links
- Markdown: fenced code blocks (```), [text](url), ![alt](url)
- Other modes: no anchors extracted (same as without this option)"
  :type 'boolean
  :group 'gptel-context-management)

;;;; Internal state

(defvar-local gptel-context-management--compact-in-progress nil
  "Non-nil when a compaction request is in-flight for this buffer.")

;;;; Token estimation helpers

(defun gptel-context-management--context-window-tokens ()
  "Return the current model's context window size in tokens.
Reads `:context-window' from the model symbol plist (value is in
thousands of tokens).  Falls back to
`gptel-auto-compact-context-window-fallback'."
  (let ((kilo (or (and (symbolp gptel-model)
                       (get gptel-model :context-window))
                  gptel-auto-compact-context-window-fallback)))
    (* kilo 1000)))

(defun gptel-context-management--estimate-tokens (&optional char-count)
  "Estimate token count for CHAR-COUNT characters.
If CHAR-COUNT is nil, use the current buffer's size."
  (let ((chars (or char-count (buffer-size))))
    (ceiling (/ (float chars) gptel-auto-compact-chars-per-token))))

;;;; Helpers

(defun gptel-context-management--count-exchanges-fallback ()
  "Heuristically estimate exchange count from plain text in saved logs.
Used when gptel text properties are unavailable (e.g., reopened Org files).

Strategy (in order):
1. If the buffer has a :GPTEL_BOUNDS: org property with response entries, count those.
2. Count role-labeled headings (User/Human/Assistant/AI/Model/System/Tool).
3. Returns nil when no role headings are found."
  (cl-block gptel-context-management--count-exchanges-fallback
    (save-excursion
      (save-restriction
        (widen)
        ;; Strategy 1: count response entries from GPTEL_BOUNDS property
        (goto-char (point-min))
        (when (derived-mode-p 'org-mode)
          (when-let* ((bounds-str (org-entry-get (point-min) "GPTEL_BOUNDS")))
            (condition-case nil
                (let* ((bounds (read bounds-str))
                       (response-entries (cdr (assq 'response bounds))))
                  (when (> (length response-entries) 0)
                    (cl-return-from gptel-context-management--count-exchanges-fallback
                      (length response-entries))))
              (error nil))))
        ;; Strategy 2: role-labeled headings
        (goto-char (point-min))
        (let ((assistant-count 0)
              (user-count 0))
          (while (re-search-forward
                  "^\\*+\\s-+\\(User\\|Human\\|Assistant\\|AI\\|Model\\|System\\|Tool\\)\\b"
                  nil t)
            (pcase (downcase (match-string 1))
              ((or "assistant" "ai" "model") (cl-incf assistant-count))
              ((or "user" "human") (cl-incf user-count))))
          (cond
           ((> assistant-count 0) assistant-count)
           ((> user-count 0) user-count)
           (t nil)))))))

(defun gptel-context-management--count-exchanges ()
  "Count exchanges in the current buffer.
Returns a plist: (:count N|nil :source SYMBOL), where SOURCE is one of
`props' (gptel text properties), `fallback' (heading heuristic), or `none'."
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      (let ((count 0))
        (while (text-property-search-forward 'gptel 'response t)
          (cl-incf count))
        (if (> count 0)
            (list :count count :source 'props)
          (let ((fallback (gptel-context-management--count-exchanges-fallback)))
            (if fallback
                (list :count fallback :source 'fallback)
              (list :count nil :source 'none))))))))

(defun gptel-context-management--find-split-point (keep-chars)
  "Return a marker at the split point, keeping KEEP-CHARS of recent text.
Searches forward from (point-max - keep-chars) to find a user-text
boundary (a position where `gptel' property is nil, indicating the
start of a user prompt).  This ensures we split between exchanges,
not in the middle of a response or tool call.
Returns nil if the buffer is too small to split meaningfully."
  (save-excursion
    (save-restriction
      (widen)
      (let* ((target-pos (max (point-min)
                              (- (point-max) keep-chars)))
             ;; Minimum old text we require to bother compacting
             (min-old-chars 500))
        ;; Don't split if target is near the beginning
        (when (> target-pos (+ (point-min) min-old-chars))
          (goto-char target-pos)
          ;; Walk forward to find a clean boundary: a position where
          ;; the gptel property is nil (user text), preceded by a
          ;; response/tool region.  This is the start of a user turn.
          (let ((boundary nil)
                (limit (point-max)))
            (while (and (null boundary) (< (point) limit))
              (let* ((next (next-single-property-change
                            (point) 'gptel nil limit))
                     (prop-at-next (and next (< next limit)
                                        (get-char-property next 'gptel))))
                (if (null next)
                    (setq limit (point)) ;stop
                  (if (null prop-at-next)
                      ;; Found a user-text region start — good split point
                      (when (> next (+ (point-min) min-old-chars))
                        (setq boundary next))
                    ;; Still in response/tool territory, keep walking
                    )
                  (goto-char next))))
            (when boundary
              (copy-marker boundary))))))))

;;;; Exchange-aware chunking

(defun gptel-context-management--find-boundaries-by-size (beg end)
  "Return chunk boundary positions between BEG and END sized by chunk-size.
Used as a fallback when no `gptel' text properties are present (e.g., a
saved and reopened file-backed buffer).  Splits at paragraph/line ends
nearest each chunk-size offset.  Always starts with BEG."
  (let* ((chunk-size (gptel-context-management--effective-chunk-size))
         (boundaries (list beg))
         (pos beg))
    (while (< (+ pos chunk-size) end)
      (let* ((target (+ pos chunk-size))
             (split
              (save-excursion
                (goto-char (min target end))
                (forward-line 0)
                ;; Prefer a blank-line (paragraph) boundary before target
                (or (save-excursion
                      (when (re-search-backward "^[ \t]*$" pos t)
                        (forward-line 1)
                        (when (> (point) pos) (point))))
                    (point)))))
        (push split boundaries)
        (setq pos split)))
    (nreverse boundaries)))

(defun gptel-context-management--find-exchange-boundaries (beg end)
  "Return a list of exchange boundary positions between BEG and END.
Each boundary is the start of a new \"turn\" — a position where the
`gptel' text property changes from a non-nil value (response/tool)
to nil (user text), or from nil to non-nil.

An exchange is: user-text (gptel=nil) → response (gptel=response)
→ optional tool calls (gptel=(tool . id)).  The next user-text
starts a new exchange.

When no `gptel' text properties are found (e.g., a saved and reopened
file-backed buffer), falls back to splitting at paragraph/heading
boundaries aligned to `gptel-auto-compact-chunk-size'.

Returns a sorted list of positions, always starting with BEG."
  (save-excursion
    (save-restriction
      (widen)
      (goto-char beg)
      (let ((boundaries (list beg))
            (prev-was-user (null (get-char-property beg 'gptel))))
        (while (< (point) end)
          (let ((next (next-single-property-change (point) 'gptel nil end)))
            (if (or (null next) (>= next end))
                (goto-char end)         ;done
              (goto-char next)
              (let ((now-user (null (get-char-property next 'gptel))))
                (when (and now-user (not prev-was-user))
                  (push next boundaries))
                (setq prev-was-user now-user)))))
        ;; Fallback: if no property-based boundaries found, split by
        ;; chunk-size at paragraph/line boundaries so chunk-size is honored.
        (if (= (length boundaries) 1)
            (gptel-context-management--find-boundaries-by-size beg end)
          (nreverse boundaries))))))

(defun gptel-context-management--group-exchanges-into-chunks (boundaries end max-chunk-size)
  "Group exchange BOUNDARIES into chunks, each ≤ MAX-CHUNK-SIZE chars.
BOUNDARIES is a sorted list of exchange-start positions (from
`gptel-context-management--find-exchange-boundaries').
END is the end of the compactable region.

Returns a list of (START . END) cons cells, one per chunk.
Each chunk spans one or more complete exchanges.  A single
exchange larger than MAX-CHUNK-SIZE becomes its own chunk."
  (when boundaries
    (let ((chunks nil)
          (chunk-start (car boundaries))
          (rest (cdr boundaries)))
      (while rest
        (let ((next-boundary (car rest)))
          (if (> (- next-boundary chunk-start) max-chunk-size)
              ;; Current chunk is big enough (or single exchange exceeds limit).
              ;; Close it at the previous boundary.
              (let ((chunk-end next-boundary))
                (push (cons chunk-start chunk-end) chunks)
                (setq chunk-start next-boundary))
            ;; Keep accumulating
            )
          (setq rest (cdr rest))))
      ;; Final chunk: from chunk-start to end
      (push (cons chunk-start end) chunks)
      (nreverse chunks))))

(defun gptel-context-management--effective-chunk-size ()
  "Return the effective chunk size in characters.
When `gptel-auto-compact-chunk-size' is `auto', compute 40% of the
model's context window (in chars), floored at 30000.  Otherwise
return the numeric value directly."
  (if (eq gptel-auto-compact-chunk-size 'auto)
      (let* ((context-tokens (gptel-context-management--context-window-tokens))
             (context-chars (* context-tokens gptel-auto-compact-chars-per-token))
             (dynamic (ceiling (* 0.4 context-chars))))
        (max 30000 dynamic))
    gptel-auto-compact-chunk-size))

(defun gptel-context-management--extract-chunks (beg end)
  "Extract exchange-aware text chunks from buffer region BEG to END.
Returns a list of strings, each containing one or more complete
exchanges grouped to roughly `gptel-auto-compact-chunk-size' chars."
  (let* ((chunk-size (gptel-context-management--effective-chunk-size))
         (boundaries (gptel-context-management--find-exchange-boundaries beg end))
         (groups (gptel-context-management--group-exchanges-into-chunks
                  boundaries end chunk-size)))
    (mapcar (lambda (group)
              (buffer-substring-no-properties (car group) (cdr group)))
            groups)))

;;;; Backup

(defun gptel-context-management--backup-buffer ()
  "Save the full buffer contents to a backup file.
Returns the backup file path."
  (unless (file-directory-p gptel-auto-compact-backup-dir)
    (make-directory gptel-auto-compact-backup-dir t))
  (let* ((buf-name (replace-regexp-in-string
                    "[^a-zA-Z0-9_-]" "_"
                    (buffer-name)))
         (backup-file (expand-file-name
                       (format "%s_%s.txt"
                               buf-name
                               (format-time-string "%Y%m%d-%H%M%S"))
                       gptel-auto-compact-backup-dir)))
    (save-restriction
      (widen)
      (write-region (point-min) (point-max) backup-file))
    backup-file))

;;;; Structural anchor extraction

(defun gptel-context-management--anchor-block-patterns (mode)
  "Return block-anchor patterns for major MODE.
Each entry is (START-REGEXP . END-REGEXP) for a multi-line block
that should be preserved verbatim (e.g., code blocks).
START-REGEXP and END-REGEXP are matched at beginning of line."
  (cond
   ((derived-mode-p 'org-mode)
    '(("^[ \t]*#\\+begin_src\\b" . "^[ \t]*#\\+end_src\\b")
      ("^[ \t]*#\\+begin_example\\b" . "^[ \t]*#\\+end_example\\b")))
   ((derived-mode-p 'markdown-mode 'gfm-mode)
    '(("^[ \t]*```" . "^[ \t]*```[ \t]*$")))
   (t nil)))

(defun gptel-context-management--anchor-inline-patterns (mode)
  "Return inline-anchor regexps for major MODE.
Each entry is a regexp matching a single inline anchor (e.g., a
link) that should be preserved verbatim."
  (cond
   ((derived-mode-p 'org-mode)
    ;; [[target]] or [[target][description]]
    ;; Real org link targets never contain '[', '"', or "'".
    ;; Excluding '"' and "'" prevents matching Python/Lisp list literals
    ;; like [["col","val"]] or [['col','val']] that appear in LLM output.
    '("\\[\\[[^][\"'\n]+\\]\\(?:\\[[^]\n]*\\]\\)?\\]"))
   ((derived-mode-p 'markdown-mode 'gfm-mode)
    ;; [text](url) and ![alt](url)
    '("!?\\[[^]\n]*\\]([^)\n]*)"))
   (t nil)))

(defun gptel-context-management--extract-anchors (chunk-string mode)
  "Extract structural anchors from CHUNK-STRING for major MODE.
Returns a cons cell (STRIPPED-TEXT . ANCHORS) where:
- STRIPPED-TEXT has anchors replaced with [PRESERVED_N] markers
- ANCHORS is a list of original anchor strings (in order)
If no anchors are found or MODE has no patterns, returns
\(CHUNK-STRING . nil)."
  (if (not gptel-auto-compact-preserve-anchors)
      (cons chunk-string nil)
    (let ((block-pats (gptel-context-management--anchor-block-patterns mode))
          (inline-pats (gptel-context-management--anchor-inline-patterns mode))
          (anchors nil)
          (counter 0))
      (if (and (null block-pats) (null inline-pats))
          (cons chunk-string nil)
        ;; Use a temp buffer for reliable multi-line matching
        (with-temp-buffer
          (insert chunk-string)
          ;; 1) Extract block anchors (code blocks etc.)
          (dolist (pat block-pats)
            (goto-char (point-min))
            (let ((start-re (car pat))
                  (end-re (cdr pat)))
              (while (re-search-forward start-re nil t)
                (let ((block-beg (match-beginning 0)))
                  (when (re-search-forward end-re nil t)
                    (let* ((block-end (line-end-position))
                           (block-text (buffer-substring-no-properties
                                        block-beg block-end)))
                      (cl-incf counter)
                      (push block-text anchors)
                      (delete-region block-beg block-end)
                      (goto-char block-beg)
                      (insert (format "[PRESERVED_%d]" counter))))))))
          ;; 2) Extract inline anchors (links, images)
          (dolist (re inline-pats)
            (goto-char (point-min))
            (while (re-search-forward re nil t)
              (let ((anchor-text (match-string 0)))
                (cl-incf counter)
                (push anchor-text anchors)
                (replace-match (format "[PRESERVED_%d]" counter) t t))))
          (cons (buffer-string) (nreverse anchors)))))))

(defun gptel-context-management--format-anchors (anchors mode)
  "Format preserved ANCHORS list as a section string for MODE."
  (when anchors
    (let ((header (if (derived-mode-p 'org-mode)
                      "** Preserved Content\n\n"
                    "### Preserved Content\n\n")))
      (concat
       "\n\n" header
       (cl-loop for a in anchors
                for n from 1
                ;; Keep plain markers to avoid introducing broken internal links.
                collect (format "[PRESERVED_%d]\n%s" n a)
                into blocks
                finally return (mapconcat #'identity blocks "\n\n"))))))

(defun gptel-context-management--normalize-preserved-refs (text)
  "Normalize preserved-reference links in TEXT to plain markers.
Converts link-like forms such as [[PRESERVED_3]], [[#PRESERVED_3]],
and [[PRESERVED_3][...]] into plain [PRESERVED_3] markers.
Also unwraps file/link wrappers around preserved markers, e.g.
[[file:...][PRESERVED_3]] -> [PRESERVED_3]."
  (let ((s text))
    (setq s
          (replace-regexp-in-string
           "\\[\\[\\(?:#\\)?PRESERVED_\\([0-9]+\\)\\]\\(?:\\[[^]\\n]*\\]\\)?\\]"
           "[PRESERVED_\\1]"
           s t nil))
    (setq s
          (replace-regexp-in-string
           "\\[\\[[^]\\n]+\\]\\[PRESERVED_\\([0-9]+\\)\\]\\]"
           "[PRESERVED_\\1]"
           s t nil))
    s))

(defun gptel-context-management--append-anchors (summary anchors mode)
  "Append preserved ANCHORS to SUMMARY text for major MODE.
Returns the combined string, or SUMMARY unchanged if ANCHORS is nil."
  (if (null anchors)
      (gptel-context-management--normalize-preserved-refs summary)
    (concat (gptel-context-management--normalize-preserved-refs summary)
            (gptel-context-management--format-anchors anchors mode))))

;;;; Model selection helper

(defun gptel-context-management--read-backend-model (prompt)
  "Prompt the user to select a backend+model and return a cons (BACKEND . MODEL).
PROMPT is the completing-read prompt string."
  (let* ((models-alist
          (cl-loop for (name . backend) in gptel--known-backends
                   nconc (cl-loop for model in (gptel-backend-models backend)
                                  collect (list (concat name ":"
                                                        (gptel--model-name model))
                                                backend model)))))
    (let* ((default (concat (gptel-backend-name gptel-backend) ":"
                            (gptel--model-name gptel-model)))
           (choice (completing-read prompt models-alist nil t nil nil default))
           (entry (assoc choice models-alist)))
      (cons (nth 1 entry) (nth 2 entry)))))

;;;; Sequential summarization

(defun gptel-context-management--summarize-sequentially
    (chunks idx summaries buffer split-marker
            total-exchanges estimated-tokens backup-file
            backend model callback)
  "Summarize CHUNKS one at a time, starting at index IDX.
SUMMARIES is a list (in reverse order) of completed summaries.
BUFFER is the chat buffer.  SPLIT-MARKER, TOTAL-EXCHANGES,
ESTIMATED-TOKENS, and BACKUP-FILE are for the final header.
BACKEND and MODEL are the gptel backend/model to use for
summarization requests.
CALLBACK is called with the combined summary string on success,
or nil on failure.

Each summarization request is sent from a temporary buffer so that
gptel does not inject the chat buffer's full conversation history.

When `gptel-auto-compact-preserve-anchors' is non-nil, structural
anchors (code blocks, links) are extracted before summarization
and re-appended to the LLM's summary verbatim."
  (if (>= idx (length chunks))
      ;; All chunks done — combine and deliver
      (funcall callback (mapconcat #'identity (nreverse summaries) "\n\n"))
    ;; Summarize the next chunk from a temp buffer
    (let* ((chunk (nth idx chunks))
           (total (length chunks))
           ;; Extract anchors from the chunk (uses buffer's major-mode)
           (buf-mode (buffer-local-value 'major-mode buffer))
           (extraction (with-temp-buffer
                         (funcall buf-mode)
                         (gptel-context-management--extract-anchors chunk buf-mode)))
           (stripped-chunk (car extraction))
           (anchors (cdr extraction)))
      (message "gptel: summarizing chunk %d/%d%s..."
               (1+ idx) total
               (if anchors (format " (%d anchors preserved)" (length anchors)) ""))
      (let ((temp-buf (generate-new-buffer " *gptel-compact-request*"))
            (prompt (format gptel-auto-compact-summary-prompt stripped-chunk)))
        (with-current-buffer temp-buf
          (setq-local gptel-backend backend)
          (setq-local gptel-model model)
          (setq-local gptel-use-tools nil))
        (gptel-request prompt
         :buffer temp-buf
         :system "You are a senior ML/data-science assistant helping an American Airlines loyalty DS. Summarize for long-term continuity. Preserve workflow, decisions, file paths, exact identifiers (paths, IDs, config values), business context, and actionable errors. Aggressively compress logs and tool output. When the text contains [PRESERVED_N] markers, cite them by marker only — do NOT describe or re-list their content inline."
         :callback
         (lambda (response info)
           ;; Clean up temp buffer
           (when-let* ((tb (plist-get info :buffer)))
             (when (buffer-live-p tb)
               (kill-buffer tb)))
           (cond
            ;; Chat buffer was killed while we were waiting
            ((not (buffer-live-p buffer))
             (message "gptel: compaction aborted — buffer killed"))
            ;; Streaming end marker — ignore, wait for real content
            ((eq response t) nil)
            ;; Reasoning block — ignore
            ((and (consp response) (eq (car response) 'reasoning)) nil)
            ;; Abort signal
            ((eq response 'abort)
             (message "gptel: compaction aborted at chunk %d/%d: request aborted"
                      (1+ idx) total)
             (with-current-buffer buffer
               (setq gptel-context-management--compact-in-progress nil))
             (funcall callback nil))
            ;; Actual string response — success
            ((stringp response)
             (let ((final-summary
                    (gptel-context-management--append-anchors
                     response anchors buf-mode)))
               (gptel-context-management--summarize-sequentially
                chunks (1+ idx) (cons final-summary summaries)
                buffer split-marker
                total-exchanges estimated-tokens backup-file
                backend model callback)))
            ;; Anything else (error, tool-call, etc.) — fail
            (t
             (message "gptel: compaction aborted at chunk %d/%d: %s"
                      (1+ idx) total
                      (or (plist-get info :status) "unexpected response"))
             (with-current-buffer buffer
               (setq gptel-context-management--compact-in-progress nil))
             (funcall callback nil))))
         :stream nil
         :in-place nil)))))

;;;; Compaction engine

(defun gptel-context-management--do-compact (&optional backend model)
  "Summarize older text based on token-budget, keeping recent text verbatim.
Chunks are exchange-aware and processed sequentially.
Optional BACKEND and MODEL override the buffer's current backend/model for
the summarization requests."
  (let* ((context-tokens (gptel-context-management--context-window-tokens))
         (estimated-tokens (gptel-context-management--estimate-tokens))
         (exchange-info (gptel-context-management--count-exchanges))
         (total-exchanges (plist-get exchange-info :count))
         (exchange-source (plist-get exchange-info :source))
         (keep-chars (ceiling (* context-tokens
                                gptel-auto-compact-keep-ratio
                                gptel-auto-compact-chars-per-token)))
         (split-marker (gptel-context-management--find-split-point keep-chars))
         (old-beg (point-min))
         (old-end (when split-marker (marker-position split-marker))))
    (if (or (null split-marker) (null old-end)
            (<= (- old-end old-beg) 500))
        (progn
          (setq gptel-context-management--compact-in-progress nil)
          (message "gptel: compaction skipped — not enough old text to summarize"))
      (setq gptel-context-management--compact-in-progress t)
      ;; Backup first
      (let ((backup-file (gptel-context-management--backup-buffer)))
        ;; Extract exchange-aware chunks from the old region
        (let* ((chunks (gptel-context-management--extract-chunks old-beg old-end))
               (buf (current-buffer))
               (marker split-marker)
               (be (or backend gptel-backend))
               (mo (or model gptel-model)))
          (message "gptel: compacting ~%dK tokens (%.0f%% of %dK window) in %d chunks — backup: %s"
                   (/ estimated-tokens 1000)
                   (* 100.0 (/ (float estimated-tokens) context-tokens))
                   (/ context-tokens 1000)
                   (length chunks)
                   backup-file)
          (if (null chunks)
              (progn
                (setq gptel-context-management--compact-in-progress nil)
                (message "gptel: compaction skipped — no exchange boundaries found in old text"))
            (gptel-context-management--summarize-sequentially
             chunks 0 nil buf marker
             total-exchanges estimated-tokens backup-file
             be mo
             (lambda (combined-summary)
               (when (buffer-live-p buf)
                 (with-current-buffer buf
                   (setq gptel-context-management--compact-in-progress nil)
                   (if (null combined-summary)
                       (message "gptel: compaction failed — buffer unchanged (backup: %s)"
                                backup-file)
                     (save-excursion
                       (widen)
                       (let* ((old-size (- (marker-position marker) (point-min)))
                              (old-tokens (gptel-context-management--estimate-tokens old-size))
                              (summary-tokens (gptel-context-management--estimate-tokens
                                               (length combined-summary))))
                         (delete-region (point-min) marker)
                         (goto-char (point-min))
                         (insert
                          (propertize
                           (format
                            "*** Conversation Summary ***\n\
Compacted ~%dK → ~%dK tokens (%s, %d chunks)\n\
Backup: %s\n\n\
%s\n\n---\n\n"
                            (/ old-tokens 1000)
                            (/ summary-tokens 1000)
                            (pcase exchange-source
                              ('props (format "%d exchanges summarized"
                                              (or total-exchanges 0)))
                              ('fallback (format "~%d exchanges estimated"
                                                 (or total-exchanges 0)))
                              (_ "exchange count unavailable"))
                            (length chunks)
                            backup-file
                            combined-summary)
                           'gptel 'response
                           'face 'font-lock-comment-face))
                         (message "gptel: compaction complete — %dK → %dK tokens (%d chunks, backup: %s)"
                                  (/ old-tokens 1000)
                                  (/ summary-tokens 1000)
                                  (length chunks)
                                  backup-file))))))))))))))

;;;; Post-response hook dispatcher

(defun gptel-context-management--post-response (_beg _end)
  "Maybe trigger auto-compaction after an LLM response.
Compares estimated buffer tokens against the model's context window.
Only auto-triggers in non-file buffers (temp/dedicated chat buffers).
For file-backed buffers, use `gptel-compact' to trigger manually.
Intended for `gptel-post-response-functions'."
  (when (and gptel-mode
             (not (buffer-file-name))   ;never auto-compact file buffers
             (not gptel-context-management--compact-in-progress)
             (memq gptel-context-management-strategy '(auto-compact both)))
    (let* ((context-tokens (gptel-context-management--context-window-tokens))
           (threshold-tokens (* context-tokens gptel-auto-compact-token-threshold))
           (estimated-tokens (gptel-context-management--estimate-tokens)))
      (when (> estimated-tokens threshold-tokens)
        (message "gptel: estimated %dK tokens exceeds %.0f%% of %dK context window — compacting..."
                 (/ estimated-tokens 1000)
                 (* 100.0 gptel-auto-compact-token-threshold)
                 (/ context-tokens 1000))
        (gptel-context-management--do-compact)))))

;;;; Strategy application

(defun gptel-context-management--apply-strategy ()
  "Apply the current `gptel-context-management-strategy' to this buffer.
Sets `gptel--num-messages-to-send' and ensures the hook is active."
  (pcase gptel-context-management-strategy
    ('none
     (setq-local gptel--num-messages-to-send nil))
    ('sliding-window
     (setq-local gptel--num-messages-to-send gptel-context-window-size))
    ('auto-compact
     (setq-local gptel--num-messages-to-send nil))
    ('both
     (setq-local gptel--num-messages-to-send gptel-context-window-size))))

;;;; Interactive commands

;;;###autoload
(defun gptel-set-context-strategy ()
  "Interactively choose a context management strategy for the current gptel buffer."
  (interactive)
  (let* ((context-tokens (gptel-context-management--context-window-tokens))
         (estimated-tokens (gptel-context-management--estimate-tokens))
         (usage-pct (if (> context-tokens 0)
                        (* 100.0 (/ (float estimated-tokens) context-tokens))
                      0))
         (choices '(("none (full history)" . none)
                    ("sliding-window (last N exchanges)" . sliding-window)
                    ("auto-compact (LLM summary)" . auto-compact)
                    ("both (compact + window)" . both)))
         (choice (completing-read
                  (format "Context strategy [current: %s | ~%dK/%dK tokens (%.0f%%)]: "
                          gptel-context-management-strategy
                          (/ estimated-tokens 1000)
                          (/ context-tokens 1000)
                          usage-pct)
                  (mapcar #'car choices)
                  nil t))
         (strategy (cdr (assoc choice choices))))
    (setq-local gptel-context-management-strategy strategy)
    (gptel-context-management--apply-strategy)
    (message "gptel context strategy: %s" strategy)))

;;;###autoload
(defun gptel-compact (&optional choose-model)
  "Manually trigger compaction of the current gptel buffer.
For file-backed buffers, asks for confirmation first.
For non-file buffers, runs immediately.
This command works regardless of `gptel-context-management-strategy'.

With a prefix argument CHOOSE-MODEL (\\[universal-argument]), prompt for a
backend and model to use for the summarization requests instead of the
buffer's current model."
  (interactive "P")
  (unless gptel-mode
    (user-error "Not a gptel buffer"))
  (when gptel-context-management--compact-in-progress
    (user-error "Compaction already in progress"))
  (let* ((context-tokens (gptel-context-management--context-window-tokens))
         (estimated-tokens (gptel-context-management--estimate-tokens))
         (usage-pct (if (> context-tokens 0)
                        (* 100.0 (/ (float estimated-tokens) context-tokens))
                      0))
         (file-p (buffer-file-name))
         ;; Optionally pick a different backend+model for summarization
         (compact-backend gptel-backend)
         (compact-model gptel-model))
    (when choose-model
      (cl-destructuring-bind (b . m)
          (gptel-context-management--read-backend-model
           "Compact using model: ")
        (setq compact-backend b
              compact-model m)))
    (let ((free-models '(gpt-4o gpt-5-mini)))
      (unless (memq compact-model free-models)
        (unless (yes-or-no-p
                 (format "Model %s may incur cost. Continue compaction? "
                         compact-model))
          (user-error "Compaction canceled"))))
    (when (or (not file-p)
              (yes-or-no-p
               (format "Compact file buffer %s? (~%dK/%dK tokens, %.0f%%) This will modify the buffer. "
                       (buffer-name)
                       (/ estimated-tokens 1000)
                       (/ context-tokens 1000)
                       usage-pct)))
      (gptel-context-management--do-compact compact-backend compact-model))))

;;;###autoload
(defun gptel-context-usage ()
  "Display current token usage estimate for this gptel buffer."
  (interactive)
  (let* ((context-tokens (gptel-context-management--context-window-tokens))
         (estimated-tokens (gptel-context-management--estimate-tokens))
         (exchanges (gptel-context-management--count-exchanges))
         (usage-pct (if (> context-tokens 0)
                        (* 100.0 (/ (float estimated-tokens) context-tokens))
                      0))
         (threshold-pct (* 100.0 gptel-auto-compact-token-threshold)))
    (message "gptel: ~%dK/%dK tokens (%.1f%%) | %d exchanges | model: %s | strategy: %s | compacts at: %.0f%%"
             (/ estimated-tokens 1000)
             (/ context-tokens 1000)
             usage-pct
             exchanges
             gptel-model
             gptel-context-management-strategy
             threshold-pct)))

;;;; Initialization

;; Apply strategy when gptel-mode is activated
(add-hook 'gptel-mode-hook #'gptel-context-management--apply-strategy)

;; Always register the post-response hook; the function itself checks the strategy
(add-hook 'gptel-post-response-functions #'gptel-context-management--post-response)

(provide 'gptel-context-management)
;;; gptel-context-management.el ends here
