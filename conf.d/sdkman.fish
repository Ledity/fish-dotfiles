if status is-interactive # Commands to run in interactive sessions can go here
    if type bass &>/dev/null && test -e "$HOME/.sdkman/bin/sdkman-init.sh"
        bass source $HOME/.sdkman/bin/sdkman-init.sh
    end
end
