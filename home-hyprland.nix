{ 
  config, 
  pkgs,
  pkgs-unstable,
  inputs, 
  lib, 
  wallpaper-photo,
  ... 
}:
rec {
  imports = [
    inputs.mechabar.mechabar
    inputs.gtk-nix.homeManagerModule
  ];

  home.packages = with pkgs; [
    grimblast
    playerctl
    hyprpicker
    hyprcursor
    # hyprsysteminfo # unstable
    hyprlang
    brightnessctl
  ];
  
  gtk = {
    enable = true;
    # theme = {
      # package = pkgs.qogir-theme;
      # name = "Qogir-Dark";
    # };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
    iconTheme = {
      package = pkgs.qogir-icon-theme;
      name = "Qogir-Dark";
    };
    gtk4.theme = config.gtk.theme;
  };
  gtkNix = rec {
    enable = true;
    
    configuration = {
      disabled-opacity = 0.8;
      border-size = "1px";
    };
    
    extraColorSCSS = ''
      @define-color theme_selected_bg_color #${palette.highlight};
      @define-color theme_unfocused_selected_bg_color #${palette.highlight};
    '';
    
    palette = rec {
      scheme = "Ekor";
      author = "rickyrnt";
      base00 = "26081a";
      base01 = "2d1025";
      base02 = "3a1733";
      base03 = "632959";
      base04 = "b773b6";
      base05 = "dcc8e0";
      base06 = "f4baf5";
      base07 = "fecdff";
      base08 = "ac0552";
      base09 = "9b0334";
      base0A = "b20d6f";
      base0B = "18b59b";
      base0C = "141980";
      base0D = "0086af";
      base0E = "0a5098";
      base0F = "0c9ea5";

      # banner extensions
      highlight = "00658a";
      hialt0 = "0c9ea5";
      hialt1 = "0a5098";
      hialt2 = "0086af";
      urgent = "d1263d";
      warn = "d15426";
      confirm = "18b554";
      link = "00aaaa";

      pfg-highlight = "2c0109";
      pfg-hialt0 = "2c0109";
      pfg-hialt1 = "2c0109";
      pfg-hialt2 = "2c0109";
      pfg-urgent = "2c0109";
      pfg-warn = "2c0109";
      pfg-confirm = "2c0109";
      pfg-link = "2c0109";

      ansi00 = "2E3440";
      ansi01 = "BF616A";
      ansi02 = "A3BE8C";
      ansi03 = "EBCB8B";
      ansi04 = "5E81AC";
      ansi05 = "B48EAD";
      ansi06 = "8FBCBB";
      ansi07 = "E5E9F0";
    };
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    hyprcursor.enable = true;
    package = pkgs.qogir-icon-theme;
    name = "Qogir";
  };

  services.playerctld.enable = true;

  services.hyprpaper.enable = true;
  services.hyprpaper.settings = {
    preload = [
      "${wallpaper-photo}"
    ];
    wallpaper = [
      {
        monitor = "";
        path = "${wallpaper-photo}";
      }
    ];
    splash = false;
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

  services.hypridle.enable = true;
  services.hypridle.settings = {
    general = {
      lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock"; # avoid starting multiple hyprlock instances.
      before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
      after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
    };

    listener = [
      {
        timeout = 300; # 5min.
        on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
        on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r"; # monitor backlight restore.
      }
      {
        timeout = 360; # 6min
        on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
      }
      {
        timeout = 600; # 10min
        on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
        on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
      }
      # {
      #   timeout = 1800; # 30min
      #   on-timeout = "systemctl suspend"; # suspend pc
      # }
    ];
  };

  wayland.windowManager.hyprland = with inputs.hmHyprLib.lib; let
    lu = lib.generators.mkLuaInline;
  in {
    enable = true;
    systemd.enable = false;
    configType = "lua";
    # portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    settings = let
      # Programs
      grmblstfy = "grimblast --notify --freeze";
      terminal = "kitty";
      fileManager = "thunar";
      menu = "rofi -show drun -show-icons";
      supermenu = "rofi -show run";
      rebar = "killall -v .waybar-wrapped; waybar &";
      vencordize = "Discord";
      ciderize = "Cider";
      moonlightize = "moonlight";
      alt-fish = inputs.alt-fish.packages.x86_64-linux.women-me-fear-fish-me-want;
    in {
      # Monitors
      monitor = [
        {
          output = "eDP-1";
          mode = "highres@highrr";
          position = "0x0";
          scale = "1";
        }
        {
          output = "HDMI-A-1";
          mode = "highres@highrr";
          position = "auto-left";
          scale = "1";
        }
      ];

      # config
      config = {
        general = {
          gaps_in = 5;
          gaps_out = 10;

          border_size = 2;

          # https:#wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
          "col.active_border" = lu "{colors = {'rgba(cc009977)','rgba(ee00ee33)'}, angle = 45}";
          "col.inactive_border" = "rgba(00aaaa49)";

          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = false;

          # Please see https:#wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false;

          layout = "dwindle";
        };
        decoration = {
          rounding = 3;

          # Change transparency of focused and unfocused windows
          active_opacity = 1.0;
          inactive_opacity = 1.0;

          shadow = {
            enabled = false;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };

          # https:#wiki.hyprland.org/Configuring/Variables/#blur
          blur = {
            enabled = true;
            size = 3;
            passes = 1;

            vibrancy = 0.1696;
          };
        };
        cursor = {
          no_hardware_cursors = 0;
        };
        misc = {
          # stop the "you didn't use start-hyprland" warning until the nixfolk fix UWSM (cuz i'm too lazy to do it myself)
          disable_watchdog_warning = true;
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          enable_swallow = true;
          swallow_regex = "kitty";
        };

        input = {
          follow_mouse = 2;
          touchpad.natural_scroll = true;
          float_switch_override_focus = 0;
        };

        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };
      };

      gesture = [
        {
          fingers = 3;
          direction = "horizontal";
          action = "workspace";
        }
      ];
      
      # Keybinds
      bind = [
        (simpleBind "ALT + f1" terminal)
        (simpleBind "ALT + f2" menu)
        (simpleBind "SUPER + f2" supermenu)
        (simpleBind "ALT + f3" "firefox")
        (dspBind "ALT + f4" (window "close"))
        (dspBind "SUPER + f4" (window "close"))
        (simpleBind "ALT + f5" fileManager)
        (simpleBind "ALT + f6" "code")
        (simpleBind "ALT + f7" "obsidian")
        (simpleBind "ALT + f11" vencordize)
        (simpleBind "CTRL + SHIFT + ESCAPE" "kitty -e \"btop\"")
        (simpleBind "SUPER + ALT + F" "steam steam://rungameid/427520")
        (simpleBind "SUPER + ALT + C" "firefox --new-window https://calendar.google.com")
        (simpleBind "SUPER + ALT + G" "firefox --new-window https://online-go.com")
        (simpleBind "SUPER + ALT + O" "code ~/nixos")
        (simpleBind "SUPER + ALT + O" "firefox --new-window https://search.nixos.org/options")
        (simpleBind "Alt_L + F + I + S + H" "${alt-fish}/bin/fish.py")

        (simpleBind "SUPER + ESCAPE" rebar)
        (dspBind "SUPER + S" (windowArgs "float" "{action ='toggle'}"))
        (dspBind "SUPER + M" (windowArgs "fullscreen" "{mode='maximized', action='toggle'}"))
        (dspBind "SUPER + F" (windowArgs "fullscreen" "{mode='fullscreen', action='toggle'}"))
        (dspBind "SUPER + A" (window "toggle_swallow"))
        (simpleBind "SUPER + P" "$HOME/.config/waybar/scripts/switchmonitor.sh")
        (simpleBind "SUPER + L" "hyprlock")

        (dspBind "ALT + left" (focus "{direction='l'}"))
        (dspBind "ALT + right" (focus "{direction='r'}"))
        (dspBind "ALT + up" (focus "{direction='u'}"))
        (dspBind "ALT + down" (focus "{direction='d'}"))
        (dspBind "ALT + h" (focus "{direction='l'}"))
        (dspBind "ALT + l" (focus "{direction='r'}"))
        (dspBind "ALT + k" (focus "{direction='u'}"))
        (dspBind "ALT + j" (focus "{direction='d'}"))
        (dspBind "ALT + TAB" (window "cycle_next"))
        (dspBind "ALT + TAB" (windowArgs "fullscreen" "{mode='maximized', action='set'}"))
        (dspBind "CTRL + SUPER + ALT + 1" (workspaceArgs "move" "{monitor=0}"))
        (dspBind "CTRL + SUPER + ALT + 2" (workspaceArgs "move" "{monitor=1}"))

        (simpleBind "SUPER + f10" "${grmblstfy} copy screen")
        (simpleBind "SUPER + f11" "${grmblstfy} copy output")
        (simpleBind "SUPER + f12" "${grmblstfy} copy area")
        (simpleBind "SUPER + SHIFT + f10" "${grmblstfy} copysave screen")
        (simpleBind "SUPER + SHIFT + f11" "${grmblstfy} copysave output")
        (simpleBind "SUPER + SHIFT + f12" "${grmblstfy} copysave area")
        (simpleBind "SUPER + ALT + f10" "${grmblstfy} edit screen")
        (simpleBind "SUPER + ALT + f11" "${grmblstfy} edit output")
        (simpleBind "SUPER + ALT + f12" "${grmblstfy} edit area")

        (simpleBind "SUPER + C" "hyprpicker -a")
        (simpleBind "SUPER + V" "GTK_THEME=Adwaita-dark pavucontrol")

        (dspBind "SUPER + B" (workspaceArgs "toggle_special" "'magic'"))
        (dspBind "SUPER + SHIFT + B" (windowArgs "move" "{workspace='special:magic'}"))
        (dspBind "SUPER + D" (workspaceArgs "toggle_special" "'discord'"))
        (dspBind "SUPER + SHIFT + D" (windowArgs "move" "{workspace='special:discord'}"))
        (dspBind "SUPER + T" (workspaceArgs "toggle_special" "'tunes'"))
        (dspBind "SUPER + SHIFT + T" (windowArgs "move" "{workspace='special:tunes'}"))
        (dspBind "SUPER + N" (workspaceArgs "toggle_special" "'notes'"))
        (dspBind "SUPER + SHIFT + N" (windowArgs "move" "{workspace='special:notes'}"))

        (dspBind "CTRL + ALT + mouse_up" (focus "{workspace='e+1', on_current_monitor=true}"))
        (dspBind "CTRL + ALT + mouse_down" (focus "{workspace='e-1', on_current_monitor=true}"))
        (dspBind "CTRL + ALT + l" (focus "{workspace='r+1', on_current_monitor=true}"))
        (dspBind "CTRL + ALT + h" (focus "{workspace='r-1', on_current_monitor=true}"))
        (dspBind "CTRL + ALT + w" (lu ''function()
          hl.dispatch(hl.dsp.focus({workspace='name:moonlight'}))
          hl.dispatch(hl.dsp.submap('moonlight'))
          end''))
        (dspBind "ALT + SHIFT + w" (windowArgs "move" "{workspace='name:moonlight'}"))
        (dspBind "CTRL + ALT + G" (focus "{workspace='name:gaming'}"))
        (dspBind "ALT + SHIFT + G" (windowArgs "move" "{workspace='name:gaming'}"))
        
        (dspBind "SUPER + mouse:272" (window "drag"))
        (dspBind "SUPER + mouse:273" (window "resize"))
      ]
      ++ (builtins.concatLists (builtins.genList (
          i: let ws = i + 1; in [
            (dspBind "CTRL + ALT + code:1${toString i}" (focus "{workspace=${toString ws}}"))
            (dspBind "ALT + SHIFT + code:1${toString i}" (windowArgs "move" "{workspace=${toString ws}, follow=false}"))
          ]
        ) 10
      ))
      ++ (map (x: (addFlags x "{locked=true,repeating=true}"))[
        (simpleBind "XF86AudioRaiseVolume" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
        (simpleBind "XF86AudioLowerVolume" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
        (simpleBind "XF86AudioMute" "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
        (simpleBind "XF86AudioMicMute" "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")
        (simpleBind "XF86MonBrightnessUp" "brightnessctl s 10%+")
        (simpleBind "XF86MonBrightnessDown" "brightnessctl s 10%-")
      ])
      ++ (map (x: (addFlags x "{locked=true}"))[
        (simpleBind "XF86AudioNext" "playerctl next")
        (simpleBind "XF86AudioPause" "playerctl play-pause")
        (simpleBind "XF86AudioPlay" "playerctl play-pause")
        (simpleBind "XF86AudioPrev" "playerctl previous")
        (simpleBind "SUPER + r" "hyprctl reload")
      ]);
      
      workspace_rule = [
        {workspace="special:discord"; on_created_empty=vencordize;}
        {workspace="special:magic"; on_created_empty=terminal;}
        {workspace="special:tunes"; on_created_empty=ciderize;}
        {workspace="name:moonlight"; on_created_empty=moonlightize;}
        {workspace="n[e:discord] w[tv1]"; gaps_out=0; gaps_in=0;}
        {workspace="n[e:discord] f[1]"; gaps_out=0; gaps_in=0;}
        {workspace="name:gaming"; monitor="eDP-1";}
        {workspace="n[e:gaming] w[tv1]"; gaps_out=0; gaps_in=0;}
        {workspace="n[e:gaming] f[1]"; gaps_out=0; gaps_in=0;}
        {workspace="n[e:moonlight] w[tv1]"; gaps_out=0; gaps_in=0;}
        {workspace="n[e:moonlight] f[1]"; gaps_out=0; gaps_in=0;}
        {workspace="r[1-5]"; monitor="eDP-1";}
        {workspace="r[7-10]"; monitor="HDMI-A-1";}
        {workspace="1"; monitor="eDP-1"; default=true; persistent = true;}
        {workspace="6"; monitor="HDMI-A-1"; default=true; persistent = true;}
      ];

      window_rule = [
        {match.initial_title = ".*Discord.*"; workspace = "special:discord";}
        {match.class = "obsidian"; workspace = "special:notes";}
        {match.initial_title = ".*[Oo]bsidian.*"; workspace = "special:notes";}
        {match.class = "Cider"; workspace = "special:tunes";}
        {match.class = "libresprite"; tile = true;}
        {match.class = ".+pavucontrol"; float = true;}
        {match.class = "com.moonlight_stream.Moonlight"; workspace = "name:moonlight"; fullscreen = 1;}
        {match.class = "factorio"; workspace = "name:gaming";}
        {match.class = "Clocktower.+"; workspace = "name:gaming";}
        {match.class = "hollow_knight.x86_64"; workspace = "name:gaming";}
        {match.class = "[Mm]inecraft.+"; workspace = "name:gaming";}
        {match.initial_class = "steam_app_2075070"; workspace = "name:gaming"; float = true;}
        {match.initial_class = "steam_app.+"; workspace = "name:gaming";}
        {match.initial_class = "Slay the Spire 2"; workspace = "name:gaming";}

        {match = {initial_title=".*Discord.*";workspace="w[tv1] s[true]";float=false;}; no_blur = true; rounding = 0; border_size = 0;}
        {match = {initial_title=".*Discord.*";fullscreen=1;workspace="s[true]";}; no_blur = true; rounding = 0; border_size = 0;}

        {match = {title="Friends List";class="steam";}; float = true;}

        {match = {float=false;workspace="s[false]";}; no_blur = true;}

        {match = {workspace="n[e:gaming] w[tv1]";float=false;}; rounding = 0; border_size = 0; no_shadow = true;}
        {match = {workspace="n[e:gaming]";fullscreen=1;}; rounding = 0; border_size = 0; no_shadow = true;}
      ];
      
      # animations
      curve = [
        (mkCurve "easeOutQuint" (bezierRule [0.23 1] [0.32 1]))
        (mkCurve "easeInOutCubic" (bezierRule [0.65 0.05] [0.36 1]))
        (mkCurve "linear" (bezierRule [0 0] [1 1]))
        (mkCurve "almostLinear" (bezierRule [0.5 0.5] [0.75 1.0]))
        (mkCurve "quick" (bezierRule [0.15 0] [0.1 1]))
      ];

      animation = [
        # {leaf = "global"; enabled = true; speed = 10; bezier = "default";}
        {leaf = "border"; enabled = true; speed = 5.39; bezier = "easeOutQuint";}
        {leaf = "windows"; enabled = true; speed = 4.79; bezier = "easeOutQuint";}
        {leaf = "windowsIn"; enabled = true; speed = 4.1; bezier = "easeOutQuint"; style = "popin 87%";}
        {leaf = "windowsOut"; enabled = true; speed = 1.49; bezier = "linear"; style = "popin 87%";}
        {leaf = "fadeIn"; enabled = true; speed = 1.73; bezier = "almostLinear";}
        {leaf = "fadeOut"; enabled = true; speed = 1.46; bezier = "almostLinear";}
        {leaf = "fade"; enabled = true; speed = 3.03; bezier = "quick";}
        {leaf = "layers"; enabled = true; speed = 3.81; bezier = "easeOutQuint";}
        {leaf = "layersIn"; enabled = true; speed = 4; bezier = "easeOutQuint"; style = "fade";}
        {leaf = "layersOut"; enabled = true; speed = 1.5; bezier = "linear"; style = "fade";}
        {leaf = "fadeLayersIn"; enabled = true; speed = 1.79; bezier = "almostLinear";}
        {leaf = "fadeLayersOut"; enabled = true; speed = 1.39; bezier = "almostLinear";}
        {leaf = "workspaces"; enabled = true; speed = 1.94; bezier = "almostLinear"; style = "fade";}
        {leaf = "workspacesIn"; enabled = true; speed = 1.21; bezier = "almostLinear"; style = "fade";}
        {leaf = "workspacesOut"; enabled = true; speed = 1.94; bezier = "almostLinear"; style = "fade";}
        {leaf = "zoomFactor"; enabled = false;}
        {leaf = "monitorAdded"; enabled = false;}
      ];
    };
    submaps = {
      moonlight.settings = {
        bind = [
          (dspBind "SUPER + CTRL + ALT + e" (lu ''function()
            hl.dispatch(hl.dsp.submap('reset'))
            hl.dispatch(hl.dsp.focus({workspace='previous_per_monitor'}))
            end''))
          (dspBind "SUPER + CTRL + ALT + r" (dspCallArgs "submap" "'reset'"))
        ];
      };
    };
  };

  programs.waybar.mechabar = {
    enable = true;
    colors = {
      text = "#f4baf5";
      subtext1 = "#dcc8e0";
      subtext0 = "#c685cb";
      overlay2 = "#b773b6";
      overlay1 = "#a2609b";
      overlay0 = "#894e8d";
      surface2 = "#783b76";
      surface1 = "#642962";
      surface0 = "#4f164d";
      base = "#3a1438";
      mantle = "#300e2e";
      crust = "#260825";
    };

    themeColors = {
      active-bg = "@base";
      active-fg = "@overlay2";

      hover-bg = "@surface1";
      hover-fg = "alpha(@text, 0.75)";

      module-fg = "@text";
      white-module-fg = "@crust";
      workspaces = "@text";

      power = "@text";
    };

    modules = {
      modules-left = [
        # "custom/left5"
        "custom/distro" # distro icon
        "custom/right2"

        "custom/paddw"
        "hyprland/window" # window title
      ];

      fixed-center = true;

      modules-center = [
        # "custom/paddc"
        "custom/left2"
        "custom/cpuinfo" # temperature

        "custom/left3"
        "memory" # memory

        "custom/left4"
        "cpu" # cpu
        "custom/leftin1"

        "custom/left1"
        "ext/workspaces" # workspaces
        "custom/right1"

        "custom/rightin1"
        "idle_inhibitor" # idle inhibitor
        "clock#time" # time
        "custom/right3"

        "clock#date" # date
        "custom/right4"

        "custom/wifi" # wi-fi
        "bluetooth" # bluetooth
        # "custom/update"        # system update
        "custom/right5"
      ];

      modules-right = [
        "mpris" # media info

        "custom/funnymode"
        "custom/funnyreload"

        "custom/left6"
        "pulseaudio" # output device

        "custom/left7"
        "backlight" # brightness

        "custom/left8"
        "battery" # battery

        "custom/leftin2"
        "custom/power" # power button
      ];
    };

    extraConfig = {
      mainBar = {
        memory.tooltip = true;
        "ext/workspaces" = {
          persistent-workspaces = {
            "eDP-1" = [ 1 ];
            "HDMI-A-1" = [ 6 ];
          };
          format = "{icon}";
          format-icons = {
            "gaming" = "󰊖 ";
            "moonlight" = " ";
          };
        };
        
        "custom/funnymode" = let
          funnymodeSwitch = pkgs.writeShellScriptBin "funnymodeSwitch" ''
            status=$(systemctl --user status funnyModeTimer.timer | awk '/Active:/ {print $2}')
            case "$status" in 
              "active")
                hyprctl hyprpaper reload , ${wallpaper-photo}
                systemctl --user stop funnyModeTimer.timer ;;
              "inactive")
                systemctl --user start funnyModeTimer.timer 
                systemctl --user start funnyModeSwitch.service ;;
            esac
          '';
          checkEnabled = pkgs.writeShellScriptBin "checkFunnyEnabled" ''
            sleep 0.1
            status=$(systemctl --user status funnyModeTimer.timer | awk '/Active:/ {print $2}')
            echo "{\"alt\": \"$status\"}"
          '';
        in {
          exec = "${checkEnabled}/bin/checkFunnyEnabled";
          interval = "once";
          exec-on-event = true;
          on-click = "${funnymodeSwitch}/bin/funnymodeSwitch";
          format = "{icon}";
          return-type = "json";
          tooltip-format = "Funny mode {alt}";
          format-icons = {
            inactive = "󰨙 ";
            active = "󰔡 ";
          };
        };
        
        "custom/funnyreload" = let
          funnymodeReload = pkgs.writeShellScriptBin "funnymodeReload" ''
            status=$(systemctl --user status funnyModeTimer.timer | awk '/Active:/ {print $2}')
            case "$status" in 
              "active")
                systemctl --user start funnyModeSwitch.service ;;
              "inactive")
                hyprctl hyprpaper reload , ${wallpaper-photo} ;;
            esac
          '';
        in {
          on-click = "${funnymodeReload}/bin/funnymodeReload";
          format = " 󰑓 ";
          tooltip = false;
        };
      };
    };

    style = ./dotfiles/mechabar/style.css;
    animation = ./dotfiles/mechabar/animation.css;
  };

  xdg.configFile = {
    "rofi/monitor-menu.rasi".source = ./dotfiles/monitor-menu.rasi;
    "waybar/scripts/switchmonitor.sh" = {
      source = ./dotfiles/switchmonitor.sh;
      executable = true;
    };
  };
}
