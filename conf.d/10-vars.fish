if status is-interactive
    # if type nvim &>/dev/null
    #     set -x MANPAGER nvim +Man!
    # end

    # setup sudo prompt
    set -x SUDO_PROMPT \a"[sudo] введите пароль: "

    # set $SSH_AUTH_SOCK
    set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

    if type go &>/dev/null && set -q GOPATH && test -d $GOPATH/bin
        fish_add_path --path $GOPATH/bin
    end

    if type cargo &>/dev/null && set -q CARGO_PATH && test -d $CARGO_PATH/bin
        fish_add_path --path $CARGO_PATH/bin
    end

    if type hx &>/dev/null
        fish_add_path --path $HOME/.local/share/helix/LSP/bin
        # set $EDITOR
        set -x EDITOR hx
    end
end
