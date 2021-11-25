# If not running interactively, don't do anything
[ -z "$PS1" ] && return

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
stty -echoctl
bind "set mark-symlinked-directories on"

unset HISTFILE
export HISTCONTROL=ignoreboth
export PS1='\[\e[0;32m\][\[\e[0;37m\]\u@\h\[\e[0;32m\]]\[\e[0;37m\]\$ '
export LESSOPEN='|lesspipe.sh %s'
export LESS='-R -i --use-color -Dd+r$Du+b'
export LESSHISTFILE=/dev/null
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export LANG='en_US.UTF-8'
export BROWSER='firefox'
export EDITOR='vim'

export FZF_CTRL_T_COMMAND='fd -H'

export CARGO_HOME=/tmp/cargo

dumpcrt() {

    if [[ $# -ne 1 || $1 != *:* ]]; then
        echo -e 'ENOPE:\n  openssl s_client -connect host:port' >&2
        return
    fi

    nc -z $host $port

    IFS=':' read host port <<< $1
    if [[ $? -ne 0 ]]; then
        echo -e "ENOPE:\n Failed to connect to $host:$port" >&2
        return
    fi

    openssl s_client -connect $1 < /dev/null 2>/dev/null | \
    sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' | \
    openssl x509 -noout -text -in /dev/stdin | grep -i     \
    -e 'issuer:' -e 'validity:' -e 'subject:'
}


alias ls='exa -F --octal-permissions -g'
alias fzf='fzf --ansi'
alias replace='sd'

alias grep='grep --color=auto'
alias ip='ip --color=auto'
alias diff='diff --color=auto'
alias radio='mpv https://somafm.com/groovesalad.pls'
alias totp="oathtool -b --totp"
alias yt='mpv -ytdl-format=best'
alias 4='ping ifconfig.me'
alias 6='ping6 ipv6.google.com'
alias myip='curl ifconfig.me/ip'
alias speedtest='wget http://wipkip.nikhef.nl/1000mb.bin -O /dev/null'
alias p='proxychains -q '
alias venv='python -m venv /tmp/v; source /tmp/v/bin/activate; cd /tmp/v'
alias fileshare='python ~/bin/fileshare.py'
alias kvm='qemu-system-x86_64 --enable-kvm -m 12000 -monitor stdio -usbdevice tablet -vga virtio -cdrom'
alias np='playerctl metadata | grep title |cut -d" " -f19-'

cat ~/.cache/wal/sequences
source ~/.cache/wal/colors-tty.sh

[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash
