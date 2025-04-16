source "$HOME/.bash/variables.sh"
source "$HOME/.bash/prompt.sh"
source "$HOME/.bash/aliases.sh"
for script in "$HOME"/.bash/functions/*.sh; do
    source "$script"
done

# Enable bash completion
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Activate the conda environment in the current dir (if there is one)
if [ -f environment.yml ]; then
    yv
fi

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE='/home/leo/bin/miniforge3/bin/mamba';
export MAMBA_ROOT_PREFIX='/home/leo/bin/miniforge3';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
