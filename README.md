![F-dotfiles banner](https://raw.githubusercontent.com/F-dotfiles/F-dotfiles/master/.github/img/banner.png)

# F-dotfiles

Personal dotfiles managed with GNU Stow, `dotstow`, and package-level README generation.

This repository is the Shopify/work version of my dotstow fork at <https://github.com/chalko/F-dotfiles>, which is based on and credits Kraymer's original F-dotfiles project: <https://github.com/Kraymer/F-dotfiles>.

> **/ɛfdɒtfaɪlz/**
>
> *n.* originally stands for *Full-fledged-Über-Clean-Kraymer dotfiles.*, an opinionated dotfiles organization scheme based on Stow.

## Current direction

This fork keeps the useful F-dotfiles pattern while rebuilding the actual dotfile contents slowly and intentionally:

- active packages live at the repository root, e.g. `zsh/`, `iterm/`, `dotstow/`, `_stow/`
- inherited/non-authoritative packages are archived under `_archive/legacy-packages/`
- packages are installed with `dotstow <package>`
- `zsh` is being migrated gradually from a working monolithic config to a small loader plus package-provided mixins
- package READMEs are generated with `f-dotfiles.py` and should document package-specific install notes

## Features

- **GNU Stow powered:** dotfiles are symlinked from this repo into `$HOME` and `$XDG_CONFIG_HOME`.
- **`dotstow` wrapper:** installs base package files, OS-specific files, host-specific files, and XDG config files in the right order.
- **Topical packages:** group config by tool/application.
- **Mixin-friendly zsh:** packages can contribute ordered zsh snippets under `@config/zsh/rc.d` or OS/host-specific variants.
- **Self-documenting packages:** package READMEs include generated tree listings enriched by inline file descriptions.

## Bootstrap

Prerequisites:

```bash
brew install stow tree
pnpm install
```

Bootstrap Stow's own config:

```bash
stow -t ~ _stow
```

Bootstrap the `dotstow` command:

```bash
./scripts/dotstow dotstow
```

After that, install packages with:

```bash
dotstow zsh
dotstow iterm
```

Use the wrapper path if `~/.local/bin` is not on `PATH` yet:

```bash
./scripts/dotstow <package>
```

## Package layout

Each active package can contain:

```text
package/
  files-for-$HOME
  @config/
    files-for-$XDG_CONFIG_HOME
  @Darwin/
    macOS-only files for $HOME
  @Linux/
    Linux-only files for $HOME
  @HOSTNAME/
    host-only files for $HOME
  @config/@Darwin/
    macOS-only files for $XDG_CONFIG_HOME
  @config/@Linux/
    Linux-only files for $XDG_CONFIG_HOME
  @config/@HOSTNAME/
    host-only files for $XDG_CONFIG_HOME
```

## Zsh mixin pattern

The `zsh` package owns the core shell loader. Other packages can contribute shell behavior by stowing snippets into shared zsh snippet directories.

Interactive zsh rc snippets should use this filename shape:

```text
NN_<package>_<thing>.zshrc
```

Ordering convention:

```text
10_*  early prerequisites such as PATH/XDG setup
50_*  mostly order-independent package mixins
90_*  late/final initialization such as tec/dev/devx
```

Examples:

```text
zsh/@config/zsh/rc.d/10_zsh_user_local_bin.zshrc
iterm/@config/@Darwin/zsh/rc.d/50_iterm_shell_integration.zshrc
```

The migration strategy is intentionally slow:

1. preserve current working shell behavior
2. stow it as-is
3. add a snippet loader
4. extract one small behavior at a time
5. move stable snippets into dedicated packages when boundaries are clear

## Package documentation

Package READMEs should use this order:

1. title
2. one-line summary
3. generated tree block
4. description/details
5. prerequisites / installation

Every active package README should contain:

```markdown
<!--- Tree block injection -->
```

Regenerate package trees manually with:

```bash
./scripts/f-dotfiles
```

The Husky pre-commit hook also runs this script and stages package README updates.

Inline file descriptions in the first 10 lines are included in generated trees:

```sh
# filename: short description
```

## Secrets

Never commit real secrets, credentials, passwords, tokens, or private keys.

For secret-sensitive config:

- ignore the real file with a package-specific `.gitignore`
- commit a `.example` template with dummy values
- keep generated local state/cache files out of tracked packages

## Credits

- Original F-dotfiles project by Kraymer: <https://github.com/Kraymer/F-dotfiles>
- My dotstow fork: <https://github.com/chalko/F-dotfiles>
- This repository: the Shopify/work version of that dotstow fork

---

<i id="f1">GNU Stow documentation:</i> <https://www.gnu.org/software/stow/manual/stow.html>
