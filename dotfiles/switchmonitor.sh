#!/usr/bin/env bash

config="$HOME/.config/rofi/monitor-menu.rasi"

actions=$(echo -e "󱄄  Solo\n󰍹  Solo@60Hz\n󱒃  Mirror\n󰍺  Extend\n󰹑  Extend@1080@60Hz")

selected_option=$(echo -e "$actions" | rofi -dmenu -i -config "${config}" || pkill -x rofi)

case "$selected_option" in
*Solo\@60Hz)
    hyprctl keyword monitor "HDMI-A-1,disable"
    hyprctl keyword monitor "eDP-1,highres@60,0x0,1"
    ;;
*Solo)
    hyprctl keyword monitor "HDMI-A-1,disable"
    hyprctl keyword monitor "eDP-1,highres@highrr,0x0,1"
    ;;
*Mirror)
    hyprctl keyword monitor "HDMI-A-1,preferred,auto-left,1,mirror,eDP-1"
    ;;
*Extend\@1080\@60Hz)
    hyprctl keyword monitor "HDMI-A-1,1920x1080@60,auto-left,1"
    ;;
*Extend)
    hyprctl keyword monitor "HDMI-A-1,highres@highrr,auto-left,1"
    ;;
esac