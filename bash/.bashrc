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

source ~/.bash/variables.sh
#source ~/.bash/prompt.sh
source ~/.bash/aliases.sh
for script in ~/.bash/functions/*.sh; do
    source $script
done

# Enable bash completion
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Activate the conda environment in the current dir (if there is one)
if [ -f environment.yml ]; then
    yv
fi

eval "$(starship init bash)"
