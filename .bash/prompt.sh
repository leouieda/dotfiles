# Set the prompt style to include the conda env and git repository status
#
# Started out as an apdaptation of https://github.com/magicmonty/bash-git-prompt
# but I ended up completely re-implementing everything using only bash.
# The result is faster and probably won't break between Python versions.
#
# Color codes are for 8-bit ANSI: https://en.wikipedia.org/wiki/ANSI_escape_code


set_prompt()
{
    # Set the PS1 configuration for the prompt

    local reset_color="\[\033[0m\]"

    # Basic first part of the PS1 prompt
    local host="\[\e[38;5;196;1m\]`hostname`$reset_color"
    local user="\[\e[38;5;34;1m\]`whoami`$reset_color"
    local path="\[\e[38;5;254;1m\]`pwd`$reset_color"
    local end="\n\[\e[1;37m\]> $reset_color"

    # Python environment name and version
    local python_env="\[\e[38;5;221;1m\]py:`get_python_version`"
    local python_env_name=`get_conda_env`
    if [[ -n $python_env_name ]]; then
       local python_env="$python_env|$python_env_name"
    fi
    local python_env="$python_env$reset_color"

    # Git repository status
    local git_prompt="`make_git_prompt`"

    local status="$python_env"

    if [[ -n $git_prompt ]]; then
        local status="$status $git_prompt"
    fi

    PS1="\e[1;37m\]($status\e[1;37m\])$reset_color $user at $host in $path$end"
}


PROMPT_COMMAND=set_prompt


make_git_prompt ()
{
    local reset_color="\[\033[0m\]"

    if inside_git_repo; then
        # Default values for the appearance of the prompt.
        local style="\[\e[38;5;33;1m\]"
        local changed="\[\e[1;93m\]+"
        local staged="\[\e[1;91m\]•"
        local untracked="\[\e[1;37m\]?"
        local conflict="\[\e[1;91m\]x"
        local ahead="$style↑"
        local behind="$style↓"
        local diverged="$style⑂"
        local sep="$style."

        # Construct the status info (how many files changed, etc)
        local status=""

        local files_changed=`git diff --numstat | wc -l`
        if [[ $files_changed -ne 0 ]]; then
            if [[ -n $status ]]; then
                local status="$status$sep"
            fi
            local status="$status$changed$files_changed"
        fi

        local files_staged=`git diff --cached --numstat | wc -l`
        if [[ $files_staged -ne 0 ]]; then
            if [[ -n $status ]]; then
                local status="$status$sep"
            fi
            local status="$status$staged$files_staged"
        fi

        local files_conflict=`git diff --name-only --diff-filter=U | wc -l`
        if [[ $files_conflict -ne 0 ]]; then
            if [[ -n $status ]]; then
                local status="$status$sep"
            fi
            local status="$status$conflict$files_conflict"
        fi

        local files_untracked=`git ls-files --others --exclude-standard | wc -l`
        if [[ $files_untracked -ne 0 ]]; then
            if [[ -n $status ]]; then
                local status="$status$sep"
            fi
            local status="$status$untracked$files_untracked"
        fi

        local remote_status=`get_git_remote_status`
        if [[ $remote_status == "ahead" ]]; then
            local remote="$ahead"
        elif [[ $remote_status == "behind" ]]; then
            local remote="$behind"
        elif [[ $remote_status == "diverged" ]]; then
            local remote="$diverged"
        else
            local remote=""
        fi
        if [[ -n $remote ]]; then
            if [[ -n $status ]]; then
                local status="$status$sep"
            fi
            local status="$status$remote"
        fi

        local branch=`get_git_branch`

        # Append the git info to the PS1
        local git_prompt="$style⎇ $branch"
        if [[ -n $status ]]; then
            local git_prompt="$git_prompt|$status"
        fi

        echo "$git_prompt$reset_color"
    else
        echo ""
    fi
}


get_conda_env ()
{
    # Determine active conda env details
    local env_name=""
    if [[ ! -z $CONDA_DEFAULT_ENV ]]; then
        local env_name="`basename \"$CONDA_DEFAULT_ENV\"`"
    fi
    echo $env_name
}

get_python_version ()
{
    echo "$(python -c 'from __future__ import print_function; import sys; print(".".join(map(str, sys.version_info[:2])))')"
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
    local upstream=${1:-'@{u}'}
    local local=$(git rev-parse @ 2> /dev/null)
    local remote=$(git rev-parse "$upstream" 2> /dev/null)
    local base=$(git merge-base @ "$upstream" 2> /dev/null)

    if [[ $local == $remote ]]; then
        echo "updated"
    elif [[ $local == $base ]]; then
        echo "behind"
    elif [[ $remote == $base ]]; then
        echo "ahead"
    else
        echo "diverged"
    fi
}


inside_git_repo() {
    # Test if inside a git repository. Will fail is not.
    git rev-parse --is-inside-work-tree 2> /dev/null > /dev/null
}
