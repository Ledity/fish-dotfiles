if status is-interactive
    set -x ERROR_MSG $(set_color -o)'['$(set_color red)'ERROR'$(set_color normal; set_color -o)']'$(set_color normal)

    set -x WARNING_MSG $(set_color -o)'['$(set_color YELLOW)'WARNING'$(set_color normal; set_color -o)']'$(set_color normal)
end
