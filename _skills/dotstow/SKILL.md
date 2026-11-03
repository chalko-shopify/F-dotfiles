---
name: dotstow
description: Manage and stow dotfiles and configs in the F-dotfiles repository using the custom dotstow tool. Use this skill whenever you are asked to create, modify, add, install, stow, list, or configure any packages, configuration files, or dotfiles in this repository.
allowed-tools: Bash(./_skills/dotstow/scripts/f-dotfiles) Bash(./_skills/dotstow/scripts/dotstow*) run_command(./_skills/dotstow/scripts/f-dotfiles) run_command(./_skills/dotstow/scripts/dotstow*) Read Write Edit Glob Grep view_file write_to_file replace_file_content multi_replace_file_content list_dir grep_search
---

# dotstow Skill Instructions

Use this skill when you are asked to create, modify, stow, or debug configurations and packages in this repository.

## 1. Repository Model

This repository is the Shopify/work version of the user's dotstow fork of Kraymer's F-dotfiles pattern.

Active packages live at the repository root, for example:

```text
_stow/
dotstow/
zsh/
iterm/
tec/
brew/
git/
ssh/
```

Inherited/non-authoritative packages may live under:

```text
_archive/legacy-packages/
```

Do not stow archived packages directly. Use them only as reference material when rebuilding fresh active packages.

## 2. Directory Structure Conventions

Always structure active packages to align with `dotstow` and GNU Stow expectations:

* **Base Package Files**: Root of the package directory, symlinked to `$HOME`.
* **OS-Specific Overrides**: Under `@${OS}` (e.g., `@Linux`, `@Darwin`), symlinked to `$HOME`.
* **Host-Specific Overrides**: Under `@${HOSTNAME}`, symlinked to `$HOME`.
* **XDG Config Home**: Under `@config`, symlinked to `$XDG_CONFIG_HOME` (normally `~/.config`).
  * OS-specific XDG config: `@config/@${OS}`.
  * Host-specific XDG config: `@config/@${HOSTNAME}`.

Install packages with:

```bash
dotstow <package>
```

If `dotstow` is not yet on `PATH`, use:

```bash
./scripts/dotstow <package>
```

The `dotstow` command itself is installed by the `dotstow` package to:

```text
~/.local/bin/dotstow
```

## 3. README and Documentation Pattern

Every active package must have a `README.md` containing:

```markdown
<!--- Tree block injection -->
```

Preferred package README order:

1. Title
2. One-line summary
3. Generated tree block
4. Longer description/details
5. Prerequisites / installation

For example:

~~~markdown
# Package Name

One-line summary.

<!--- Tree block injection -->

Longer package description.

## Installation

```bash
dotstow package_name
```
~~~

Do not manually edit generated tree listings. Regenerate with:

```bash
./scripts/f-dotfiles
```

The repo uses `pnpm` + Husky. The pre-commit hook runs `./scripts/f-dotfiles` and stages package README changes.

## 4. Inline File Descriptions

For every text configuration file where practical, add an inline description within the first 10 lines:

```text
# <filename>: <short description>
```

Examples:

```zsh
# 10_zsh_user_local_bin.zshrc: add user-local executables to PATH
```

```sshconfig
# config: SSH client configuration
```

`f-dotfiles.py` extracts these descriptions into generated package trees.

## 5. Slow Migration Workflow

Prefer slow, reversible migrations over clean-room rewrites.

For existing live dotfiles:

1. Inventory files without reading secrets.
2. Copy known-safe current config into the package as-is.
3. Add README and inline descriptions.
4. Run `./scripts/f-dotfiles`.
5. Run syntax/health checks where available.
6. Dry-run or anticipate stow conflicts.
7. Back up existing live targets to `~/.dotfiles-backup/<package>-<timestamp>/`.
8. Run `dotstow <package>`.
9. Verify symlinks and application behavior.
10. Commit only after validation.

Avoid `stow --adopt`, especially for secret-sensitive packages. It can move unknown local files, credentials, keys, or generated state into the repository.

## 6. Zsh Mixin Pattern

The `zsh` package should be a small loader. Other packages can contribute shell behavior by stowing snippets into shared zsh snippet directories.

Interactive rc snippets use:

```text
NN_<package>_<thing>.zshrc
```

Login/profile snippets use:

```text
NN_<package>_<thing>.zprofile
```

Ordering convention:

```text
10_*  early prerequisites such as PATH/XDG setup
50_*  mostly order-independent package mixins
90_*  late/final initialization, especially tec/dev/devx
```

Examples:

```text
zsh/@config/zsh/rc.d/10_zsh_user_local_bin.zshrc
iterm/@config/@Darwin/zsh/rc.d/50_iterm_shell_integration.zshrc
brew/@config/@Darwin/zsh/profile.d/10_brew_shellenv.zprofile
tec/@config/zsh/rc.d/90_tec_init.zshrc
```

Keep `.zshenv` minimal. It is sourced by every zsh invocation and should only contain safe environment defaults such as XDG base directory variables.

## 7. Secrets and Sensitive Files

Never commit real secrets, credentials, passwords, tokens, or private keys.

For secret-sensitive config:

* Track config and examples, not identity material.
* Add package-specific `.gitignore` rules.
* Commit `.example` templates with dummy values when helpful.
* Keep generated local state/cache files out of tracked packages.

Especially sensitive areas:

```text
~/.ssh
~/.gnupg
~/.config/gcloud
~/.config/quick
~/.npmrc
~/.kube
```

For SSH specifically, do not read or commit private keys. Track only selected public keys and reviewed config.

## 8. Conflict Avoidance for Overlapping Configurations

When multiple packages contribute to the same application, avoid stowing different files to the exact same target path. GNU Stow will fail with target link conflicts.

Prefer loader/include patterns:

* **Zsh**: use shared snippet directories such as `@config/zsh/rc.d/` and `@config/zsh/profile.d/`.
* **Git**: use include files instead of conflicting full config files. Be careful with Shopify/dev-managed config under `~/.config/dev`.
* **SSH**: prefer an include-style `~/.ssh/config` and `~/.ssh/config.d/*.conf` when splitting becomes useful. Do not use `stow --adopt` for SSH.

## 9. Validation

Common validation commands:

```bash
pnpm test
./scripts/f-dotfiles
.husky/_/pre-commit
```

For zsh packages/snippets:

```bash
zsh -n <file>
zsh -c 'echo ok'
zsh -lc 'echo login-ok'
zsh -lic 'echo interactive-login-ok'
```

For SSH:

```bash
ssh -G github.com
```

For tec/dev environment checks, prefer non-mutating doctor/list/report commands unless the user explicitly asks for fixes.
