#!/usr/bin/env bash

config="$HOME/.config/rofi/monitor-menu.rasi"

actions=$(echo -e "󱄄  Solo\n󰍹  Solo@60Hz\n󱒃  Mirror\n󰍺  Extend\n󰹑  Extend@1080@60Hz")

selected_option=$(echo -e "$actions" | rofi -dmenu -i -config "${config}" || pkill -x rofi)

case "$selected_option" in
*Solo\@60Hz)
    hyprctl dispatch 'hl.monitor({ output = "monitor-name", disabled = true})'
    hyprctl dispatch 'hl.monitor({ output = "eDP-1", mode = "highres@60", position = "0x0", scale = 1 })'
    ;;
*Solo)
    hyprctl dispatch 'hl.monitor({ output = "monitor-name", disabled = true})'
    hyprctl dispatch 'hl.monitor({ output = "eDP-1", mode = "highres@highrr", position = "0x0", scale = 1 })'
    ;;
*Mirror)
    hyprctl dispatch 'hl.monitor({ output = "monitor-name", mode = "preferred", position = "auto-left", scale = 1, mirror = "eDP-1", disabled = false })'
    ;;
*Extend\@1080\@60Hz)
    hyprctl dispatch 'hl.monitor({ output = "monitor-name", mode = "1920x1080@60", position = "auto-left", scale = 1, mirror = "", disabled = false })'
    ;;
*Extend)
    hyprctl dispatch 'hl.monitor({ output = "monitor-name", mode = "highres@highrr", position = "auto-left", scale = 1, mirror = "", disabled = false })'
    ;;
esac