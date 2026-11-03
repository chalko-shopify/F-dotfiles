# 51_zsh_powerlevel10k.zshrc: source Powerlevel10k theme and user prompt configuration

[[ -r "$HOME/powerlevel10k/powerlevel10k.zsh-theme" ]] && source "$HOME/powerlevel10k/powerlevel10k.zsh-theme"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"
