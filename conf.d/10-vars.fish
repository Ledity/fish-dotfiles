if status is-interactive
    if type nvim &>/dev/null
        set -x MANPAGER nvim +Man!
    end

    # setup sudo prompt
    set -x SUDO_PROMPT \a"[sudo] введите пароль: "

    # set $EDITOR
    set -x EDITOR nvim

    # set $SSH_AUTH_SOCK
    set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

    if type go &>/dev/null
        set -x GOPATH $HOME/.local/go
    end

    if type hx &>/dev/null
        set -x PATH $PATH "$HOME/.local/share/helix/LSP/bin"
    end
end
