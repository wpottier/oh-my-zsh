ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_REMOTE_BEHIND="%{$reset_color%}%{$fg[green]%}<%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_REMOTE_AHEAD="%{$reset_color%}%{$fg[green]%}>%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_REMOTE_DIVERGED="%{$reset_color%}%{$fg[red]%}Y%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$reset_color%}%{$fg[yellow]%}?%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$reset_color%}%{$fg[green]%}+%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$reset_color%}%{$fg[green]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$reset_color%}%{$fg[red]%}-%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$reset_color%}%{$fg[green]%}±%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STASHED="%{$reset_color%}%{$fg[cyan]%}$%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$reset_color%}%{$fg[red]%}⎇%{$reset_color%}"

ZSH_THEME_POWER_PROMPT_ACDC="%{$fg[green]%}☀%{$reset_color%}"
ZSH_THEME_POWER_PROMPT_BATTERY="▸"

_ceil() {
  awk "BEGIN{print int($1/10)}"
}

__git_ps1() {
  local cb=$(current_branch)
  if [ -n "$cb" ]; then
    echo "$(git_prompt_status)%{$fg[cyan]%}[$cb$(git_remote_status)]%{$reset_color%}"
  fi
}

_battery-available() {
  type battery_pct_remaining &> /dev/null
}

__battery_ps1() {
  b=$(battery_pct_remaining)

  if [[ $b == "External Power" ]]; then
    BATTERY="$ZSH_THEME_POWER_PROMPT_ACDC"
  else
    level=$(_ceil $b)
    if [ $b -gt 50 ]; then
      color='green'
    elif [ $b -gt 20 ]; then
      color='yellow'
    else
      color='red'
    fi

    BATTERY="%{$fg[$color]%}"
    for i in {1..$level}
    do
      BATTERY="$BATTERY$ZSH_THEME_POWER_PROMPT_BATTERY"
    done
    BATTERY="$BATTERY ($(battery_time_remaining))"
  fi

  echo "$BATTERY%{$reset_color%}"
}

__rbenv_version() {
  if which rbenv &> /dev/null; then
    VERSION="$(rbenv version-name)"
    if [ $VERSION != "system" ]; then
      echo "%{$fg[red]%}[$VERSION]%{$reset_color%}"
    fi
  fi
}

__pyenv_version() {
  if which pyenv &> /dev/null; then
    VERSION="$(pyenv version-name)"
    if [ $VERSION != "system" ]; then
      echo "%{$fg[green]%}[$VERSION]%{$reset_color%}"
    fi
  fi
}

RPS1='$(__git_ps1)$(__rbenv_version)$(__pyenv_version)'

if _battery-available ; then
  PROMPT='%{$fg[cyan]%}[%m/%n][%~]%{$reset_color%}$(__battery_ps1)
%(?.%{$fg[green]%}.%{$fg[red]%})%B%(!.#.$)%b%{$reset_color%} '
else
  PROMPT='%{$fg[cyan]%}[%m/%n][%~]%{$reset_color%}
%(?.%{$fg[green]%}.%{$fg[red]%})%B%(!.#.$)%b%{$reset_color%} '
fi
