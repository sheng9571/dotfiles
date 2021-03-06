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
	alias p='ps axT -o "uname=user,tty=tty,ppid=pid,pid=tid,%cpu=cpu,%mem=mem,cmd=args"'
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

# bindkey to fix home & end
# home
bindkey "^[[1~" beginning-of-line
# end
bindkey "^[[4~" end-of-line


# common command 
alias shutdown='shutdown -h now'
alias reboot='shutdown -r now'

alias ip='curl ifconfig.co'

alias dkpa='docker ps -a'
alias dki='docker images'
alias dkc='docker-compose'

alias h=history
alias mkdir='mkdir -p'
alias cls='clear'

alias tgz='tar -zxvf'

alias ifc='/sbin/ifconfig'

alias py=python
alias py3=python3
# alias -s jar='java -jar'

alias tml='tmux ls'
alias tma='tmux attach-session -t'
alias tmd='tmux detach'
alias tmda='tmux detach -a'

# vimdiff vertically split
alias vd='vimdiff'
# vimdiff horizontally split
alias vdh='vimdiff -o'

alias gdb='gdb -q'
alias gef='gdb -q -x ~/gdb/gef.py'

alias dkcu='docker-compose up -d'
alias dkcur='docker-compose up -d --force-recreate --build'
alias dkcd='docker-compose down'
alias dkcl='docker-compose logs'

alias xxd='xxd -u'
alias hexdump='hexdump -vC'

alias nmp='nmap -vv -sS -sV -O -F -T5 -e eth0 -g 9453'

# others alias on different os
if [ `uname` = "Linux" ]; then
 	str="$(uname -a)"
 	substr="raspberry"
 	if test "${str#*$substr}" != "$str"
 	then
 		# raspberry
     
        # ---------- nc ----------
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
        # ---------- nc ----------
        
        
        # ---------- od ----------
        alias od='od -tx1z -Ax -v'
        # ---------- od ----------
        
        
        # ---------- readelf ----------
        alias relf='readelf -e'
        # ---------- readelf ----------
    

        # ---------- objdump ----------
        alias objdump='objdump -M intel'
        alias obd='objdump -d'
        # ---------- objdump ----------


 	else
 		# Other linux distribution

        # ---------- nc ----------
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
        # ---------- nc ----------
        
        
        # ---------- od ----------
        alias od='od -tx1z -Ax -v'
        # ---------- od ----------
        
        
        # ---------- readelf ----------
        alias relf='readelf -e'
        # ---------- readelf ----------
    
        # ---------- objdump ----------
        alias objdump='objdump -M intel'
        alias obd='objdump -d'
        # ---------- objdump ----------

 	fi
elif [ `uname` = "freebsd" ]; then
 	# FreeBSD


    # ---------- nc ----------
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
    # ---------- nc ----------
        
    
    # ---------- od ----------
    alias od='od -tx1z -Ax -v'
    # ---------- od ----------
        
    
    # ---------- readelf ----------
    alias relf='readelf -e'
    # ---------- readelf ----------
        
    
    # ---------- objdump ----------
    alias objdump='objdump -M intel'
    alias obd='objdump -d'
    # ---------- objdump ----------


elif [ `uname` = "Darwin" ]; then
	# Mac OS


    # ---------- nc ----------
    # priority to use ncat then nc
    file="$(which /usr/local/bin/ncat)"
    if [ ! -e "$file" ]
    then
        # mac os built-in nc has -e parameter

        # server, tcp
        alias ncs='/usr/local/bin/nc -lvnp 9453'
        # server, udp
        alias ncsu='/usr/local/bin/nc -lvnup 9453'

        # client, tcp, ipv4, reverse shell
        alias ncc='/usr/local/bin/nc -e /bin/sh'
        # client, udp, ipv4
        alias nccu='/usr/local/bin/nc -u'

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
    # ---------- nc ----------
        
    
    # ---------- od ----------
    alias od='od -tx1 -Ax -v'
    # ---------- od ----------
        
    
    # ---------- readelf ----------
    # alias relf='readelf.py -e'
    # ---------- readelf ----------


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
    docker exec -it $1 /usr/bin/zsh 2>/dev/null ||
    docker exec -it $1 /bin/bash 2>/dev/null ||
    docker exec -it $1 /bin/ash 2>/dev/null ||
    docker exec -it $1 /bin/sh 2>/dev/null ||
    echo No such shll in container!
}


# Docker stop and rm container
function dksr() {
    docker stop $1 && docker rm $1
}


# Docker rm image
function dkri() {
    docker image rm -f $1
}


# Get Docker image's IP
function dkip() {
    docker inspect $1 | grep "IPAddress"
}


# GDB attach bug
function gdbattach() {
	echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
}


# vimdiff hex mode vertically split
function vdx() {
    f1_len=${#1}
    f2_len=${#2}

    if [[ "$f1_len" -gt 0 && "f2_len" -gt 0 ]]; then
        vimdiff <(xxd $1) <(xxd $2)
    else
        echo Must give two files!
    fi
}

# vimdiff hex mode horizontally split
function vdxh() {
    f1_len=${#1}
    f2_len=${#2}

    if [[ "$f1_len" -gt 0 && "f2_len" -gt 0 ]]; then
        vimdiff -o <(xxd $1) <(xxd $2)
    else
        echo Must give two files!
    fi
}
