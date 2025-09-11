#!/usr/bin/fish

function y
    if ! type yazi &>/dev/null
        echo "yazi not found" &>2
        return 1
    end

    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"

    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end

    rm -f -- "$tmp"
end
