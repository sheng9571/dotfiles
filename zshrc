#
# Official Sample: http://zsh.sourceforge.net/Contrib/startup/std/zshrc

# enable command substition in prompt
setopt prompt_subst
autoload -Uz vcs_info

# ----- Git status -----
function +vi-git_status {
  # Check for untracked files or updated submodules since vcs_info does not.
  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    hook_com[unstaged]='%F{red}✘%f'
  fi
}
zstyle ':vcs_info:*' enable bzr git hg svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{green}✔%f'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}!%f'
zstyle ':vcs_info:*' formats '  %b%c%u'
zstyle ':vcs_info:*' actionformats " - [%b%c%u|%F{cyan}%a%f]"
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b|%F{cyan}%r%f'
zstyle ':vcs_info:git*+set-message:*' hooks git_status
zstyle ':completion:*' use-ip true

ASYNC_PROC=0
ASYNC_DATA="/tmp/${USER}-prompt_sorin_data"

function precmd() {

    function async() {
        vcs_info
        # save to temp file
        printf "%s" "${vcs_info_msg_0_}" > $ASYNC_DATA
        # signal parent
        kill -s USR1 $$
    }
    # do not clear RPROMPT, let it persist
    # kill child if necessary
    if [[ "${ASYNC_PROC}" != 0 ]]; then
        kill -s HUP $ASYNC_PROC >/dev/null 2>&1 || :
    fi
    # start background computation
    async &!
    ASYNC_PROC=$!
}

function TRAPUSR1() {
    # read from temp file
    RPROMPT="$(cat $ASYNC_DATA)"
    # reset proc number
    ASYNC_PROC=0
    # redisplay
    zle && zle reset-prompt
}
# ----- Git status -----


# sell color: user@server:path
if [ `id -u` = 0 ]; then
    PROMPT='%F{160}%n%F{244}@%F{160}%m%f:%F{35}%~%f# '
    RPROMPT=''
else
    PROMPT='%F{75}%n%F{244}@%F{75}%m%f:%F{166}%~%f$ '
    RPROMPT=''
fi
# sell color: user@server:path


# Recognize OS
# if [ `uname` = "Linux" ]; then
# 	str="$(uname -a)"
# 	substr="raspberry"
# 	if test "${str#*$substr}" != "$str"
# 	then
# 		# raspberry
# 		echo "raspberry pi"
# 	else
# 		# Other linux distribution
# 		echo "Ubuntu or other distribution"
# 	fi
# elif [ `uname` = "freebsd" ]; then
# 	# FreeBSD
# 	echo "FreeBSD"
# elif [ `uname` = "Darwin" ]; then
# 	# Mac OS
# 	echo "Darwin"
# fi

# Language
str="$(uname -a)"
substr="raspberry"
if test "${str#*$substr}" != "$str"
then
	# raspberry
	# raspberry does not support LANGUAGE config settings
else
	# Other linux distribution
	export LANGUAGE="en_US.UTF-8"
	export LANG="en_US.UTF-8"
	export LC_ALL="en_US.UTF-8"
fi


# Colors
# tmux colors
export TERM=xterm-256color
# Define colors for BSD ls.
export LSCOLORS='gxfxcxdxbxGxDxabagacad'
# Define colors for the completion system.
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# 
# # Set up aliases
if ls --color -d . &>/dev/null 2>&1
then
	# Linux Style
	# alias ls='ls --color=tty'
	alias ls='ls -G --color=tty'
	alias ll='ls -ahlF --time-style="+%Y-%m-%d %H:%M:%S"'
	alias p='ps aT -o "uname=user,tty=tty,ppid=pid,pid=tid,%cpu=cpu,%mem=mem,cmd=args"'
	alias pp='ps T -o "uname=user,tty=tty,ppid=pid,pid=tid,%cpu=cpu,%mem=mem,cmd=args" -p'
	alias df='df -hT'
	alias free='free -h'
	alias grep='grep --color'
