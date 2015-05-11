# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# These are my personal changes
##############################################################################
export PATH=$HOME/bin:$PATH
export PATH=$HOME/bin/Copy:$PATH
export PATH=$HOME/src/tesseroids/bin:$PATH
export PATH=/usr/lib/gmt/bin:$PATH
export PATH=$HOME/bin/anaconda/bin:$PATH
export PYTHONPATH=$HOME/src/fatiando:$PYTHONPATH
# To avoid the QString error with Mayavi
export QT_API=pyqt
# Misc alias definitions
alias nb='ipython notebook --no-browser'
alias copy='xclip -sel clip'
alias nose='nosetests -v --with-doctest'
# git stuff
source ~/.bash/gitprompt.sh
# Anaconda stuff
export PATHBACK=$PATH
export CONDAPATH=$HOME/bin/anaconda/bin
alias condaon='export PATH=$CONDAPATH:$PATH'
alias condaoff='export PATH=$PATHBACK'
condaon
# Github
alias install-github='curl http://hub.github.com/standalone -sLo ~/bin/hub && chmod +x ~/bin/hub && wget https://raw.github.com/github/hub/master/etc/hub.bash_completion.sh -O ~/bin/hub.bash_completion.sh && source ~/bin/hub.bash_completion.sh'
if [ -f ~/bin/hub.bash_completion.sh ]; then
    source ~/bin/hub.bash_completion.sh
fi
# Aliases to extract tar files. Because I never remember the flags
alias untar='tar -xvf'
alias untargz='tar -xzvf'
alias untarbz='tar -xjvf'
# CUDA
export PATH=${PATH}:/usr/local/cuda-5.5/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda-5.5/lib64:/lib
# added by travis gem
[ -f /home/leo/.travis/travis.sh ] && source /home/leo/.travis/travis.sh
# FUNCTIONS TO EDIT PDFS
# Convert pdfs to ps with fonts converted to paths for editing in Inkscape
# Call it as: pdf2ps-nofonts INPUT.pdf OUTPUT.ps
# Based on the answer to this StackOverlow question:
# http://stackoverflow.com/questions/7131670/make-bash-alias-that-takes-parameter
# and this Ubuntu Forums question:
# http://ubuntuforums.org/showthread.php?t=1781049
pdf2ps-nofonts() {
    gs -sDEVICE=ps2write -dNOCACHE -sOutputFile=$2 -q -dbatch -dNOPAUSE $1 -c quit
}
# Convert a PDF from RGB to CMYK
# Call it as: pdfcmyk INPUT.pdf OUTPUT.pdf
# Based on http://zeroset.mnim.org/2014/07/14/save-a-pdf-to-cmyk-with-inkscape/
pdfcmyk() {
    gs -dSAFER -dBATCH -dNOPAUSE -dNOCACHE -sDEVICE=pdfwrite \
        -sColorConversionStrategy=CMYK -dProcessColorModel=/DeviceCMYK \
        -sOutputFile=$2 $1
}
# The Fuck (https://github.com/nvbn/thefuck)
alias fuck='eval $(thefuck $(fc -ln -1))'
alias FUCK='fuck'
