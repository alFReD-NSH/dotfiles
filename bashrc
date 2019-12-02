# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

SHELL_SESSION_HISTORY=0

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=
HISTFILESIZE=

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

PROMPT_COMMAND="history -a; $RPOMPT_COMMAND"

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
#force_color_prompt=yes

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

# For Mac OS X colors
export CLICOLOR=1
# export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export GREP_COLOR='1;35;40'

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
    . /etc/bash_completion &
fi

# You will know how awesome are these things if you use them...
#alias p='xclip -o -selection clipboard'
#alias c='xclip -selection clipboard'
alias p='pbpaste'
alias c='pbcopy'
alias g='git'
alias rd='rm -rf'
alias vim="mvim -v"
alias vi="vim"

# unzip stream, will extract everything going to its stdin
alias unzips="python -c \"import zipfile,sys,StringIO;zipfile.ZipFile(StringIO.StringIO(sys.stdin.read())).extractall(sys.argv[1] if len(sys.argv) == 2 else '.')\""

# Searches for js files that are not minified and also add line number
alias search="find . -not -name '*min*' -name '*.js' -print0 | xargs -0 grep -n"

# Usage : vimo file:linenumber >>> Will open a file in that line number in vim

vimo(){

    # Loop in the arguments
    for f in $*
    do
        # Split the strings
        lolz=($(echo $f | tr ":" " "))
        
        # Make part of the command
        vimos=$vimos" +"${lolz[1]}" "${lolz[0]}

    done
    
    # Now call the master to see what we have done!
    vim -p $vimos

    # Just empty it for the next time...
    vimos=""
}

export -f vimo

export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"
nvm use stable

. /usr/local/opt/nvm/etc/bash_completion.d/nvm &
. ~/.git-completion.bash &
. <(npm completion)

# VIM bash bindings FTW!
set -o vi 

#source $HOME/.cargo/env
export GOPATH="/Users/farid/repos/go"
PATH="/Users/farid/Library/Python/3.7/bin:$GOPATH/bin:$PATH"

source <(kubectl completion bash)

alias t='sleep 1; p | { read text; xdotool type $text; }'

export NODE_ENV=development
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/repos
VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
source $(which virtualenvwrapper.sh)

#AWSume alias to source the AWSume script
alias awsume=". awsume"

#Auto-Complete function for AWSume

_awsume() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(awsumepy --rolesusers)
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}
complete -F _awsume awsume

