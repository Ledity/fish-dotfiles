function fish_right_prompt
    set -f clock "󱐿 " "󱑀 " "󱑁 " "󱑂 " "󱑃 " "󱑄 " "󱑅 " "󱑆 " "󱑇 " "󱑈 " "󱑉 " "󱑉 "
    set -f hours_now (math (date +%I))
    set -f clockline "$(set_color yellow --bold)$clock[$hours_now]$(date +%H:%M)$(set_color normal)"

    echo -n $clockline
end
