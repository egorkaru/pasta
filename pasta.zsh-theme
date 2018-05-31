# vcs_info:
# %b => current branch
# %a => current action (rebase/merge)
# %s => current version control system
# %r => name of the root directory of the repository
# %S => current path relative to the repository root directory
# %m => in case of Git, show information about stashes
# %u => show unstaged changes in the repository
# %c => show staged changes in the repository
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)
# terminal codes:
# \e7   => save cursor position
# \e[2A => move cursor 2 lines up
# \e[1G => go to position 1 in terminal
# \e8   => restore cursor position
# \e[K  => clears everything after the cursor on the current line
# \e[2K => clear everything on the current line

# Git status symbols
ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{red}%%"
ZSH_THEME_GIT_PROMPT_ADDED="%F{green}✓"
ZSH_THEME_GIT_PROMPT_MODIFIED="%F{blue}*"
ZSH_THEME_GIT_PROMPT_DELETED="%F{red}✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%F{blue}~"
ZSH_THEME_GIT_PROMPT_UNMERGED="%F{cyan}#"

ZSH_THEME_GIT_PROMPT_PREFIX="%F{white}✶ %f%F{yellow}"
ZSH_THEME_GIT_PROMPT_SUFFIX=" ⇣%f "

PASTA_TIMESTAMP_FORMAT="${PASTA_TIMESTAMP_FORMAT:-%H:%M}"
PASTA_PROMPT="${PASTA_PROMPT:-❯}"
PASTA_NVM="${PASTA_NVM:-true}"

# turns seconds into human readable time
# 165392 => 1d 21h 56m 32s
prompt_human_time() {
	local tmp=$1
	local days=$(( tmp / 60 / 60 / 24 ))
	local hours=$(( tmp / 60 / 60 % 24 ))
	local minutes=$(( tmp / 60 % 60 ))
	local seconds=$(( tmp % 60 ))
	echo -n "⌚︎ "
	(( $days > 0 )) && echo -n "${days}d "
	(( $hours > 0 )) && echo -n "${hours}h "
	(( $minutes > 0 )) && echo -n "${minutes}m "
	echo "${seconds}s"
}

prompt_cmd_exec_time() {
	local stop=$EPOCHSECONDS
	local start=${cmd_timestamp:-$stop}
	integer elapsed=$stop-$start
	(($elapsed > ${CMD_MAX_EXEC_TIME:=5})) && prompt_human_time $elapsed
}

prompt_preexec() {
	cmd_timestamp=$EPOCHSECONDS

	# shows the current dir and executed command in the title when a process is active
	print -Pn "\e]0;"
	echo -nE "$PWD:t: $2"
	print -Pn "\a"
}


prompt_precmd() {
	# shows the full path in the title
	print -Pn '\e]0;%~\a'

	print -P ' %F{yellow}`prompt_cmd_exec_time`%f'

	# reset value since `preexec` isn't always triggered
	unset cmd_timestamp
}

# Prompt symbol
pasta_symbol() {
    echo -n "%(?.%F{magenta}.%F{red})${PASTA_PROMPT}%f "
}

# Username
pasta_user() {
    if [[ $USER == 'root' ]]; then
        echo -n "%F{red}"
    else
        echo -n "%F{magenta}"
        fi
    echo -n "%n%f"
}

# Username and ssh host
pasta_host() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo -n "$(pasta_user)%F{white}@%m%f "
  else
    echo -n "$(pasta_user) "
  fi
}

# Current directory
pasta_current_dir() {
  echo -n "%F{cyan}%~%f "
}

# time
pasta_timestamp(){
   echo -n "%F{white}%D{${PASTA_TIMESTAMP_FORMAT}}%f "
}

pasta_nvm_status() {
  #[[ $PASTA_NVM == false ]] && return

  [[ -f package.json || -d node_modules ]] || return

  command -v nvm > /dev/null 2>&1 || return

  local nvm_status=$(nvm current 2>/dev/null)
  [[ "${nvm_status}" == "system" || "${nvm_status}" == "node" ]] && nvm_status=$(node -v 2>/dev/null)

  echo -n "%F{green}⬢ ${nvm_status}%f "
}


# Git status
pasta_git_status() {
  echo -n "$(git_prompt_info)$(git_prompt_status)$f"
}

# Compose prompt

prompt_setup() {
	# prevent percentage showing up
	# if output doesn't end with a newline
	export PROMPT_EOL_MARK=''

	prompt_opts=(cr subst percent)

	zmodload zsh/datetime
	autoload -Uz add-zsh-hook
	autoload -Uz vcs_info

	add-zsh-hook precmd prompt_precmd
	add-zsh-hook preexec prompt_preexec

    NEWLINE=$'\n'
    [[ ${DISPLAY_EXIT_STATUS:-1} ]] && RPROMPT+='%F{red}%(?..⏎)%f '
    RPROMPT+='$(pasta_nvm_status)$(pasta_timestamp)'
    PROMPT='$(pasta_host)$(pasta_current_dir)$(pasta_git_status)${NEWLINE}$(pasta_symbol)'
}

prompt_setup "$@"