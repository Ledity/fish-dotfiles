if status is-interactive
    set hydro_color_duration yellow
    set hydro_color_error red --bold
    set hydro_color_pwd blue
    set hydro_color_git green --bold

    set hydro_symbol_prompt "$(set_color red)❯$(set_color bryellow)❯$(set_color green)❯"
end
