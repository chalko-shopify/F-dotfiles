# 90_tec_noninteractive_path.zprofile: add tec toolchain bin to PATH for non-interactive login shells

# Added by tec agent
[[ ! -o interactive ]] && [[ -d "$HOME/.local/state/tec/toolchain/base_profile/bin" ]] && export PATH="$HOME/.local/state/tec/toolchain/base_profile/bin:$PATH"
