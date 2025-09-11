if status is-interactive
    function __prompt_right_tty
        if test $cmd_status -ne 0
            echo -n (set_color red)"x $cmd_status"
        else if test -z $cmd_status
            echo -n (set_color red)'? status'
        end
    end

    function __prompt_right_normal
        if test $cmd_status -ne 0
            echo -n (set_color red)' '(set_color black && set_color -b red)"✘ $cmd_status"(set_color normal && set_color red)' '
        else if test -z $cmd_status
            echo -n (set_color red)' '(set_color black && set_color -b red)" status"(set_color normal && set_color red)' '
        end
    end
end

