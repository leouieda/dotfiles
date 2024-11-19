# Alias definitions

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Open the IRPF 2017 app
alias irpf2017='sudo _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on" java -jar /home/leo/bin/IRPF2017/irpf.jar'

# Unix commands
alias ll='ls -lh'
alias la='ls -A'
alias du='du -sh'
alias cd='yavanna cd'

# Typos
alias cd..='cd ..'
alias gti='git'
alias gt='git'
alias gi='git'
alias mak='make'

# Open and copy
alias open='xdg-open'
alias copy='xclip -sel clip'

# Shortcuts
alias untar='tar -xvf'
alias untargz='tar -xzvf'
alias untarbz='tar -xjvf'
alias lab='cd ~ && yavanna && tmux new-session -s lab -d jupyter-lab && cd $OLDPWD'
alias nvim='~/bin/nvim.appimage'
alias v='~/bin/nvim.appimage'
alias m='make'
alias ms='make show'
alias errcho='>&2 echo'

# Git
alias gs='git status'
alias gc='git commit'
alias ga='git add'
alias gl='git pull'
alias gp='git push'
alias gm='git checkout main'
alias gd='git diff'
alias gds='git diff --staged'

# Python dev
alias doc='xdg-open doc/_build/html/index.html'
alias pt='pytest -v --doctest-modules'
alias p='python'
alias py='python'
alias y='yavanna'
alias yv='yavanna'
alias conda='mamba'

# tmux
alias tmux='TERM=xterm-256color tmux'
alias ta='tmux attach -t'
alias tls='tmux list-sessions'
