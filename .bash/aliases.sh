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
alias cd='yv cd'

# Typos
alias cd..='cd ..'
alias gti='git'
alias gt='git'

# Open and copy
alias open='xdg-open'
alias copy='xclip -sel clip'

# Shortcuts
alias untar='tar -xvf'
alias untargz='tar -xzvf'
alias untarbz='tar -xjvf'
alias lab='jupyter lab'
alias v='nvim'
alias errcho='>&2 echo'

# Python dev
alias doc='open doc/_build/html/index.html'
alias pt='pytest --cov-report=term-missing --cov -v --doctest-modules'

# tmux
alias tmux='TERM=xterm-256color tmux'
alias ta='tmux attach -t'
alias tls='tmux list-sessions'
