if status is-interactive # Commands to run in interactive sessions can go here
    abbr --add cl "clear && exec fish"

    if type -q just
        abbr --add j just
    end

    function _add_abbr_if_exists
        if test -d "$argv[2]"
            set -f dest "$(string escape --style=script -- $argv[2])"
            abbr --add "$argv[1]" --position=anywhere --set-cursor "$dest/%"
        end
    end

    _add_abbr_if_exists fish-d "$HOME/.config/fish"
    _add_abbr_if_exists fish-c "$HOME/.config/fish/conf.d"
    _add_abbr_if_exists fish-f "$HOME/.config/fish/functions"

    function _last_history_item --description "prints last history item"
        echo $history[1]
    end
    abbr --add "!!" --function _last_history_item

    function _last_history_item_args --description "prints last history item args"
        set prev_command (string split -m1 ' ' $history[1])
        set -e prev_command[1]
        echo $prev_command
    end
    function _last_history_item_last_arg --description "prints last history item last arg"
        set prev_command (string split -m1 -r ' ' $history[1])
        set -e prev_command[1]
        echo $prev_command
    end
    abbr --add '!' --position=anywhere --function _last_history_item_args
    abbr --add '!1' --position=anywhere --function _last_history_item_last_arg

    function _eza_or_ls --description "try replacing ls with eza if possible"
        if type eza &>/dev/null
            set -f eza_cmd eza
        else if type exa &>/dev/null
            set -f eza_cmd exa
        else
            echo -n ls
            return
        end

        echo -n "$eza_cmd --color=always --group-directories-first --icons --group"
    end

    abbr --add ls --function _eza_or_ls

    function _eza_or_ll --description "try replacing ls with eza if possible"
        _eza_or_ls
        echo -n ' -l'
    end

    function _eza_or_la --description "try replacing ls with eza if possible"
        _eza_or_ls
        echo -n ' -la'
    end

    abbr --add ll --function _eza_or_ll

    abbr --add la --function _eza_or_la
end
