if status is-interactive
    if test \( "$TERM" = xterm-kitty \) \
            -o \( "$TERM" = alacritty \) \
            -o \( "$TERM" = xterm-256colors \) && ! set -q SSH_CLIENT
        if type toilet &>/dev/null
            if test -e '/usr/share/figlet/relief2.flf'
                toilet -f relief2 -F metal ' ledity '
            else
                toilet -F metal ledity
            end
        else
            printf "\n"
        end
    end

    set -x fish_greeting
end