else
	# BSD (MAC) Style
	alias ls='ls -G'
	alias ll='ls -ahlF'
	alias p='ps aT -o "user=user,tty=tty,ppid=pid,pid=tid,%cpu=cpu,%mem=mem,command=args"'
	alias pp='ps T -o "user=user,tty=tty,ppid=pid,pid=tid,%cpu=cpu,%mem=mem,command=args" -p'
	alias df='df -h'
	alias grep='grep --color=always'
fi


# history
HISTFILE=$HOME/.zsh_history
export HISTSIZE=1000
export SAVEHIST=1000
#以附加方式寫入歷史紀錄
setopt INC_APPEND_HISTORY
#如果連續命令相同,只留一
setopt HIST_IGNORE_DUPS
# core dump
limit coredumpsize 0


# common command 
alias shutdown='shutdown -h now'
alias reboot='shutdown -r now'

alias ip='curl ifconfig.co'

alias dkpa='docker ps -a'
alias dkc='docker-compose'

alias h=history
alias mkdir='mkdir -p'
alias cls='clear'

alias tgz='tar -zxvf'

alias ifc='/sbin/ifconfig'

alias py=python
# alias -s jar='java -jar'

# wget -O ~/.dotfiles/gdb/gef.py -q https://github.com/hugsy/gef/raw/master/gef.py
alias gdb='gdb -q'
alias gef='gdb -q -x ~/.dotfiles/gdb/gef.py'

# priority to use ncat then nc
file="$(which /usr/bin/ncat)"
if [ ! -e "$file" ]
then

	# try to find nc.traditional is exist or not
	file="/bin/nc.traditional"
	if [ ! -e "$file" ]
	then
		# server, tcp, ipv4
		alias ncs='nc -l4kvnp 9453'
		# server, udp, ipv4
		alias ncsu='nc -l4vnup 9453'

		# client, tcp, ipv4
		alias ncc='nc -4'
		# client, udp, ipv4
		alias nccu='nc -4u'
	else
		# has -e parameter
		# server, tcp, ipv4
		alias ncs='/bin/nc.traditional -lkvnp 9453'
		# server, udp, ipv4
		alias ncsu='/bin/nc.traditional -lvnup 9453'

		# client, tcp, ipv4, reverse shell
		alias ncc='/bin/nc.traditional -e /bin/sh'
		# client, udp, ipv4
		alias nccu='/bin/nc.traditional -u'
	fi

else
	# server, tcp, ipv4, ssl
	alias ncs='ncat -l4kvnp 9453 --ssl'
	# server, udp, ipv4
	alias ncsu='ncat -l4vnup 9453'

	# client, tcp, ipv4, ssl, reverse shell
	alias ncc='ncat -4 --ssl -e /bin/sh'
	# client, udp, ipv4
	alias nccu='ncat -4u'
fi

 

# alias git_current_branch='git rev-parse --abbrev-ref HEAD'
# alias g='git'
# alias gd='git diff'
# alias ga='git add'
# alias gcm='git commit --message'
# alias gp='git push'
# alias gl='git pull'
# alias gpc='git push --set-upstream origin "$(git_current_branch 2> /dev/null)"'
# alias gpp='git pull origin "$(git_current_branch 2> /dev/null)" && git push origin "$(git_current_branch 2> /dev/null)"'
# alias gc='git checkout'
# alias gb='git branch'
# alias gs='git status'

# alias pyh='python -m SimpleHTTPServer'
# alias phps='php -S 0.0.0.0:9000'

# alias mv='nocorrect mv'       # no spelling correction on mv
# alias cp='nocorrect cp'       # no spelling correction on cp
# alias j=jobs
# alias pu=pushd
# alias po=popd
# alias d='dirs -v'
# alias grep=egrep
# 


# completion
autoload -U compinit
compinit
#自動校正
setopt correct
#大小寫修正
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
#開啟補齊select顏色
zstyle ':completion:*:*:*:*:*' menu select


# Docker
function dk(){
    docker exec -it $1 zsh
}

# GDB attach bug
function gdbattach() {
	echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
}
# 
