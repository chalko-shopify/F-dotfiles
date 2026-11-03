# F-dotfiles Agent Rules

This file outlines the rules, guidelines, and behavioral constraints for AI agents working in the **F-dotfiles** repository.

## Repository Overview

`F-dotfiles` is an opinionated, topical dotfiles organization scheme based on GNU `stow`. It organizes dotfiles into application-specific package directories at the repository root (e.g., `zsh/`, `git/`, `linux/`).

## Architectural Rules

### 1. Package Directory Structure & Stow Conventions
Every package folder (e.g., `git`, `zsh`) follows a specific layout. Files in these folders are symlinked to the user's home directory.
* **Base Package Files**: Place common configuration files directly in the package directory.
* **OS-Specific Overrides**: Place OS-specific overrides in a subdirectory named `@${OS}` (e.g., `@Linux`, `@Darwin`).
* **Host-Specific Overrides**: Place host-specific overrides in a subdirectory named `@${HOSTNAME}` (e.g., `@my-laptop`).
* **XDG Config Home (`~/.config`)**: Place files destined for `XDG_CONFIG_HOME` under `@config`.
  * OS-specific configs in `XDG_CONFIG_HOME` go under `@config/@${OS}`.
  * Host-specific configs in `XDG_CONFIG_HOME` go under `@config/@${HOSTNAME}`.

---

### 2. Package Documentation (`f-dotfiles.py`)
F-dotfiles uses a custom Python script [f-dotfiles.py](file:///home/nick/.gemini/antigravity/worktrees/F-dotfiles/create-agents-documentation/f-dotfiles.py) (run via pre-commit hooks or manually) to automatically document packages.
* **Sentinel Comment**: Every package's `README.md` must contain the comment `<!--- Tree block injection -->`. The script injects the auto-generated directory tree view right after this comment.
* **Inline File Descriptions**: For any configuration file or script in a package, add a description comment in the first 10 lines in the format:
  ```
  # <filename>: <description>
  ```
  For example, in `aliases.zsh`: `# aliases.zsh: shell aliases`. The script extracts these comments to enrich the generated tree listing.
* **Regeneration**: Do not manually modify the tree listing block in package `READMEs`. Run `python3 f-dotfiles.py` to regenerate the documentation automatically.

---

### 3. Secret and Sensitive Files
* **Never commit actual secrets, passwords, or private keys**.
* Add any files containing sensitive information to the package-specific `.gitignore`.
* Commit a template file with the same name but with a `.example` suffix (e.g., `credentials.example`) containing dummy values to serve as a guide for users.

---

### 4. Git and Ignore Rules
* Keep directories clean. Use `.gitignore` or `.stow-local-ignore` files within package directories to prevent unwanted files (e.g., local state, caches) from being symlinked or tracked.

<!-- BEGIN BEADS INTEGRATION v:1 profile:minimal hash:46cd31e7 -->
## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context and commands.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
```

### Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Run `bd prime` for detailed command reference and session close protocol
- Use `bd remember` for persistent knowledge — do NOT use MEMORY.md files

**Architecture in one line:** issues live in a local Dolt DB; sync uses `refs/dolt/data` on your git remote; `.beads/issues.jsonl` is a passive export. See https://github.com/gastownhall/beads/blob/main/docs/core-concepts/sync-concepts.md for details and anti-patterns.

## Agent Context Profiles

The managed Beads block is task-tracking guidance, not permission to override repository, user, or orchestrator instructions.

- **Conservative (default)**: Use `bd` for task tracking. Do not run git commits, git pushes, or Dolt remote sync unless explicitly asked. At handoff, report changed files, validation, and suggested next commands.
- **Minimal**: Keep tool instruction files as pointers to `bd prime`; use the same conservative git policy unless active instructions say otherwise.
- **Team-maintainer**: Only when the repository explicitly opts in, agents may close beads, run quality gates, commit, and push as part of session close. A current "do not commit" or "do not push" instruction still wins.

## Session Completion

This protocol applies when ending a Beads implementation workflow. It is subordinate to explicit user, repository, and orchestrator instructions.

1. **File issues for remaining work** - Create beads for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **Handle git/sync by active profile**:
   ```bash
   # Conservative/minimal/default: report status and proposed commands; wait for approval.
   git status

   # Team-maintainer opt-in only, unless current instructions forbid it:
   git pull --rebase
   bd dolt push
   git push
   git status
   ```
5. **Hand off** - Summarize changes, validation, issue status, and any blocked sync/commit/push step

**Critical rules:**
- Explicit user or orchestrator instructions override this Beads block.
- Do not commit or push without clear authority from the active profile or the current user request.
- If a required sync or push is blocked, stop and report the exact command and error.
<!-- END BEADS INTEGRATION -->

<!-- BEGIN BEADS CODEX SETUP: generated by bd setup codex -->
## Beads Issue Tracker

Use Beads (`bd`) for durable task tracking in repositories that include it. Use the `beads` skill at `.agents/skills/beads/SKILL.md` (project install) or `~/.agents/skills/beads/SKILL.md` (global install) for Beads workflow guidance, then use the `bd` CLI for issue operations.

### Quick Reference

```bash
bd ready                # Find available work
bd show <id>            # View issue details
bd update <id> --claim  # Claim work
bd close <id>           # Complete work
bd prime                # Refresh Beads context
```

### Rules

- Use `bd` for all task tracking; do not create markdown TODO lists.
- Run `bd prime` when Beads context is missing or stale. Codex 0.129.0+ can load Beads context automatically through native hooks; use `/hooks` to inspect or toggle them.
- Keep persistent project memory in Beads via `bd remember`; do not create ad hoc memory files.

**Architecture in one line:** issues live in a local Dolt DB; sync uses `refs/dolt/data` on your git remote; `.beads/issues.jsonl` is a passive export. See https://github.com/gastownhall/beads/blob/main/docs/core-concepts/sync-concepts.md for details and anti-patterns.
<!-- END BEADS CODEX SETUP -->
