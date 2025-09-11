if status is-interactive
    function __prompt_left_ssh
        echo -n (set_color brred)"$USER"(set_color white)'@'(set_color yellow)(prompt_hostname)' '(set_color blue)(prompt_pwd)(set_color green)" $_USER_PROMPT "
    end

    function __prompt_left_tty
        echo -n (set_color brred)"$USER"(set_color white)'@'(set_color yellow)(prompt_hostname)' '(set_color blue)(prompt_pwd)(set_color green)" $_USER_PROMPT "
    end

    function __prompt_left_normal
        echo -n (set_color green)' '(set_color -o black && set_color -b green)(prompt_pwd)(set_color normal && set_color green)' '

        echo -n (set_color magenta)''(set_color -o black && set_color -b magenta)"$_USER_PROMPT"(set_color normal && set_color magenta)' '
    end
end

