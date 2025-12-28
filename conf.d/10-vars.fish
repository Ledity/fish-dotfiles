if status is-interactive
    # if type nvim &>/dev/null
    #     set -x MANPAGER nvim +Man!
    # end

    # setup sudo prompt
    set -x SUDO_PROMPT \a"[sudo] введите пароль: "

    # set $SSH_AUTH_SOCK
    set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

    if type -q go && set -q GOPATH && test -d $GOPATH/bin
        fish_add_path --path $GOPATH/bin
    end

    if type -q cargo && set -q CARGO_HOME && test -d $CARGO_HOME/bin
        fish_add_path --path $CARGO_HOME/bin
    end

    if type -q hx
        set -gx EDITOR hx
    else if type -q helix
        set -gx EDITOR helix
    end

    if test -d $HOME/.local/bin
        fish_add_path --path $HOME/.local/bin
    end

    set -g fish_greeting
end
