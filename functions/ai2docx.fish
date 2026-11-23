#!/usr/bin/env fish

function ai2docx
    if not type --query pandoc
        echo (set_color --bold)'['(set_color red)'ERROR'$(set_color --bold normal)']:'(set_color normal)' Pandoc not found' >&2
        return 1
    end

    if not test -n "$argv[1]" -a -f "$argv[1]"
        echo (set_color --bold)'['(set_color red)'ERROR'$(set_color --bold normal)']:'(set_color normal)' Too few arguments' >&2
        return 2
    end

    set -f src $argv[1]
    set -f intemediate (basename $src | string split '.' --fields 1)
    while test -e /tmp/$intemediate".md"
        set intemediate $intemediate"-"(random 1 1000)
    end
    set intemediate /tmp/$intemediate".md"
    set -f dest (basename $src | string split '.' --fields 1).docx
    sed 's/\\\(/$/g; s/\\\)/$/g; /^\*\*[0-9]\+\./a\ ' $src | awk '{ if ($0 ~ /^[абвгдеёжзийклмнопрстуфхцчшщъыьэюя]\)/) print $0 " \\\\"; else print }' >$intemediate
    echo $intemediate >&2
    echo $dest >&2
    pandoc $intemediate -o $dest
end
