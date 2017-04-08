# Set the prompt style to include the conda env and git repository status
# Heavily
if [ "x$__GIT_PROMPT_DIR" == "x" ]
then
    __GIT_PROMPT_DIR=~/.bash
fi

set_prompt()
{
    # Set the PS1 configuration for the prompt

    # Various variables you might want for your PS1 prompt instead
    Time12a="\@"
    PathShort="\w"
    ResetColor="\[\033[0m\]"

    # Default values for the appearance of the prompt.
    GIT_PROMPT_STYLE="\[\e[0;97;104m\]"
    GIT_PROMPT_PREFIX="$GIT_PROMPT_STYLE "
    GIT_PROMPT_SUFFIX=" "
    GIT_PROMPT_SEPARATOR=""
    GIT_PROMPT_BRANCH=""
    GIT_PROMPT_STAGED="\[\e[0;91;104m\] ● "
    GIT_PROMPT_CONFLICTS="\[\e[0;91;104m\] ✖ "
    GIT_PROMPT_CHANGED="\[\e[0;93;104m\] ✚ "
    GIT_PROMPT_REMOTE_AHEAD="$GIT_PROMPT_STYLE↑ "
    GIT_PROMPT_REMOTE_BEHIND="$GIT_PROMPT_STYLE↓ "
    GIT_PROMPT_UNTRACKED="$GIT_PROMPT_STYLE …"
    GIT_PROMPT_DIVERGED="$GIT_PROMPT_STYLE ⑂"
    GIT_PROMPT_CLEAN="$GIT_PROMPT_STYLE ✓"

    PROMPT_START="\[\e[0;97;100m\] `whoami`@`hostname` "
    PROMPT_PATH="\[\e[0;97;100m\] $PathShort "
    PROMPT_END="$ResetColor $ "

    PYTHON_ENV_STYLE="\[\e[0;30;103m\]"


    local python_env=$PYTHON_ENV_STYLE" `get_conda_env` "

    if inside_git_repo; then
        update_current_git_vars
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
        STATUS="$STATUS$GIT_PROMPT_SUFFIX"

        PS1="$PROMPT_START$python_env$STATUS$PROMPT_PATH$PROMPT_END"
    else
        PS1="$PROMPT_START$python_env$PROMPT_PATH$PROMPT_END"
    fi
}


PROMPT_COMMAND=set_prompt


get_conda_env ()
{
    # Determine active conda env details
    local env_name="root"
    if [[ ! -z $CONDA_DEFAULT_ENV ]]; then
        local env_name="`basename \"$CONDA_DEFAULT_ENV\"`"
    fi
    local python_version="$(python -c 'from __future__ import print_function; import sys; print(".".join(map(str, sys.version_info[:2])))')"
    echo "$env_name-$python_version"
}


get_git_branch()
{
    # Get the name of the current git branch
    local branch=`git branch | grep "\* *" | sed -n -e "s/\* //p"`
    if [[ -z `echo $branch | grep "\(detached from *\)"` ]]; then
        echo $branch;
    else
        # In case of detached head, get the commit hash
        echo $branch | sed -n -e "s/(detached from //p" | sed -n -e "s/)//p";
    fi
}


get_git_remote_status()
{
    # Get the status regarding the remote
    local UPSTREAM=${1:-'@{u}'}
    local LOCAL=$(git rev-parse @)
    local REMOTE=$(git rev-parse "$UPSTREAM")
    local BASE=$(git merge-base @ "$UPSTREAM")

    if [ $LOCAL = $REMOTE ]; then
        echo "updated"
    elif [ $LOCAL = $BASE ]; then
        echo "behind"
    elif [ $REMOTE = $BASE ]; then
        echo "ahead"
    else
        echo "diverged"
    fi
}


inside_git_repo() {
    # Test if inside a git repository. Will fail is not.
    git rev-parse --is-inside-work-tree 2> /dev/null > /dev/null
}


update_current_git_vars()
{
    unset __CURRENT_GIT_STATUS
    local gitstatus="${__GIT_PROMPT_DIR}/gitstatus.py"

    _GIT_STATUS=$(python $gitstatus)
    __CURRENT_GIT_STATUS=($_GIT_STATUS)
    GIT_BRANCH=`get_git_branch`
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
