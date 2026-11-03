# 90_tec_init.zshrc: initialize tec-managed shell toolchain late

# Added by tec agent
[[ -x "$HOME/.local/state/tec/profiles/base/current/global/init" ]] && eval "$("$HOME/.local/state/tec/profiles/base/current/global/init" zsh)"
