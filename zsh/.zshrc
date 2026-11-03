# .zshrc: interactive shell zsh setup and rc snippet loader

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# load zsh config files
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
config_files=(${XDG_CONFIG_HOME}/**/*.zshrc(N))
for file in ${config_files}
do
  source $file
done

