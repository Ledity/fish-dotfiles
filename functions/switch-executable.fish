function switch-executable \
    --description "Switch an executable's execution flag on and off"
    function usage
        echo -e "\
Switch an executable's execution flag on and off.

Usage: $argv[1] [-h/--help] [-n/--no-cache] COMMAND [MODE]
Where:
\t-h, --help\t-\tShow this message.
\t-n, --no-cache\t-\tDo not save or read the previous location of the executable.
\tCOMMAND\t-\tcommand to switch.
\tMODE\t-\ton, off, or toggle. Defaults to toggle
"
    end

    set -fx cache_dir "$HOME/.cache/switch-executable"

    function find-cached
        if type -fq $executable
            type -fp $executable
            return 0
        end

        if not test -d "$cache_dir"
            echo "CACHE (find-cached): $cache_dir" >&2
            mkdir "$cache_dir"
            or return 0
        end

        if not test -f "$cache_path" || not test -r "$cache_path"
            return 0
        end

        set -f kotlin_lsp (cat cache_path)
        if test -e "$kotlin_lsp"
            echo "$kotlin_lsp"
        end
    end

    function find-brute
        for p in $PATH
            set -f kotlin_lsp (find $p -name "$executable")
            if test -n "$kotlin_lsp"
                echo "$kotlin_lsp"
                return 0
            end
        end

        echo "\
$(set_color -o yellow)WARNING$(set_color normal): Could not find $executable in PATH" >&2
        return 1
    end

    function on
        set -f path "$argv[1]"

        if set -q DEBUG
            echo 'chmod +x "$path" --silent'
            return 0
        end
        chmod +x "$path" --silent
        or echo "\
$(set_color -o red)ERROR$(set_color normal): Could not set $path on" >&2
    end

    function off
        set -f path "$argv[1]"

        if set -q DEBUG
            echo 'chmod -x "$path" --silent'
            return 0
        end
        chmod -x "$path" --silent
        or echo "\
$(set_color -o red)ERROR$(set_color normal): Could not set $path off" >&2
    end

    function toggle
        set -f path "$argv[1]"
        if test -x "$path"
            off $path
        else
            on $path
        end
    end

    function do-action
        set -f subcmd $argv[1]
        set -f path $argv[2]

        if set -q DEBUG
            echo $subcmd $path
        end

        switch "$subcmd"
            case on
                on $path
                return $status
            case off
                off $path
                return $status
            case toggle
                toggle $path
                return $status

            case '*'
                usage switch-executable >&2 && return 255
        end
    end

    argparse --name=switch-executable h/help n/no-cache q/query -- $argv
    or usage switch-executable >&2 && return 255
    argparse --name=switch-executable --max-args=2 --min-args=1 -- $argv
    or usage switch-executable >&2 && return 255

    set -fx executable "$argv[1]"
    set -e argv[1]
    set -fx cache_path "$cache_dir/"

    if set -q _flag_help
        usage >&2
        return 0
    end

    if set -q _flag_query
        if type -qf $executable
            echo true
        else
            echo false
        end
    end

    if not set -q argv[1]
        set -f subcmd toggle
    else
        set -f subcmd "$argv[1]"
    end

    if not set -q _flag_n
        set -f path (find-cached)
        if test -n "$path" && test -e "$path"
            do-action $subcmd $path
            if test "$status" = 0
                return 0
            else
                rm $cache_path
            end
        end
    end

    set -f path (find-brute)
    or return 0

    if not set -q _flag_n
        if not test -e "$cache_dir"
            echo "CACHE (main): $cache_dir" >&2
            mkdir "$cache_dir"
            echo $path >$cache_path
        end
    end

    do-action $subcmd $path
    return $status
end
