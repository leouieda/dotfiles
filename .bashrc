if [ -f ~/.bash/variables.sh ]; then
    source ~/.bash/variables.sh
fi

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

# Start ssh-agent automatically if it hasn't been started alredy
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-thing
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval "$(<~/.ssh-agent-thing)" > /dev/null
fi

# Setup and activate the conda package manager
if [ -f $HOME/bin/conda/etc/profile.d/conda.sh ]; then
    source "$HOME/bin/conda/etc/profile.d/conda.sh"
    conda activate
    # Activate the conda environment
    if [ -f environment.yml ]; then
        cenv environment.yml
    fi
fi
