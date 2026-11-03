# Zsh

This package owns the **core zsh startup skeleton** only. Other packages can contribute shell behavior by stowing zsh snippets into the shared `XDG_CONFIG_HOME` zsh snippet directories.

## Startup model

The top-level zsh files should stay small and predictable:

- `.zshenv` is for minimal environment that must exist for every zsh invocation.
- `.zprofile` is for login-shell setup.
- `.zshrc` is for interactive-shell setup and should source ordered snippets from `~/.config/zsh/rc.d`.

Avoid putting application-specific setup directly in `.zshrc`. Instead, application packages should add their own snippets as mixins.

## Mixin pattern

A package that needs shell integration should stow a file into one of the zsh snippet directories instead of editing the zsh package itself.

Interactive rc snippets should use this filename shape:

```text
NN_<package>_<thing>.zshrc
```

Where:

- `NN` is a two-digit ordering prefix such as `10`, `50`, or `90`.
- `<package>` is the package contributing the snippet, such as `zsh`, `iterm`, `tec`, or `brew`.
- `<thing>` describes what the snippet does.
- Use underscores, not dashes, so names are easy to read and sort consistently.

For cross-platform interactive shell setup:

```text
<package>/@config/zsh/rc.d/NN_<package>_<thing>.zshrc
```

For macOS-only interactive shell setup:

```text
<package>/@config/@Darwin/zsh/rc.d/NN_<package>_<thing>.zshrc
```

For Linux-only interactive shell setup:

```text
<package>/@config/@Linux/zsh/rc.d/NN_<package>_<thing>.zshrc
```

For host-specific setup:

```text
<package>/@config/@<HOSTNAME>/zsh/rc.d/NN_<package>_<thing>.zshrc
```

This lets packages such as `brew`, `gnupg`, `go`, `iterm`, `tec`, or `devx` contribute shell setup independently while the `zsh` package remains the common loader.

## iTerm example

The iTerm shell integration should **not** live in the `zsh` package. It belongs in an `iterm` package as a macOS-only zsh mixin, for example:

```text
iterm/@config/@Darwin/zsh/rc.d/50_iterm_shell_integration.zshrc
```

with contents like:

```zsh
# 50_iterm_shell_integration.zshrc: source iTerm2 shell integration on macOS

[[ -r "$HOME/.iterm2_shell_integration.zsh" ]] && source "$HOME/.iterm2_shell_integration.zsh"
```

When both packages are stowed, `dotstow zsh` installs the loader and `dotstow iterm` contributes the iTerm-specific snippet into the same ordered snippet directory.

## Ordering guidance

Suggested `rc.d` ordering:

```text
00-09  reserved for the zsh loader and emergency/bootstrap behavior
10-19  things that must run early, such as fundamental PATH and XDG setup
50-59  mostly order-independent package mixins and everyday shell behavior
90-99  things that must run last, such as tec/dev/devx or final local overrides
```

Prefer the `50_*` range for most package snippets. Only use `10_*` when a snippet must prepare the environment for later snippets, and only use `90_*` when a tool explicitly wants to be last.

`tec` should be treated as a late/final toolchain initializer, not an early snippet. Put it in the `90_*` range unless we learn a more specific requirement, for example `90_tec_init.zshrc`.

`~/.local/bin` should be added before late toolchain initialization so commands installed by dotstow, such as `dotstow`, are available before `tec`/`dev`/`devx` run:

```zsh
# User-local executables
path=("$HOME/.local/bin" $path)
export PATH
```

## Slow migration plan

Migrate from the current hand-managed shell configuration toward the mixin pattern incrementally:

1. Create the `zsh` package from the existing live `~/.zsh*` files **as-is**.
   - Preserve current behavior first.
   - Do not try to redesign Oh My Zsh, Powerlevel10k, tec/dev/devx, or terminal integration in the first move.
2. Verify the as-is package.
   - Syntax-check the files.
   - Back up the live files.
   - Stow the `zsh` package only when the package matches current behavior.
   - Open a new shell and confirm prompt, `tec`, `devx`, `dotstow`, and existing aliases/functions still work.
3. Add the snippet loader to the existing `.zshrc` just before the late `tec`/`dev`/`devx` initialization.
   - Keep `tec` late because it wants to be last.
   - The loader should source `.zshrc` mixins from `XDG_CONFIG_HOME`, for example:

   ```zsh
   # load zsh config files
   config_files=(${XDG_CONFIG_HOME}/**/*.zshrc(N))
   for file in ${config_files}
   do
     source $file
   done
   ```

4. Start moving pieces out of root `.zshrc` into snippets.
   - It is fine if the first snippets still live in the `zsh` package.
   - The initial goal is extraction and ordering, not perfect package boundaries.
5. Add more packages as natural boundaries appear.
   - For example, once an iTerm snippet is isolated and stable, move it from `zsh` into an `iterm` package at `iterm/@config/@Darwin/zsh/rc.d/50_iterm_shell_integration.zshrc`.
   - Do the same for `brew`, `gnupg`, `go`, `tec`, `devx`, etc. as needed.
6. Repeat until root `.zshrc`, `.zprofile`, and `.zshenv` are tiny loaders.

This is intentionally the reverse of a clean-room rewrite: first make dotstow own the current working shell, then gradually refactor behavior into ordered mixin snippets.

## Archive reference

The archived packages under `_archive/legacy-packages` show the older version of this idea: packages such as `brew`, `go`, `gnupg`, and `linux` contributed files under `@config/zsh/...`, while the root zsh package sourced zsh snippets from `XDG_CONFIG_HOME`.

The new pattern keeps that mixin idea but standardizes interactive snippets under `zsh/rc.d` with numeric ordering and uses dotstow OS/host layers such as `@config/@Darwin` for platform-specific integrations.

<!--- Tree block injection -->
    ├── .p10k.zsh
    ├── .zprofile
    ├── .zshrc
    └── @config
        └── zsh
            └── rc.d
                └── 10_zsh_user_local_bin.zshrc 	# add user-local executables to PATH

