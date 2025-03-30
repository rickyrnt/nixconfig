{ config, pkgs, ... }:
let
  wallpaper-photo = pkgs.fetchurl {
    url = "https://images.steamusercontent.com/ugc/1170321140105641126/47F1E70BD90DB25A97F3B761B07764F7F947287E/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false";
    name = "wallpaper-photo";
    hash = "sha256-i94PzTtGdLVQlujgwrTB4NuJ/Zb58SCfo0g26NQXbH0=";
  };
in
{
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  home-manager.users.rickyrnt = {
    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
    };

    services.hyprpaper.enable = true;
    services.hyprpaper.settings = {
      preload = [
	      "${wallpaper-photo}"
      ];
      wallpaper = [
	      ", ${wallpaper-photo}"
      ];
    };

    programs.hyprlock.enable = true;
    programs.hyprlock.settings = {
      background = {
	      path = "${wallpaper-photo}";
	      color = "rgba(25,20,20,1.0)";
      };
      label = {
        text = "";
        font_size = 25;
        font_family = "Noto Sans";
      };
      input-field = {
        size = "200, 50";
        outline_thickness = 3;
        dots_size = 0.2;
        dots_spacing = 0.15;
        dots_center = false;
        dots_rounding = -1;
        outer_color = "rgb(151515)";
        inner_color = "rgb(200,200,200)";
        font_color = "rgb(10,10,10)";
        fade_on_empty = true;
        fade_timeout = 2000;
        placeholder_text = "bQ^YB";
        hide_input = false;
        rounding = -1;
        check_color = "rgb(204,135,34)";
        fail_color = "rgb(204,34,34)";
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        fail_transition = 300;
        capslock_color = -1;
        numlock_color = -1;
        bothlock_color = -1;
        invert_numlock = false;
        position = "0,0";
        halign = "center";
        valign = "center";
      };
    };

    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.settings = {
      # Monitors
      monitor = [
        "eDP-1,highres@highrr,0x0,1"
        "HDMI-A-1,highres@highrr,auto-left,1"
      ];

      # Programs
      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$menu" = "wofi --show drun";
      "$supermenu" = "wofi --show run";
      "$rebar" = "killall -v .waybar-wrapped; waybar &";
      "$vencordize" = "hyprctl dispatch exec vesktop";

      # Autostart
      exec-once = [
        "waybar & hyprpaper"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;

        border_size = 2;

        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        "col.active_border" = "rgba(cc009977) rgba(ee00ee33) 45deg";
        "col.inactive_border" = "rgba(00aaaa49)";

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false;

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;

        layout = "dwindle";
      };

      decoration = {
        rounding = 3;

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
          enabled = false;
          size = 3;
          passes = 1;

          vibrancy = 0.1696;
        };
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      input = {
        follow_mouse = 2;
        touchpad.natural_scroll = true;
      };

      gestures.workspace_swipe = true;

      # Keybinds
      "$mod" = "SUPER";
      bind = [
        "ALT, f1, exec, $terminal"
        "ALT, f2, exec, $menu"
        "$mod, f2, exec, $supermenu"
        "ALT, f3, exec, firefox"
        "ALT, f4, killactive,"
        "ALT, f5, exec, $fileManager"
        "ALT, f6, exec, code"
        "ALT, f11, exec, $vencordize"

        "$mod, ESCAPE, exec, $rebar"
        "$mod, S, togglefloating,"
        "$mod, M, fullscreen, 1"
        "$mod, F, fullscreen, 0"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        "$mod, L, exec, hyprlock"

        "ALT, left, movefocus, l"
        "ALT, right, movefocus, r"
        "ALT, up, movefocus, u"
        "ALT, down, movefocus, d"
        "ALT, h, movefocus, l"
        "ALT, l, movefocus, r"
        "ALT, k, movefocus, u"
        "ALT, j, movefocus, d"

        "$mod, B, togglespecialworkspace, magic"
        "$mod SHIFT, B, movetoworkspace, special:magic"
        "$mod, D, togglespecialworkspace, discord"
        "$mod SHIFT, D, movetoworkspace, special:discord"

        "CTRL ALT, mouse_up, workspace, e+1"
        "CTRL ALT, mouse_down, workspace, e-1"
        "CTRL ALT, l, workspace, r+1"
        "CTRL ALT, h, workspace, r-1"

        ",PGUP, exec, playerctl next"
        ",HOME, exec, playerctl play-pause"
        ",PGDN, exec, playerctl previous"
      ] ++ (
        builtins.concatLists(builtins.genList(i:
          let ws = i + 1;
          in [
            "CTRL ALT, code:1${toString i}, workspace, ${toString ws}"
            "ALT SHIFT, code:1${toString i}, movetoworkspacesilent, ${toString ws}"
          ]
        )9)
      );

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"	
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"	
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      bindl = [
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPause, exec, playerctl play-pause"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioPrev, exec, playerctl previous"
      ];


      workspace = [
        "n[e:discord] w[tv1], gapsout:0, gapsin:0"
        "n[e:discord] f[1], gapsout:0, gapsin:0"
      ];

      windowrulev2 = [
        "noborder, class:vesktop, floating:0, onworkspace:w[tv1] s[true]"
        "rounding 0, class:vesktop, floating:0, onworkspace:w[tv1] s[true]"
        "noborder, class:vesktop, floating:0, onworkspace:s[true], onworkspace:f[1]"
        "rounding 0, class:vesktop, floating:0, onworkspace:s[true], onworkspace:f[1]"
        "workspace special:discord, class:vesktop"
      ];

      animations = {
        enabled = "yes, please :)";

        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };
    };
  };
}
