function switch-executable \
    --description "Switch an executable's execution flag on and off"
    function usage
        if set -q DEBUG
            echo usage "'$argv'" >&2
        end
        echo -e "\
Switch an executable's execution flag on and off.
Usage:
  $argv[1] [-h/--help] [-n/--no-cache] COMMAND [MODE]
" \t >&2

        echo -e "\
Where:
  -h, --help\t-\tShow this message.
  -n, --no-cache\t-\tDo not save or read the previous location of the executable.
  COMMAND\t-\tCommand to switch.
  MODE\t-\ton, off, or toggle. Defaults to toggle.
" | column --table --separator \t >&2
    end

    function cache-path
        if set -q DEBUG
            echo cache-path "'$argv'" >&2
        end
        argparse --name cache-path --min-args 1 --max-args 1 -- $argv
        or return 255
        set -f executable $argv[1]

        set -f cache_dir "$HOME/.cache/switch-executable"

        if not test -d "$cache_dir"
            mkdir "$cache_dir"
            or return 0
        end

        set -f cache_path "$cache_dir/$executable"
        echo $cache_path
    end

    function find-cached
        if set -q DEBUG
            echo find-cached "'$argv'" >&2
        end
        argparse --name find-cached --min-args 1 --max-args 1 -- $argv
        or return 255
        set -f executable $argv[1]

        if type --query --no-functions $executable && test "$(type --type $executable)" = file
            type --path $executable
            return 0
        end

        set -f cache_path (cache-path $executable)
        if not test -e "$cache_path"
            return 0
        end

        set -f executable_path (cat $cache_path)
        if test -e "$executable_path"
            echo "$executable_path"
        end
    end

    function find-brute
        if set -q DEBUG
            echo find-brute "'$argv'" >&2
        end
        argparse --name find-brute no-cache -- $argv
        or return 255
        argparse --name find-brute --min-args 1 --max-args 1 -- $argv
        or return 255
        set -f executable $argv[1]

        set -f cache_path (cache-path "$executable")

        for p in $PATH
            set -f executable_path (find $p -name "$executable")

            if test -n "$executable_path"
                if not set -q _flag_no_cache # && test -n "$cache_path"
                    echo $executable_path >"$cache_path"
                end
                echo "$executable_path"
                return 0
            end
        end
        return 1
    end

    function find-executable
        if set -q DEBUG
            echo find-executable "'$argv'" >&2
        end
        argparse --name find-executable --exclusive='cache,brute' cache brute no-cache -- $argv
        or return 255
        argparse --min-args 1 --max-args 1 -- $argv
        or return 255
        set -f executable $argv[1]

        if set -q _flag_cache
            find-cached $executable
            return 0
        end
        if set -q _flag_brute
            if set -q _flag_no_cache
                find-brute --no-cache $executable
            else
                find-brute $executable
            end
            return 0
        end

        return 1
    end

    function on
        if set -q DEBUG
            echo on "'$argv'" >&2
        end
        argparse --name on --min-args 1 --max-args 1 -- $argv
        set -f path "$argv[1]"

        chmod +x "$path" --silent
        or echo "\
$(set_color -o red)ERROR$(set_color normal): Could not set $path on" >&2 && return 1
    end

    function off
        if set -q DEBUG
            echo off "'$argv'" >&2
        end
        argparse --name off --min-args 1 --max-args 1 -- $argv
        set -f path "$argv[1]"

        chmod -x "$path" --silent
        or echo "\
$(set_color -o red)ERROR$(set_color normal): Could not set $path off" >&2 && return 1
    end

    function toggle
        if set -q DEBUG
            echo toggle "'$argv'" >&2
        end
        argparse --name toggle --min-args 1 --max-args 1 -- $argv
        set -f path "$argv[1]"
        if test -x "$path"
            off $path
            or return 1
        else
            on $path
            or return 1
        end
    end

    function do-action
        if set -q DEBUG
            echo do-action "'$argv'" >&2
        end
        argparse --name do-action --min-args 2 --max-args 2 -- $argv
        or return 255
        set -f subcmd $argv[1]
        set -f path $argv[2]

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
                usage switch-executable >&2 && return 1
        end
    end

    argparse --name=switch-executable h/help n/no-cache -- $argv
    or usage switch-executable >&2 && return 1
    argparse --name=switch-executable --max-args 2 --min-args 1 -- $argv
    or usage switch-executable >&2 && return 1

    set -f executable "$argv[1]"
    set -e argv[1]

    if set -q _flag_help
        usage >&2
        return 0
    end

    if not set -q argv[1]
        set -f subcmd toggle
    else
        set -f subcmd "$argv[1]"
    end

    if not set -q _flag_no_cache
        set -f path (find-executable --cache $executable)
        if test -n "$path" && test -e "$path"
            do-action $subcmd $path
            if test "$status" = 0
                return 0
            end
        end
    end

    if set -q _flag_no_cache
        set -f path (find-executable --no-cache --brute $executable)
    else
        set -f path (find-executable --brute $executable)
    end

    if not test -n "$path"
        echo "\
$(set_color -o yellow)WARNING$(set_color normal): Could not find $executable in PATH" >&2
        return 0
    end

    do-action $subcmd $path
    return $status
end

complete \
    --command switch-executable \
    --short-option h \
    --long-option help \
    --no-files \
    --description "Show help"
complete \
    --command switch-executable \
    --short-option n \
    --long-option no-cache \
    --no-files \
    --description "Do not save or read the previous location of the executable."
complete \
    --command switch-executable \
    --condition "__fish_is_nth_token 1" \
    --no-files \
    --arguments "(__fish_complete_command | awk '\$2 == \"command\" {print \$1}')" \
    --description Command
complete \
    --command switch-executable \
    --condition "__fish_is_nth_token 2" \
    --no-files \
    --keep \
    --arguments "on off toggle" \
    --description "Action to perform on the command"
