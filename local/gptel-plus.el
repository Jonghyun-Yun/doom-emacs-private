;;; ../Dropbox/emacs/.doom.d/local/gptel-plus.el -*- lexical-binding: t; -*-

;; llm
(after! gptel
  (require 'gptel-integrations)
  (require 'gptel-org)
  (setq! gptel-track-media t
         ;; gptel-preset "agent-mode"
         gptel-use-tools t
         gptel-default-mode 'org-mode
         ;; gptel-model 'gpt-5.2
         gptel-model 'claude-haiku-4.5
         ;; gptel-model 'claude-sonnet-4.6
         ;; gptel-model 'claude-opus-4.6
         ;; gptel-model 'claude-opus-4.7
         gptel-backend (gptel-make-gh-copilot "Copilot")
         ;; Tool confirm set via jyun/gptel-confirm-tool-calls-fn (see below)
         gptel-confirm-tool-calls nil  ; placeholder, overridden after load         
         )

  (map! (:map gptel-mode-map
         :desc "New commit with a generated message"
         :leader "olg" #'gptel-magit-commit-generate))
  (after! magit
    ;; free model
    (setq gptel-magit-model 'gpt-5-mini)
  )

  (after! gptel-quick
    (setq gptel-quick-backend nil
          gptel-quick-model 'gpt-5-mini)
    )
)

(use-package! gptel-agent
  :after gptel
  :config (gptel-agent-update)
  )  

(use-package! llm-tool-collection
  :after gptel
  :config
  (mapcar (apply-partially #'apply #'gptel-make-tool)
          (llm-tool-collection-get-all))
)

;; (use-package! gptel-got
;;   :after gptel
;;   :config
;;   (mapcar (lambda (tool) (cl-pushnew tool gptel-tools)) gptel-got)
;;   )


(defun jyun/get-ado-token ()
  "Get Azure DevOps access token via az CLI."
  (string-trim
   (shell-command-to-string
    "az account get-access-token --resource 499b84ac-1321-427f-aa17-267ca6975798 --query accessToken -o tsv")))

(use-package mcp
  :after gptel
  :config (require 'mcp-hub)
  ;; :hook (after-init . mcp-hub-start-all-server)
  :custom
  (mcp-hub-servers
   `(
     ;; --- current setup (commented out for reference) -----------------------
     ;; ("duckduckgo" . (:command "uvx" :args ("duckduckgo-mcp-server")))
     ;; ("fetch" . (:command "uvx" :args ("mcp-server-fetch")))
     ;; ("excel" . (:command "uvx" :args ("excel-mcp-server" "stdio")))
     ;; ("markitdown" . (:command "uvx" :args ("markitdown-mcp")))
     ;; ("playwright" . (:command "npx" :args ("-y" "@playwright/mcp@latest")))
     
     ;; --- keep existing non-uvx servers as-is -------------------------------
     ;; ("github" . (:command "docker"
     ;;              :args ("run" "-i" "--rm"
     ;;                     "-e" "github_personal_access_token"
     ;;                     "ghcr.io/github/github-mcp-server")
     ;;              :env (:github_personal_access_token ,(jyun/get-github-token))))

     ("azure-devops" . (:command "npx"
                     :args ("-y" "@azure-devops/mcp" ,jyun/ado-org
                             "-d" "core" "work" "work-items" "search"
                             "repositories" "pipelines")
                     :env (:ADO_MCP_AUTH_TOKEN ,(jyun/get-ado-token))))

     ;; ("azure-devops" . (:command "npx"
     ;;             :args ("-y" "@azure-devops/mcp" ,jyun/ado-org
     ;;                     "--authentication" "envvar"
     ;;                     "-d" "core" "work" "work-items" "repositories" "pipelines")
     ;;             :env (:ADO_MCP_AUTH_TOKEN ,(jyun/get-ado-token))))

     ("github" . (:command "github-mcp-server"
                  :args ("stdio" "--log-file" ,(expand-file-name "logs/github-mcp.log" (getenv "home")))
                  :env (:GITHUB_PERSONAL_ACCESS_TOKEN ,(jyun/get-github-token))
                  ))
     ;; ("filesystem" . (:command "npx"
     ;;                  :args ("-y" "@modelcontextprotocol/server-filesystem"
     ;;                         ,(getenv "home"))))
     ("sequential-thinking" . (:command "npx"
                               :args ("-y" "@modelcontextprotocol/server-sequential-thinking")))
     ;; ("context7" . (:command "npx"
     ;;                :args ("-y" "@upstash/context7-mcp")
     ;;                :env (:default_minimum_tokens "6000")))
     ;; ("nixos" . (:command "uvx" :args ("mcp-nixos")))

     ("context7" . (:command "context7-mcp"
                    :env (:default_minimum_tokens "6000")))

     ;; --- mamba env-based mcp servers (gptel conda env) ---------------------
     ;; prefer calling the console script via `mamba run -n gptel ...`
     ;; ("duckduckgo" . (:command "mamba"
     ;;                  :args ("run" "-n" "gptel" "duckduckgo-mcp-server")))
     ;; ("fetch" . (:command "mamba"
     ;;             :args ("run" "-n" "gptel" "mcp-server-fetch")))
     ;; ("excel" . (:command "mamba"
     ;;             :args ("run" "-n" "gptel" "excel-mcp-server" "stdio")))
     ("markitdown" . (:command "mamba"
                      :args ("run" "-n" "gptel" "markitdown-mcp")))

     ("playwright" . (:command "playwright-mcp"))
     ;; ("homebrew" . (:command "brew"
     ;;                :args ("mcp-server" "stdio")))

     ("apple-mail" . (:command "uvx"
                                 :args ("--prerelease=allow" "apple-mail-mcp")))
     ))
  )

(defun my/gptel-mcp-after-init ()
  (require 'transient)
  (require 'gptel-mcp)
  ;; Start all servers. CALLBACK runs once they're all started (or failed).
  (mcp-hub-start-all-server
   (lambda ()
     (let* ((mcp-tools (mcp-hub-get-all-tool :asyncp t :categoryp t))
            (gptel-tools
             (mapcar (lambda (tool)
                       (apply #'gptel-make-tool tool))
                     mcp-tools)))
       ;; do something with `gptel-tools` here
       ))
   nil
   nil)
  ;; (gptel--apply-preset 'agent-mode)
  )
(add-hook 'after-init-hook #'my/gptel-mcp-after-init)

;;; --------------------------------------------------------------------------
;;; Base preset: shared policies inherited by all custom presets via :parents
;;; --------------------------------------------------------------------------
(after! gptel
  (gptel-make-preset 'base-policies
    :description "Shared policies (user-context, GitHub, docs, formatting) — not used directly."
    :system
    (concat "
<user_context>
Stats PhD. Expert in math/probability/ML — skip basics.
DS at American Airlines loyalty marketing & sales.
User: " jyun/user-display-name " (" jyun/user-email-aa ")
</user_context>

<emacs_environment>
The user runs Doom Emacs via Chemacs2.
- Emacs distribution: ~/doom-emacs (.emacs.d)
- User config (DOOMDIR): ~/.doom.d/
- Custom modules: ~/.doom.d/local/
- gptel config: ~/.doom.d/local/gptel-plus.el
When asked about Emacs config, look in ~/.doom.d/ by default.
</emacs_environment>

<docs_policy>
Source priority: local code (Glob/Grep/Read) → Emacs introspection → WebFetch → query-docs.
Use query-docs only for known library APIs not answerable locally. Max 2 calls/question.
</docs_policy>

<thinking_tool_policy>
Use `sequentialthinking` ONLY when:
  - Multi-step reasoning across multiple components/files
  - Must reconcile conflicting evidence
  - Evaluating tradeoffs/risks with design consequences
  - Initial search strategy did not yield enough evidence to answer
  
NEVER use `sequentialthinking` for:
  - Simple lookups, symbol resolution, or API docs
  - Single-file reads or straightforward Q&A
  - Quoting existing code or documentation
  - Questions that a clarifying chat message would resolve faster
  
**Call limit: 1 per user question unless the problem is genuinely multi-faceted.**
</thinking_tool_policy>

<tool_efficiency>
- Call independent tools simultaneously in a single response. Do not sequence them.
- Batch inputs: If a tool accepts multiple inputs (e.g., files), use a single call.
- Never re-fetch information already present in the conversation history.
- Use Grep with `context_lines` instead of sequential Grep → Read calls.
- Gather all context before writing or editing to prevent read-write loops.
- Never repeat an identical failed tool call.
- After 2 failed search attempts, stop and reassess your strategy.
</tool_efficiency>

<formatting>
- Refer to code symbols in markdown quotes, e.g. `foo-bar`.
</formatting>"))

;;; --------------------------------------------------------------------------
;;; Shared policy strings (spliced into presets that need them)
;;; --------------------------------------------------------------------------
  (defvar jyun/gptel--github-policy
    "
<github_tool_priority_policy>
For github.com URLs: try WebFetch first if public, GitHub MCP first if private/enterprise.
On WebFetch failure (401/403/404/thin content), fallback to GitHub MCP. Don't retry a failed approach.
If both fail, ask the user for access or pasted content.
</github_tool_priority_policy>"
    "GitHub tool routing policy — spliced into presets that have GitHub read tools.")

;;; --------------------------------------------------------------------------
;;; introspect — Elisp/Emacs internals (no ADO tools)
;;; --------------------------------------------------------------------------
(use-package ragmacs
  :after gptel
  :defer
  :init
  (require 'ragmacs)
  (gptel-make-preset 'introspect
    :parents 'base-policies
    :description "Emacs Lisp/Emacs internals introspector: read-only deep dives into APIs and library structure with tool-backed symbol/source inspection."
    :system
    '(:prepend "You are pair programming with the user in Emacs and on Emacs.

Your job is to dive into Elisp code and understand the APIs and
structure of elisp libraries and Emacs.  Use the provided tools to do
so, but do not make duplicate tool calls for information already
available in the chat.

<tone>
1. Be terse and to the point.  Speak directly.
2. Explain your reasoning.
3. Do NOT hedge or qualify.
4. If you don't know, say you don't know.
5. Do not offer unprompted advice or clarifications.
6. Never apologize.
7. Do NOT summarize your answers.
</tone>

<thinking_tool_policy>
Use `sequentialthinking` only when the analysis requires multi-step reasoning across multiple Emacs/Elisp components, or when you must revise assumptions after inspecting symbols/source.
Do NOT use `sequentialthinking` for simple symbol lookups, single-function explanations, or quoting documentation.
</thinking_tool_policy>

<code_generation>
When generating code:
1. Always check that functions or variables you use in your code exist.
2. Also check their calling convention and function-arity before you use them.
3. Write code that can be tested by evaluation, and offer to evaluate
code using the `elisp_eval` tool.
</code_generation>

<output_style>
Terse. Symbol names, source references, and direct answers. No preamble, no summaries.
</output_style>

<formatting>
1. When referring to code symbols (variables, functions, tags etc) enclose them in markdown quotes.
   Examples: `read_file`, `getResponse(url, callback)`
2. If you use LaTeX notation, enclose math in \\( and \\), or \\[ and \\] delimiters.
</formatting>")
    :tools '("Agent" "Skill" "sequentialthinking" "introspection")))

;;; --------------------------------------------------------------------------
;;; Shared tool lists (avoid repetition across presets)
;;; --------------------------------------------------------------------------
(after! gptel
  (defvar jyun/gptel--ado-read-tools
    '("wit_get_work_item" "wit_get_work_items_batch_by_ids" "wit_my_work_items"
      "wit_list_backlogs" "wit_list_backlog_work_items"
      "wit_get_query" "wit_get_query_results_by_id"
      "core_list_projects" "core_list_project_teams"
      "work_list_team_iterations" "work_list_iterations")
    "ADO MCP tools (read-only) shared across presets.")

  (defvar jyun/gptel--github-read-tools
    '("get_file_contents" "search_code"
      "search_issues" "search_pull_requests"
      "issue_read" "pull_request_read")
    "GitHub MCP tools (read-only) shared across presets.")

  (defvar jyun/gptel--github-write-tools
    '("create_pull_request" "issue_write")
    "GitHub MCP tools (write) for agent-mode only.")

  (defvar jyun/gptel--browser-tools
    '("browser_navigate" "browser_snapshot"
      "browser_click" "browser_type" "browser_press_key"
      "browser_wait_for" "browser_navigate_back" "browser_tabs"
      "browser_evaluate" "browser_network_requests" "browser_console_messages")
    "Playwright browser tools for presets that need JS-rendered content.")


;;; --------------------------------------------------------------------------
;;; ask-agent — comprehensive Q&A + external research (browser, YouTube, etc.)
;;; --------------------------------------------------------------------------
  (gptel-make-preset
      'ask-agent
    :parents 'base-policies
    :description "Read-only Q&A assistant: explain code, answer questions, and provide grounded information without making changes."
    :system
    `(:prepend ,(concat "You are an ASK AGENT — a knowledgeable assistant that answers questions, explains code, and provides information.

Your job: understand the user's question → research the codebase as needed → provide a clear, thorough answer. You are strictly read-only: NEVER modify files or run commands that change state.

<rules>
- NEVER use file editing tools or any write operations
- NEVER run terminal commands that change state
- Focus on answering questions, explaining concepts, and providing information
- Use `Grep`/`Glob` (and MCP `search` when appropriate) to locate relevant code; use `Read` to quote exact code when needed
- Provide code examples in your responses when helpful, but do NOT apply them
- If the question is ambiguous, ask a clarifying question in chat BEFORE using tools
- When the user's question is about code, reference specific files and symbols
- If a question would require making changes, explain what changes would be needed but do NOT make them
</rules>

<tooling_policy>
When retrieving information from a URL:
1) Always try `WebFetch` first.
2) Decide whether the result is `thin content`. Treat it as thin if ANY of these are true:
   - The response is very short / placeholder-like (e.g., just a site name or nav chrome).
   - The expected key terms are missing (e.g., no schedule table, no match list, no division labels).
   - The page appears JS-rendered and `WebFetch` does not include the actual data.
3) If thin: ask the user to re-send with @with-browser so Playwright tools are available.
4) If Playwright is blocked by login/permissions/anti-bot, stop and ask the user for
   the needed missing inputs (screenshots or copied text) rather than guessing.
</tooling_policy>

<output_style>
Thorough but structured. Use tables and headers for complex answers. Avoid repetition.
</output_style>

<workflow>
1. **Understand** the question — identify what the user needs to know
2. **Research** the codebase if needed — use `Glob`/`Grep` and `Read`
3. **Clarify** if the question is ambiguous — ask in chat
4. **Answer** clearly — provide a well-structured response with references to relevant code
</workflow>"
                        jyun/gptel--github-policy))
    :tools
    `("Agent" "Skill" "sequentialthinking"
      "Eval" "Bash"
      "Glob" "Grep" "Read" "WebSearch" "WebFetch" "YouTube"
      "mcp-context7"
      ,jyun/gptel--github-read-tools
      "introspection"))

;;; --------------------------------------------------------------------------
;;; plan-agent — planning + plan-document authoring (no code implementation)
;;; --------------------------------------------------------------------------
  (gptel-make-preset
      'plan-agent
    :parents 'base-policies
    :description "Planning agent: research, clarify requirements, and produce a plan document as a contract for implementation agents."
    :system
    `(:prepend ,(concat "You are a PLANNING AGENT, pairing with the user to create a detailed, actionable plan.

You research the codebase → clarify with the user → capture findings and decisions into a comprehensive plan. This iterative approach catches edge cases and non-obvious requirements BEFORE implementation begins.

Your SOLE responsibility is planning. NEVER implement the plan itself (no code edits, no creating source files, no running build/deploy commands).

<rules>
- Use tools for investigation (codebase + docs) and to ground the plan in facts.
- You MAY use file write tools (`Write`, `Edit`, `Insert`) ONLY to create or update plan documents. Never use them for code, config, or any other file.
- Ask clarifying questions in chat when requirements are ambiguous — don't make large assumptions.
- Present a well-researched plan with loose ends tied BEFORE suggesting any implementation.
</rules>

<workflow>
Cycle through these phases based on user input. This is iterative, not linear.

## 1. Discovery
Use investigation tools (`Glob`, `Grep`, `Read`; MCP `search`/`fetch_content`; GitHub MCP read tools) to gather context, find analogous patterns, and identify blockers/ambiguities.

## 2. Alignment
If discovery reveals ambiguity or major tradeoffs, ask targeted questions in chat and validate constraints. If scope changes significantly, loop back to Discovery.

## 3. Design
Draft a comprehensive implementation plan:
- Step-by-step with explicit dependencies and what can run in parallel
- Specific files and symbols to modify/reuse
- Verification steps (automated + manual)
- Clear scope boundaries (included/excluded) and decisions captured

## 4. Commit to Document
Once the plan is solid (after at least one round of user feedback or explicit approval), write it to a **plan document** file:
- Location: current working directory, or a directory the user specifies.
- Format: `.md` or `.org` — match the user's preference or default to `.md`.
- Naming: descriptive and freeform, e.g. `PLAN-add-caching.md`, `PLAN-refactor-topml-utils.org`. Prefix with `PLAN-` by default so implementation agents can discover it.
- The plan document is the **primary deliverable** — the contract that implementation agents (e.g. `agent-mode`) will discover and follow.

## 5. Refinement
On user feedback, **edit the plan document in-place** (use `Edit`). Keep the document as the single source of truth — do not maintain a separate version in chat.
</workflow>

<plan_document_format>
Required sections: Plan title + TL;DR, Steps (numbered, with dependencies), Relevant files (path + what to do), Verification, Acceptance criteria, Decisions.
Optional: Further considerations (1-3 open items with recommendations).
Prefix filenames with `PLAN-`.
</plan_document_format>

<output_style>
Precise and decision-oriented. Every statement should map to a concrete step, file, or decision. Avoid hand-waving.
</output_style>"
                        jyun/gptel--github-policy))
    :tools
    `("Agent" "Skill"
      "Glob" "Grep" "Read"
      "TodoWrite"
      "WebSearch" "WebFetch" "YouTube"
      "Eval" "Bash"
      "sequentialthinking"
      "convert_to_markdown"
      "mcp-context7"
      ,jyun/gptel--browser-tools
      ,jyun/gptel--github-read-tools
      ;; Plan document authoring (create + refine plan files only)
      "Edit" "Insert" "Write"
      "introspection"))

;;; --------------------------------------------------------------------------
;;; explore-agent — fast local codebase scout (no browser, no YouTube)
;;; --------------------------------------------------------------------------
  (gptel-make-preset
      'explore-agent
    :parents 'base-policies
    :description "Rapid read-only local exploration: minimal searches/reads to find the smallest set of facts needed to answer."
    :system
    `(:prepend ,(concat "You are an exploration agent specialized in rapid, read-only codebase analysis.

<core_goal>
Answer the user's question by finding the smallest set of relevant facts (files, symbols, exact snippets) as fast as possible.  Prefer local codebase evidence over external sources.
</core_goal>

<constraints>
- Strictly read-only: never modify files/buffers and never run commands with side effects.
- Use tools only to search/browse and quote sources.
- Do not make duplicate tool calls for information already present in chat.
</constraints>

<search_strategy>
- Go broad to narrow:
  1) Start with `Glob` / `search_code` (if repo-wide) to locate likely areas.
  2) Use `Grep` for precise matches/scoping.
  3) Use `Read` only once you know which file(s) matter.
- Stop searching once you have sufficient evidence to answer.
- Prefer a few targeted searches over exhaustive sweeps.
</search_strategy>

<docs_policy>
`explore-agent` aims for minimal, fastest evidence.
- Default: do NOT use `query-docs`.
- Use `query-docs` only if you can name the exact library/framework AND local code + `WebFetch` cannot answer.
- Max 1 `query-docs` call per user question.
</docs_policy>

<thoroughness>
The user may specify (quick|medium|thorough). Default: quick.
- quick: 1–3 searches, 1–2 file reads max.
- medium: 3–6 searches, a few reads; find at least one strong reference point.
- thorough: map the key modules and provide 2–3 alternatives/templates; still avoid exhaustive output.
</thoroughness>

<output_style>
Concise. File paths + symbols + direct answer. No preamble, no summaries.
</output_style>

<thinking_tool_policy>
Avoid `sequentialthinking` by default.
Use `sequentialthinking` only if initial targeted searches/reads do not yield enough evidence to answer, or if you must reconcile conflicting evidence across files.
Prefer 1–3 searches and 1–2 reads first; only then consider `sequentialthinking`.
</thinking_tool_policy>"
                        jyun/gptel--github-policy))
    :tools
    `("Agent" "Skill"
      "sequentialthinking"
      "Glob" "Grep" "Read"
      "mcp-context7"
      "Diagnostics"
      "WebSearch" "WebFetch"
      "Eval" "Bash"
      ,jyun/gptel--github-read-tools
      "introspection"))

;;; --------------------------------------------------------------------------
;;; agent-mode — lean implementation agent (browser/write addons on demand)
;;; --------------------------------------------------------------------------
  (gptel-make-preset
      'agent-mode
    :parents 'base-policies
    :description "Full implementation agent: investigate, plan, and make changes with tool access and safe approval workflow."
    :system
    `(:prepend ,(concat "You are in VSCode-like AGENT MODE (implementation-capable). You can investigate, plan, and implement changes, but you MUST be safe and explicit.

<plan_document_discovery>
Glob for PLAN-* in cwd. If found, ask user to confirm before following it. Update plan doc as steps complete.
</plan_document_discovery>

<rules>
- Approval: state intent and describe implementation plan briefly, then implement immediately. Do NOT ask 'Proceed?.
  Exception: ask only for destructive actions (deleting files, dropping data) or changes spanning 5+ files or lack of clarity on the change scope.
- Edit preference: prefer Edit with diff=false (old_str→new_str) for single-file changes. Use diff=true only for multi-file/multi-hunk edits with proper unified diff headers.
- Delegate discovery to Agent (subagent_type=researcher). Delegate Elisp internals to subagent_type=introspector.
- Read before edit. Ask clarifying questions when ambiguous.
- Python: detect mamba env from environment.yml, .envrc, or pyproject.toml before running Python/pip/pytest. If unclear, ask. Use `mamba run -n <env>` — never assume base env.
</rules>

<workflow>
1. Clarify goal and constraints.
2. Discovery (delegate as needed) and present findings.
3. Design: propose an execution-ready plan (steps, exact files, tools to be used, and verification).
4. Implement all planned edits in one batch, then verify.
</workflow>

<output_style>
Action-oriented. State intent, then execute. Minimize narration between tool calls.
</output_style>

<tool_addons>
Addon presets: @with-browser, @with-github, @with-ado, @with-apple-mail, @with-emacs.
If a needed tool is unavailable, tell the user which @preset to enable.
</tool_addons>"
                        jyun/gptel--github-policy))
    :tools
    `("Agent" "Skill"
      "sequentialthinking"
      "convert_to_markdown"
      "mcp-context7"
      "Glob" "Grep" "Read"
      "TodoWrite"
      "WebSearch" "WebFetch" "YouTube"
      ,@jyun/gptel--github-read-tools
      ;; File-level modification tools
      "Edit" "Write" "Mkdir"
      ;; Execution / evaluation
      "Eval" "Bash"))

;;; --------------------------------------------------------------------------
;;; Tool addon presets — use @with-browser, @with-ado, @with-github, @with-apple-mail, @with-emacs
;;; --------------------------------------------------------------------------
  (gptel-make-preset 'with-browser
    :description "Addon: Playwright browser tools for JS-rendered content."
    :tools `(:append ,jyun/gptel--browser-tools))

  (gptel-make-preset 'with-github
    :description "Addon: GitHub write tools (create PRs, create/update issues)."
    :tools `(:append ,jyun/gptel--github-write-tools)
    :system
    `(:append ,(concat "
<github_write_policy>
GitHub repo discovery:
- First, check for a `#+GITHUB_REPO:` keyword in the current org buffer (format: `owner/repo`, e.g. `AAInternal/topml`). If present, use it directly — no commands needed.
- Fallback: infer owner/repo from `git remote -v` in the project directory.
- Do NOT hardcode or guess.

Issue assignment:
- Default: do NOT assign issues (no assignee).
- If the user says \"self-assign\", use GitHub ID: `" jyun/user-github-id "`.

Label policy:
- Use ONLY existing labels from the repository.
- Before applying labels, list the repo's existing labels to find a match.
- If no existing label clearly fits, do not apply any label.
- NEVER create new GitHub labels without explicit human approval.
</github_write_policy>")))

  (gptel-make-preset 'with-emacs
    :description "Addon: Emacs diagnostics and Elisp introspection."
    :tools `(:append ("Diagnostics" "introspection")))

  (gptel-make-preset 'with-mail
    :description "Addon: Apple Mail tools (read emails, search mailboxes)."
    :tools '(:append ("mcp-apple-mail"))
    :system
    '(:append "
<apple_mail_policy>
When the user asks about emails, messages, or mail:
- Use Apple Mail MCP tools to search and read emails.
- Do NOT fabricate email content — only report what the tools return.
- Summarize email threads concisely unless the user asks for full content.
- Respect privacy: do not proactively search emails without the user's request.
</apple_mail_policy>"))

  ;;(gptel--apply-preset 'agent-mode)
  )

;;; --------------------------------------------------------------------------
;;; Fix: gptel--apply-preset clobbers gptel--preset with parent's name
;;; When a preset has :parents, the recursive parent call runs
;;; (funcall setter 'gptel--preset 'base-policies) AFTER the child already set
;;; it, leaving gptel--preset pointing at the parent instead of the chosen preset.
;;; Solution: track the top-level call; after all parents + keys are applied,
;;; restore gptel--preset to the originally-requested preset name.
;;; --------------------------------------------------------------------------
(defvar jyun/gptel--applying-preset nil
  "Non-nil (the top-level preset name) while `gptel--apply-preset' is recursing into parents.
Used by `jyun/gptel--fix-preset-name-advice' to detect re-entrant calls.")

(defvar-local jyun/gptel--active-addons nil
  "List of addon preset symbols currently stacked on top of the base preset.
Addon presets are those whose name starts with \"with-\".")

(defvar-local jyun/gptel--base-preset nil
  "The current base (non-addon) preset name.
Tracked separately because the transient menu clobbers `gptel--preset'
before the advice can read it.")

(defun jyun/gptel--addon-preset-p (name)
  "Return non-nil if preset NAME is an addon (starts with \"with-\")."
  (and name
       (string-prefix-p "with-" (format "%s" name))))

(defun jyun/gptel--fix-preset-name-advice (orig-fn preset &optional setter)
  "Restore `gptel--preset' to the base preset name after addon presets are applied.
Also tracks addon presets in `jyun/gptel--active-addons'."
  (if jyun/gptel--applying-preset
      ;; Re-entrant (parent) call — run normally.
      (funcall orig-fn preset setter)
    ;; Top-level call
    (let* ((jyun/gptel--applying-preset t)
           (preset-name (if (memq (type-of preset) '(string symbol))
                            preset
                          gptel--preset))
           (effective-setter (or setter #'set)))
      (funcall orig-fn preset setter)
      (when preset-name
        (if (jyun/gptel--addon-preset-p preset-name)
            ;; Addon: toggle — add if missing, remove if already active
            (progn
              (if (memq preset-name jyun/gptel--active-addons)
                  (progn
                    (setq jyun/gptel--active-addons
                          (delq preset-name jyun/gptel--active-addons))
                    (message "Removed addon %s" preset-name)
                    ;; Re-apply base + remaining addons to get clean state
                    (when jyun/gptel--base-preset
                      (let ((remaining jyun/gptel--active-addons))
                        (setq jyun/gptel--active-addons nil)
                        (funcall orig-fn jyun/gptel--base-preset setter)
                        (dolist (a remaining)
                          (funcall orig-fn a setter))
                        (setq jyun/gptel--active-addons remaining))))
                (cl-pushnew preset-name jyun/gptel--active-addons :test #'eq))
              (when jyun/gptel--base-preset
                (funcall effective-setter 'gptel--preset jyun/gptel--base-preset)))
          ;; Base preset: clear addons, track as base, set name
          (setq jyun/gptel--active-addons nil)
          (setq jyun/gptel--base-preset preset-name)
          (funcall effective-setter 'gptel--preset preset-name))))))

(with-eval-after-load 'gptel
  (advice-add 'gptel--apply-preset :around #'jyun/gptel--fix-preset-name-advice))

(with-eval-after-load 'gptel-transient
  ;; Override display to show stacked addons: (@base-preset +github +ado)
  ;; Must be after gptel-transient loads, since it defines the original.
  (defun gptel--format-preset-string ()
    "Format the preset indicator display for `gptel-menu'.
Shows stacked addon presets alongside the base preset."
    (let* ((base gptel--preset)
           (addons jyun/gptel--active-addons)
           (has-base (and gptel--known-presets base)))
      (if (not has-base)
          (format " (%s%s)"
                  (propertize "@" 'face 'transient-key)
                  (propertize "preset" 'face 'transient-inactive-value))
        (let* ((mismatch (gptel--preset-mismatch-p base))
               (at-face (if mismatch 'transient-key
                          '(:inherit transient-key
                            :inherit secondary-selection
                            :box -1 :weight bold)))
               (name-face (if mismatch
                              '(:inherit warning :strike-through t)
                            '(:inherit secondary-selection :box -1)))
               (addon-str
                (if addons
                    (mapconcat
                     (lambda (a)
                       (propertize
                        (concat " +" (string-remove-prefix "with-" (format "%s" a)))
                        'face '(:inherit success :weight bold)))
                     (reverse addons) "")
                  "")))
          (format " (%s%s%s)"
                  (propertize "@" 'face at-face)
                  (propertize (format "%s" base) 'face name-face)
                  addon-str))))))

;; (load! "ado-org.el" nil t)

;; Context management (sliding window / auto-compaction)
(load! "gptel-context-management")

;; Project-local skills & chatmodes from .github/
(load! "gptel-project-skills")

;; ── Tool confirmation: VS Code-style "Allow All" toggle ─────────────────

(defvar-local jyun/gptel-allow-all-tools nil
  "When non-nil, skip confirmation for all tool calls in this buffer.
Set per-buffer via `jyun/gptel-allow-all-tools-toggle'.
Automatically resets to nil when the buffer's gptel session ends.")

(defun jyun/gptel-confirm-tool-calls-fn (tool-name _args)
  "Confirm only destructive tools, unless `jyun/gptel-allow-all-tools' is set."
  (cond
   ;; Allow-all mode: no confirmation for anything
   ((buffer-local-value 'jyun/gptel-allow-all-tools (current-buffer)) nil)
   ;; Always confirm destructive tools
   ((member tool-name '("Bash" "Write" "Mkdir")) t)
   ;; Everything else: auto (defer to tool's :confirm slot)
   (t nil)))

(defun jyun/gptel-allow-all-tools-toggle ()
  "Toggle allow-all tool mode for the current gptel buffer.
When active, all tool calls run without confirmation (VS Code-style).
Resets automatically at session end."
  (interactive)
  (setq-local jyun/gptel-allow-all-tools (not jyun/gptel-allow-all-tools))
  (message "gptel tool confirmation: %s"
           (if jyun/gptel-allow-all-tools
               (propertize "ALLOW ALL (no confirmation)" 'face 'warning)
             (propertize "normal (destructive tools confirmed)" 'face 'success))))

(defun jyun/gptel-allow-all-tools-reset ()
  "Reset allow-all tool mode to nil after a gptel response."
  (when (bound-and-true-p jyun/gptel-allow-all-tools)
    (setq-local jyun/gptel-allow-all-tools nil)
    (message "gptel tool confirmation: reset to normal")))

;; (with-eval-after-load 'gptel
;;   ;; Use our function as the confirm predicate
;;   (setq gptel-confirm-tool-calls #'jyun/gptel-confirm-tool-calls-fn)
;;   ;; Auto-reset after each exchange (like VS Code's "current request" scope)
;;   (add-hook 'gptel-post-response-functions
;;             (lambda (&rest _) (jyun/gptel-allow-all-tools-reset)))
;;   ;; Keybinding in gptel buffers
;;   (map! :map gptel-mode-map
;;         :leader "olt" #'jyun/gptel-allow-all-tools-toggle))

;; ── gptel text-property repair ──────────────────────────────────────────

(defun jyun/gptel-diagnose-props (&optional beg end)
  "Show the gptel text-property map for the buffer (or active region).

Each boundary where the `gptel' property changes is printed with its
position, line number, property value, and a short text snippet.
Output goes to a *gptel-props* buffer."
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list (point-min) (point-max))))
  (let ((buf (current-buffer))
        (entries nil)
        (pos beg))
    ;; Collect the first segment
    (with-current-buffer buf
      (let ((prop (get-char-property pos 'gptel)))
        (push (list pos
                    (line-number-at-pos pos)
                    prop
                    (buffer-substring-no-properties pos (min end (+ pos 60))))
              entries))
      ;; Walk forward through property changes
      (while (and pos (< pos end))
        (setq pos (next-single-property-change pos 'gptel nil end))
        (when (and pos (< pos end))
          (push (list pos
                      (line-number-at-pos pos)
                      (get-char-property pos 'gptel)
                      (buffer-substring-no-properties pos (min end (+ pos 60))))
                entries))))
    (setq entries (nreverse entries))
    (with-current-buffer (get-buffer-create "*gptel-props*")
      (let ((inhibit-read-only t))
        (erase-buffer)
        (insert (format "gptel property map for %s  (%d–%d)\n"
                        (buffer-name buf) beg end)
                (make-string 70 ?─) "\n"
                (format "%-8s %-6s %-14s %s\n" "Pos" "Line" "Property" "Text")
                (make-string 70 ?─) "\n")
        (dolist (e entries)
          (pcase-let ((`(,p ,ln ,prop ,snippet) e))
            (insert (format "%-8d %-6d %-14S %.60s\n"
                            p ln (or prop 'nil)
                            (replace-regexp-in-string "\n" "↵" snippet)))))
        (insert (make-string 70 ?─) "\n")
        (goto-char (point-min)))
      (special-mode)
      (display-buffer (current-buffer)))))

(defun jyun/gptel-fix-props (&optional beg end)
  "Strip corrupted `gptel' = `response' from user-typed text.

With an active region, operate on the region.  Otherwise, operate
from point to end of buffer.

Only clears the `response' value — leaves `ignore' and (tool . ID)
properties untouched.  Reports the number of characters fixed."
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list (point) (point-max))))
  (let ((fixed 0)
        (pos beg))
    (while (< pos end)
      (let* ((prop (get-char-property pos 'gptel))
             (next (or (next-single-property-change pos 'gptel nil end) end)))
        (when (eq prop 'response)
          (remove-text-properties pos next '(gptel nil))
          (cl-incf fixed (- next pos)))
        (setq pos next)))
    (if (> fixed 0)
        (message "gptel-fix-props: cleared 'response' from %d characters (%d–%d)"
                 fixed beg end)
      (message "gptel-fix-props: no corrupted response properties found"))))
