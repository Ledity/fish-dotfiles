function ssh --description 'alias ssh kitten ssh'
    if test "$TERM" = "xterm-kitty"
        kitten ssh $argv
    else
        command ssh $argv
    end
end
