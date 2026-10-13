if status is-interactive # Commands to run in interactive sessions can go here
    function _history_items
        set -f last_history_item $history[1]
        set -f abbr $argv[1]

        if test "$abbr" = '!!'
            echo $last_history_item
        else if test "$abbr" = '!*'
            string split -f2 -m1 ' ' $last_history_item
        else if test "$abbr" = '!^'
            string split -f2 -m2 ' ' $last_history_item
        else if test "$abbr" = '!$'
            string split -r -f2 -m1 ' ' $last_history_item
        else if string match -q -r '![0-9]+' "$abbr"
            set -l n -(string match -r '[0-9]+' $abbr)
            echo $history[$n]
        else if string match -q -r '!-[0-9]+' "$abbr"
            set -l n (string match -r '[0-9]+' $abbr)
            echo $history[$n]
        else if string match -q -r '!\?[^\?]+\?' "$abbr"
            set -l abbr (string sub -s 3 -e -1 $abbr)
            string match -e -m1 -r "$abbr" $history
        else
            set -l abbr (string sub -s 2 $abbr)
            string match -e -m1 -r "$abbr.*" $history
        end
    end
    abbr --add "!!" --position=anywhere --regex='!([^\s]+)' --function=_history_items

end
