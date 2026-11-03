# 10_brew_shellenv.zprofile: initialize Homebrew environment on macOS login shells

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi
