#!/bin/bash

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# History settings
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000000
HISTFILESIZE=2000000
shopt -s histappend
PROMPT_COMMAND='history -a'

shopt -s checkwinsize

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		color_prompt=yes
	fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

case "$TERM" in
xterm* | rxvt*)
	PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
	;;
*) ;;
esac

if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='command ls --color=auto'
	alias grep='command grep --color=auto'
	alias fgrep='command fgrep --color=auto'
	alias egrep='command egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

export PATH="$PATH:/root/.cargo/bin"
export PATH="$PATH:/root/go/bin"

export PYTHONPATH=/root/dapcs-offline-signing-conductor/src/common/

stty werase undef
bind '"\C-w": unix-filename-rubout'

alias dotfiles='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Mac-specific settings
if [[ $HOSTNAME =~ ^jasons-mbp.* ]]; then
	set -o ignoreeof
	export CLICOLOR=1
	export PATH="/Users/jasonhallman/.pyenv/bin:${PATH}"
	eval "$(/opt/homebrew/bin/brew shellenv)"
	[ -f ~/.git-completion.bash ] && . ~/.git-completion.bash
fi

_ssh() {
	local cur prev opts
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD - 1]}"
	opts=$(awk '/^Host / {print $2}' ~/.ssh/config ~/.ssh/config.d/* 2>/dev/null | grep -v '[?*]')
	COMPREPLY=($(compgen -W "$opts" -- ${cur}))
	return 0
}
complete -F _ssh ssh

setup_dapcs_env() {
	export PATH="/Users/jasonhallman/.pyenv/bin:${PATH}"
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
	eval "$(direnv hook bash)"
}

cd() {
	builtin cd "$@" || return
	if [[ $PWD == /Users/jasonhallman/dapcs/dapcs-offline-signing-conductor* ]]; then
		setup_dapcs_env
	fi
}

[ -x "$(command -v nvim)" ] && alias vi='nvim'

[ -x "$(command -v minikube)" ] && alias kubectl="minikube kubectl --"
