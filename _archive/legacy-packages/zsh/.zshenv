# .zshenv is always sourced, define here exported variables that should
# be available to other programs.
export VISUAL=subl
export EDITOR=nano
export PAGER=more
export PATH=$PATH:~/bin:/usr/local/bin
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# load zsh config files

env_config_files=(${XDG_CONFIG_HOME}/zsh/**/*.zshenv(N))
if test ! -z "$env_config_files" ;
    then
    for file in ${env_config_files}
    do
      echo "source" $file
      source $file
    done
fi


env_config_files=(${XDG_CONFIG_HOME}/**/*.zshenv(N))
if test ! -z "$env_config_files" ;
    then
    for file in ${env_config_files}
    do
      echo "source" $file
      source $file
    done
fi

export TERM="xterm-256color"
