#!/bin/bash

# functions.zsh: sometimes aliases are not enough...

# Search which filenames contain given string in local dir subtree 
where() {
    find . -name "*${1}*"
}

# Set terminal title  
function set-title() {
  if [[ -z "$ORIG" ]]; then
    ORIG=$PS1
  fi
  TITLE="\[\e]2;$*\a\]"
  PS1=${ORIG}${TITLE}
}

# Set window title
function set-win-title () {
  window_title="\033]0;$@\007"
  echo -ne "$window_title"
}
