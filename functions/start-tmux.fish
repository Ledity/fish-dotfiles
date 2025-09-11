function start-tmux
    set -f MAIN_SESSION_NAME MAIN

    if tmux ls | grep $MAIN_SESSION_NAME &>/dev/null
        tmux attach -t $MAIN_SESSION_NAME
    else
        tmux new -s $MAIN_SESSION_NAME
    end
end
