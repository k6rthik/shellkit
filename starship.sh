#!/usr/bin/env bash
# Starship Prompt Configuration
# This file configures the starship prompt with custom window title

# Only proceed if starship is installed
if ! command -v starship &> /dev/null; then
    return 0
fi

##### STARSHIP STARTS ######################
function set_win_title() {
  local cmd=" ($@)"
  if [[ "$cmd" == " (starship_precmd)" || "$cmd" == " ()" ]]
  then
    cmd=""
  fi
  if [[ $PWD == $HOME ]]
  then
    if [[ $SSH_TTY ]]
    then
      echo -ne "\033]0; 🏛️ @ $HOSTNAME ~$cmd\a" < /dev/null
    else
      echo -ne "\033]0; 🏠 ~$cmd\a" < /dev/null
    fi
  else
    BASEPWD=$(basename "$PWD")
    if [[ $SSH_TTY ]]
    then
      echo -ne "\033]0; 🌩️ $BASEPWD @ $HOSTNAME $cmd\a" < /dev/null
    else
      echo -ne "\033]0; 📁 $BASEPWD $cmd\a" < /dev/null
    fi
  fi
}

#if [ -n "$VSCODE_PID" ]; then
#  export VIRTUAL_ENV_DISABLE_PROMPT=1
#fi

starship_precmd_user_func="set_win_title"
if [ -n "$ZSH_VERSION" ]; then
  eval "$(starship init zsh)"
else
  eval "$(starship init bash)"
fi
if [[ -n "$WT_PROFILE_ID" ]]; then
  trap 'set_win_title "${BASH_COMMAND}"' DEBUG > /tmp/ltrap
fi
