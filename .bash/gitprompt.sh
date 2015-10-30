if [ "x$__GIT_PROMPT_DIR" == "x" ]
then
  __GIT_PROMPT_DIR=~/.bash
fi

# Various variables you might want for your PS1 prompt instead
Time12a="\@"
PathShort="\w"

# Default values for the appearance of the prompt. Configure at will.
GIT_PROMPT_STYLE="\e[0;97;42m"
GIT_PROMPT_PREFIX="$GIT_PROMPT_STYLE "
GIT_PROMPT_SUFFIX=" "
GIT_PROMPT_SEPARATOR=""
GIT_PROMPT_BRANCH="$GIT_PROMPT_STYLE⎇  "
GIT_PROMPT_STAGED="\e[0;91;42m ● "
GIT_PROMPT_CONFLICTS="\e[0;91;42m ✖ "
GIT_PROMPT_CHANGED="\e[0;93;42m ✚ "
GIT_PROMPT_REMOTE_AHEAD="$GIT_PROMPT_STYLE↑ "
GIT_PROMPT_REMOTE_BEHIND="$GIT_PROMPT_STYLE↓ "
GIT_PROMPT_UNTRACKED="$GIT_PROMPT_STYLE …"
GIT_PROMPT_CLEAN=""

PROMPT_START="\e[0;97;104m `whoami`|`hostname` "
PROMPT_PATH="\e[0;97;100m $PathShort "
PROMPT_END="\e[0m $ "

PYTHON_ENV_STYLE="\e[1;30;103m"

function update_current_git_vars() {
    unset __CURRENT_GIT_STATUS
    local gitstatus="${__GIT_PROMPT_DIR}/gitstatus.py"

    _GIT_STATUS=$(python $gitstatus)
    __CURRENT_GIT_STATUS=($_GIT_STATUS)
	GIT_BRANCH=${__CURRENT_GIT_STATUS[0]}
	GIT_REMOTE_STATUS=${__CURRENT_GIT_STATUS[1]}
	GIT_REMOTE_NUM=${__CURRENT_GIT_STATUS[2]}
    if [[ "." == "$GIT_REMOTE_STATUS" ]]; then
		unset GIT_REMOTE
	fi
    if [[ "a" == "$GIT_REMOTE_STATUS" ]]; then
		GIT_REMOTE=$GIT_PROMPT_REMOTE_AHEAD$GIT_REMOTE_NUM
	fi
    if [[ "b" == "$GIT_REMOTE_STATUS" ]]; then
		GIT_REMOTE=$GIT_PROMPT_REMOTE_BEHIND$GIT_REMOTE_NUM
	fi
	GIT_STAGED=${__CURRENT_GIT_STATUS[3]}
	GIT_CONFLICTS=${__CURRENT_GIT_STATUS[4]}
	GIT_CHANGED=${__CURRENT_GIT_STATUS[5]}
	GIT_UNTRACKED=${__CURRENT_GIT_STATUS[6]}
	GIT_CLEAN=${__CURRENT_GIT_STATUS[7]}
}

function setGitPrompt() {
	update_current_git_vars
	set_virtualenv

	if [ -n "$__CURRENT_GIT_STATUS" ]; then
	  STATUS="$GIT_PROMPT_PREFIX$GIT_PROMPT_BRANCH$GIT_BRANCH"

	  if [ -n "$GIT_REMOTE" ]; then
		  STATUS="$STATUS$GIT_PROMPT_REMOTE$GIT_REMOTE"
	  fi

	  STATUS="$STATUS$GIT_PROMPT_SEPARATOR"
	  if [ "$GIT_STAGED" -ne "0" ]; then
		  STATUS="$STATUS$GIT_PROMPT_STAGED$GIT_STAGED"
	  fi

	  if [ "$GIT_CONFLICTS" -ne "0" ]; then
		  STATUS="$STATUS$GIT_PROMPT_CONFLICTS$GIT_CONFLICTS"
	  fi
	  if [ "$GIT_CHANGED" -ne "0" ]; then
		  STATUS="$STATUS$GIT_PROMPT_CHANGED$GIT_CHANGED"
	  fi
	  if [ "$GIT_UNTRACKED" -ne "0" ]; then
		  STATUS="$STATUS$GIT_PROMPT_UNTRACKED$GIT_UNTRACKED"
	  fi
	  if [ "$GIT_CLEAN" -eq "1" ]; then
		  STATUS="$STATUS$GIT_PROMPT_CLEAN"
	  fi
	  STATUS="$STATUS$GIT_PROMPT_SUFFIX"

	  PS1="$PROMPT_START$PYTHON_VIRTUALENV$STATUS$PROMPT_PATH$PROMPT_END"
	else
	  PS1="$PROMPT_START$PROMPT_PATH$PROMPT_END"
	fi
}

# Determine active Python conda env details.
function set_virtualenv () {
  if test -z "$CONDA_DEFAULT_ENV" ; then
      PYTHON_VIRTUALENV="$PYTHON_ENV_STYLE default "
  else
      PYTHON_VIRTUALENV="$PYTHON_ENV_STYLE `basename \"$CONDA_DEFAULT_ENV\"` "
  fi
}

PROMPT_COMMAND=setGitPrompt
