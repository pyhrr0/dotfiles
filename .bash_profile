# Read Bash settings file (Get private aliases & functions)
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# Start X if not a Telnet/SSH Session.
# (... X then reads .xinitrc to start DWM)
if [ -n $SSH_CONNECTION ] && [ $(tty) = '/dev/tty1' ] ; then
    exec startx -- -nolisten tcp
fi

