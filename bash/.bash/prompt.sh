# Set the prompt style to include the conda env and git repository status
#
# Started out as an apdaptation of [1] but I ended up completely rewriting
# everything using only bash. The result is faster and probably won't break
# between Python versions.
#
# [1]: https://github.com/magicmonty/bash-git-prompt
#
# Find color codes here: https://en.wikipedia.org/wiki/ANSI_escape_code

set_prompt()
{
    # Set the PS1 configuration for the prompt

    local reset_color="\[\033[0m\]"

    # Variables used to configure the prompt
    local user="\[\e[38;2;166;227;161m\]`whoami`:$reset_color\[\e[38;2;166;227;161;1m\]`hostname`$reset_color"
    local end="\[\e[38;2;250;179;135;1m\]❱$reset_color"
    local start="\n"

    # Build the prompt one piece at a time
    local prompt="$start$user"

    # Python environment name and version
    local python_status="`make_python_prompt`"
    if [[ -n $python_status ]]; then
        local prompt="$prompt $python_status$reset_color"
    fi

    # Git repository status
    local git_status="`make_git_prompt`"
    if [[ -n $git_status ]]; then
        local prompt="$prompt $git_status$reset_color"
    fi

    # Make the path, including a marker to show that it's running remotely
    local path="\[\e[38;242;205;205;1m\]\w$reset_color"
    if [[ -n `is_remote` ]]; then
        local path="\[\e[38;5;208;1m\]ssh:$reset_color$path"
    fi

    local prompt="$prompt $path\n$end "

    # Set the terminal background color
    printf %b '\e]11;#0D1117\a'

    PS1="$prompt"
}


PROMPT_COMMAND=set_prompt


is_remote ()
{
    # See https://unix.stackexchange.com/questions/9605/how-can-i-detect-if-the-shell-is-controlled-from-ssh
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        echo "true"
    else
        echo ""
    fi
}


make_python_prompt ()
{
    local python_env="`get_conda_env`"
    if [[ -n $python_env ]]; then
        echo "\[\e[38;2;250;179;135m\]env:\[\e[38;2;250;179;135;1m\]$python_env{\[\e[33;0m\]\[\e[38;245;224;220m\]`get_python_version`\[\e[38;2;250;179;135;1m\]}\[\e[33;0m\]"
    else
        echo ""
    fi
}


make_git_prompt ()
{
    if inside_git_repo; then
        # Default values for the appearance of the prompt.
        local style="\[\e[38;2;137;180;250;1m\]"
        local changed="\[\e[38;2;166;227;161;1m\]+"
        local staged="\[\e[38;2;203;166;247;1m\]•"
        local untracked="\[\e[38;2;242;205;205;1m\]?"
        local conflict="\[\e[38;2;243;139;168;1m\]x"
        local ahead="\[\e[38;2;249;226;175;1m\]↑"
        local behind="\[\e[38;2;250;179;135;1m\]↓"
        local noremote="\[\e[38;2;245;194;231;1m\]⑂"
        local sep=""

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

        local remote_status=`git rev-list --left-right --count @{u}...HEAD 2> /dev/null`
        local remote_behind=$(echo $remote_status | cut -f 1 -d " ")
        local remote_ahead=$(echo $remote_status | cut -f 2 -d " ")
        if [[ -z $remote_status ]]; then
            if [[ -n $status ]]; then
                local status="$status$sep"
            fi
            local status="$status$noremote"
        fi
        if [[ $remote_ahead -gt 0 ]]; then
            if [[ -n $status ]]; then
                local status="$status$sep"
            fi
            local status="$status$ahead$remote_ahead"
        fi
        if [[ $remote_behind -gt 0 ]]; then
            if [[ -n $status ]]; then
                local status="$status$sep"
            fi
            local status="$status$behind$remote_behind"
        fi

        local branch=`get_git_branch`

        # Append the git info to the PS1
        local git_prompt="\[\e[38;2;137;180;250m\]git:$style$branch"
        if [[ -n $status ]]; then
            local git_prompt="$git_prompt{$status$style}"
        fi

        echo "$git_prompt"
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

inside_git_repo() {
    # Test if inside a git repository. Will fail is not.
    git rev-parse --is-inside-work-tree 2> /dev/null > /dev/null
}
