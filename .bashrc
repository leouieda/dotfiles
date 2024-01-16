if [ -f ~/.bash/variables.sh ]; then
    source ~/.bash/variables.sh
fi

# Start ssh-agent automatically if it hasn't been started alredy
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-thing
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval "$(<~/.ssh-agent-thing)" > /dev/null
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/leo/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/leo/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/leo/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/leo/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/home/leo/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/home/leo/miniforge3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

if [ -f ~/.bash/prompt.sh ]; then
    export PROMPT_SHOW_PYTHON=true
    source ~/.bash/prompt.sh
fi

if [ -f ~/.bash/aliases.sh ]; then
    source ~/.bash/aliases.sh
fi

if [ -f ~/.bash/functions.sh ]; then
    source ~/.bash/functions.sh
fi

if [ -f ~/.bash/extra.sh ]; then
    source ~/.bash/extra.sh
fi

# Enable bash completion
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Activate the default conda environment
if [ -f environment.yml ]; then
    cenv environment.yml
fi
