# 10_zsh_user_local_bin.zshrc: add user-local executables to PATH

# User-local executables
path=("$HOME/.local/bin" $path)
export PATH
