{ config, pkgs, inputs, lib, ... }:
let
  wallpaper-photo = pkgs.fetchurl {
    url = "https:#images.steamusercontent.com/ugc/1170321140105641126/47F1E70BD90DB25A97F3B761B07764F7F947287E/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false";
    name = "wallpaper-photo";
    hash = "sha256-i94PzTtGdLVQlujgwrTB4NuJ/Zb58SCfo0g26NQXbH0=";
  };
in rec
{
  
  nixpkgs.overlays = [
    (final: prev: {
      qogir-icon-theme = prev.qogir-icon-theme.overrideAttrs {
        patches = [./dotfiles/qogir-color-change.patch ];
      };
    })
  ];
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  environment.systemPackages = with pkgs.libsForQt5.qt5; [
    qtquickcontrols2
    qtgraphicaleffects
  ];
  services.displayManager.sddm =
    let
      my-astronaut-theme = pkgs.sddm-astronaut.override {
        themeConfig = {
          Background = "\"${inputs.wallpaper-photo}\"";
          DimBackgroundImage = "\"0.0\"";
          ScaleImageCropped = "\"true\"";
          ScreenWidth = "\"1920\"";
          ScreenHeight = "\"1080\"";

          ## [Blur Settings]
          FullBlur = "\"false\"";
          PartialBlur = "\"false\"";
          BlurRadius = "\"0\"";

          ## [Design Customizations]
          HaveFormBackground = "\"false\"";
          FormPosition = "\"center\"";
          BackgroundImageHAlignment = "\"center\"";
          BackgroundImageVAlignment = "\"center\"";
          MainColor = "\"#F8F8F8\"";
          AccentColor = "\"#9686aa\"";
          OverrideTextFieldColor = "\"\"";
          BackgroundColor = "\"#21222C\"";
          placeholderColor = "\"#bbbbbb\"";
          IconColor = "\"#ffffff\"";
          OverrideLoginButtonTextColor = "\"\"";
          InterfaceShadowSize = "\"6\"";
          InterfaceShadowOpacity = "\"0.6\"";
          RoundCorners = "\"4\"";
          ScreenPadding = "\"0\"";
          Font = "\"Open Sans\"";
          FontSize = "\"\"";
          HideLoginButton = "\"true\"";

          ## [Interface Behavior]
          ForceRightToLeft = "\"false\"";
          ForceLastUser = "\"true\"";
          ForcePasswordFocus = "\"true\"";
          ForceHideCompletePassword = "\"true\"";
          ForceHideVirtualKeyboardButton = "\"false\"";
          ForceHideSystemButtons = "\"false\"";
          AllowEmptyPassword = "\"false\"";
          AllowBadUsernames = "\"false\"";

          ## [Locale Settings]
          Locale = "\"\"";
          HourFormat = "\"HH:mm\"";
          DateFormat = "\"dddd d MMMM\"";

          ## [Translations]
          HeaderText = "\"\"";
          TranslatePlaceholderUsername = "\"\"";
          TranslatePlaceholderPassword = "\"\"";
          TranslateLogin = "\"\"";
          TranslateLoginFailedWarning = "\"\"";
          TranslateCapslockWarning = "\"\"";
          TranslateSuspend = "\"\"";
          TranslateHibernate = "\"\"";
          TranslateReboot = "\"\"";
          TranslateShutdown = "\"\"";
          TranslateVirtualKeyboardButton = "\"\"";
        };
      };
    in
    {
      package = pkgs.kdePackages.sddm;
      enable = true;
      wayland.enable = true;
      theme = "${my-astronaut-theme}/share/sddm/themes/sddm-astronaut-theme";
      # theme = "sddm-astronaut-theme";
      extraPackages = with pkgs; [ my-astronaut-theme ];
    };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    withUWSM = true;
  };
  
  systemd.user.timers."funnyModeTimer" = {
    wantedBy = lib.mkForce []; #[ "timers.target" ];
    timerConfig = {
      OnBootSec = "0s";
      OnUnitActiveSec = "10m";
      Unit = "funnyModeSwitch.service";
    };
  };
  
  systemd.user.services."funnyModeSwitch" = {
    script = ''
      WALLPAPER_DIR="$HOME/OneDrive/Pictures/Backgroun"
      CURRENT_WALL=$(hyprctl hyprpaper listloaded)

      # Get a random wallpaper that is not the current one
      WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

      # Apply the selected wallpaper
      hyprctl hyprpaper reload ,"contain:$WALLPAPER"
    '';
    path = [programs.hyprland.package];
    serviceConfig = {
      Type = "oneshot";
    };
  };

  home-manager.users.rickyrnt = rec {
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
      "$menu" = "rofi -show drun -show-icons";
      "$supermenu" = "rofi -show run";
      "$rebar" = "killall -v .waybar-wrapped; waybar &";
      "$vencordize" = "hyprctl dispatch exec vesktop";

      # Autostart
      exec-once = [
        "waybar & hyprpaper"
        "systemctl --user start hyprpolkitagent"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;

        border_size = 2;

        # https:#wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        "col.active_border" = "rgba(cc009977) rgba(ee00ee33) 45deg";
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

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      input = {
        follow_mouse = 2;
        touchpad.natural_scroll = true;
        float_switch_override_focus = 0;
      };

      gestures.workspace_swipe = true;

      # Keybinds
      "$mod" = "SUPER";
      bind =
        let
          grmblstfy = "grimblast --notify --freeze";
        in
        [
          "ALT, f1, exec, $terminal"
          "ALT, f2, exec, $menu"
          "$mod, f2, exec, $supermenu"
          "ALT, f3, exec, firefox"
          "ALT, f4, killactive,"
          # "$mod, f4, forcekillactive"
          "ALT, f5, exec, $fileManager"
          "ALT, f6, exec, code"
          "ALT, f7, exec, obsidian"
          "ALT, f11, exec, $vencordize"
          "CTRL SHIFT, ESCAPE, exec, kitty -e 'btop'"
          "$mod ALT, F, exec, steam steam://rungameid/427520"

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
          "ALT, TAB, cyclenext"

          "$mod, f10, exec, ${grmblstfy} copy screen"
          "$mod, f11, exec, ${grmblstfy} copy output"
          "$mod, f12, exec, ${grmblstfy} copy area"
          "$mod SHIFT, f10, exec, ${grmblstfy} copysave screen"
          "$mod SHIFT, f11, exec, ${grmblstfy} copysave output"
          "$mod SHIFT, f12, exec, ${grmblstfy} copysave area"
          "$mod ALT, f10, exec, ${grmblstfy} edit screen"
          "$mod ALT, f11, exec, ${grmblstfy} edit output"
          "$mod ALT, f12, exec, ${grmblstfy} edit area"
          
          "$mod, C, exec, hyprpicker -a"
          "$mod, V, exec, GTK_THEME=Adwaita-dark pwvucontrol"

          "$mod, B, togglespecialworkspace, magic"
          "$mod SHIFT, B, movetoworkspace, special:magic"
          "$mod, D, togglespecialworkspace, discord"
          "$mod SHIFT, D, movetoworkspace, special:discord"
          "$mod, T, togglespecialworkspace, tunes"
          "$mod SHIFT, T, movetoworkspace, special:tunes"
          "$mod, N, togglespecialworkspace, notes"
          "$mod SHIFT, N, movetoworkspace, special:notes"

          "CTRL ALT, mouse_up, workspace, e+1"
          "CTRL ALT, mouse_down, workspace, e-1"
          "CTRL ALT, l, workspace, r+1"
          "CTRL ALT, h, workspace, r-1"
          "CTRL ALT, G, workspace, 101"
          "ALT SHIFT, G, movetoworkspace, 101"
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "CTRL ALT, code:1${toString i}, workspace, ${toString ws}"
              "ALT SHIFT, code:1${toString i}, movetoworkspacesilent, ${toString ws}"
            ]
          ) 10
        ));

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
        ",code:112, exec, playerctl next"
        ",HOME, exec, playerctl play-pause"
        ",code:117, exec, playerctl previous"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPause, exec, playerctl play-pause"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioPrev, exec, playerctl previous"
        "$mod, r, exec, hyprctl reload"
      ];

      binds = let
        alt-fish = inputs.alt-fish.packages.x86_64-linux.women-me-fear-fish-me-want;
      in [
        "Alt_L, F&I&S&H, exec, ${alt-fish}/bin/fish.py"
      ];

      workspace = [
        "n[e:discord] w[tv1], gapsout:0, gapsin:0"
        "n[e:discord] f[1], gapsout:0, gapsin:0"
        "r[101-105] w[tv1], gapsout:0, gapsin:0"
        "r[101-105] f[1], gapsout:0, gapsin:0"
        "r[1-5], monitor:eDP-1"
        "r[7-10], monitor:HDMI-A-1"
        "6, monitor:HDMI-A-1, default:true"
      ];

      windowrulev2 = [
        "noborder, class:vesktop, floating:0, onworkspace:w[tv1] s[true]"
        "noborder, class:vesktop, fullscreen:1, onworkspace:s[true]"
        "noblur, class:vesktop, floating:0, onworkspace:s[true]"
        "rounding 0, class:vesktop, floating:0, onworkspace:w[tv1] s[true]"
        "noborder, class:vesktop, floating:0, onworkspace:s[true], onworkspace:f[1]"
        "rounding 0, class:vesktop, floating:0, onworkspace:s[true], onworkspace:f[1]"
        "workspace special:discord, class:vesktop"
        "workspace special:notes, class:obsidian"
        
        "maximize, class:.*qemu.*"

        "noblur, floating:0, onworkspace:s[false]"

        "rounding 0, floating:0, onworkspace:r[101-105] w[tv1]"
        "rounding 0, fullscreen:1, onworkspace:r[101-105]"
        "noborder, floating:0, onworkspace:r[101-105] w[tv1]"
        "noborder, fullscreen:1, onworkspace:r[101-105]"
        "noshadow, floating:0, onworkspace:r[101-105] w[tv1]"
        "noshadow, fullscreen:1, onworkspace:r[101-105]"
        "tile, class:libresprite"
        "tile, title:FL Studio \\d+"
        
        "float, class:.+pwvucontrol"

        "workspace 101, class:factorio"
        "workspace 101, class:hollow_knight.x86_64"
        "workspace 101, class:[Mm]inecraft.+"
        "workspace 101, initialClass:steam_app.+"
        "workspace special:tunes, class:Cider"
      ];

      animations = {
        enabled = "yes, please :)";
        first_launch_animation = false;

        # Default animations, see https:#wiki.hyprland.org/Configuring/Animations/ for more

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
          "hyprland/workspaces" # workspaces
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
          "hyprland/workspaces" = {
            persistent-workspaces = {
              "eDP-1" = [ 1 ];
              "HDMI-A-1" = [ 6 ];
            };
            format = "{icon}";
            format-icons = {
              "101" = "󰊖 ";
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

  };
}
