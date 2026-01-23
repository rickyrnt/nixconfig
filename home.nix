{
  config,
  pkgs,
  inputs,
  lib,
  pkgs-unstable,
  ...
}:
rec {
  imports = [
    inputs.nix4nvchad.homeManagerModule
    ./home-hyprland.nix
    ./comma.nix
  ];
  
  # The home.stateVersion option does not have a default and must be set
  home.stateVersion = "25.05";
  # Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ];
  home.username = "rickyrnt";
  home.homeDirectory = "/home/rickyrnt";
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.packages = with pkgs; let 
    VPN_HOST = "vpn2.case.edu";
    VPN_PORT = "443";
    startVpn = pkgs.writeShellApplication {
      name = "startCwruVpn";

      runtimeInputs = [
        openfortivpn-webview
      ];
      
      text = ''
        openfortivpn-webview "${VPN_HOST}:${VPN_PORT}" 2>/dev/null \
          | sudo openfortivpn "${VPN_HOST}:${VPN_PORT}" --cookie-on-stdin --pppd-accept-remote
      '';
    };
    
  in [
    python3
    python311Packages.pip
    pipx
    vscode
    obsidian
    git
    texliveBasic
    libgcc
    libreoffice-qt6-fresh
    
    openfortivpn
    startVpn
    bitwarden-desktop
    
    virt-viewer

    # mtpaint
    vesktop
    steam
    steam-run
    pkgs-unstable.heroic
    vice
    prismlauncher
    bottles
    # wine
    wine64
    jack2
    wineasio
    kdePackages.kdenlive
    zoom-us
    calibre
    graphviz
    libresprite
    libinput
    libwacom
    libnotify

    cmatrix
    terminal-toys
    godot
    # jellyfin-media-player
  ] ++ [
    inputs.cider-2.packages.x86_64-linux.cider-2
  ];
  
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs; [
      obs-studio-plugins.obs-pipewire-audio-capture
    ];
  };

  xdg.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    pictures = "${config.home.homeDirectory}/Pictures";
  };

  home.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "${xdg.userDirs.pictures}/Screenshots";
  };

  xdg.configFile = {
    "vesktop/themes/theme.css".source = ./dotfiles/ClearVision_v7.theme.css;
    # "vesktop/themes/theme.css".source = ./dotfiles/discordtransparent.css;
  };
  
  xdg.portal.enable = true;
  
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
  
  programs.feh.enable = true;
  programs.feh = {
    buttons = {
      zoom_in = 5;
      zoom_out = 4;
    };
    themes = {
      feh = [
        "--image-bg" "#110011"
        "--scale-down"
      ];
    };
  };

  # Wayland, X, etc. support for session vars
  systemd.user.sessionVariables = home.sessionVariables;

  services.dunst.enable = true;
  services.dunst.settings = {
    global = {
      follow = "keyboard";
      # monitor = 1;
      frame_width = 1;
      font = "Monospace 9";
      corner_radius = 4;
      corners = "top-left, bottom-right";
      mouse_right_click = "do_action, close_current";
      mouse_middle_click = "close_all";

      background = "#20001088";
      foreground = "#FFF";
      frame_color = "#CC0099AA";
      highlight = "#A40A60";
      origin = "top-right";
      offset = "(800, 0)";
    };
    urgency_critical.frame_color = "#00AAAAAA";
    urgency_low.frame_color = "#20001088";
  };
  services.dunst.waylandDisplay = "wayland-1";

  programs.git = {
    enable = true;
    settings.user.email = "rick.yarnot.255@gmail.com";
    settings.user.name = "rickyrnt";
  };

  programs.rofi = {
    enable = true;
    location = "top";
    terminal = "${pkgs.kitty}/bin/kitty";
    theme = "purple";
  };

  programs.kitty.enable = true;
  programs.kitty.settings = {
    confirm_os_window_close = 0;
    background_opacity = 0.2;
    background_blur = 0;
    background = "#100008";
  };
  
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      nixedit = "nvim /home/rickyrnt/nixos/configuration.nix";
      nixmake = "sudo nixos-rebuild switch --flake /home/rickyrnt/nixos#M04RYS8";
      nvidiacheck = "cat /sys/class/drm/card0/device/power_state";
      vim = "nvim";
      s = "kitten ssh";
    };

    initContent = ''
              neofetch | lolcat 2> /dev/null
              eval "$(ssh-agent -s)" &> /dev/null
            '';

    history.size = 10000;

    oh-my-zsh = {
      enable = true;
      plugins = [ ];
      theme = "agnoster";
    };
  };

  programs.neovim = {
    # enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      transparent-nvim
      vimtex
      vim-numbertoggle
    ];

    extraConfig = ''
              set number
              autocmd Filetype nix setlocal ts=2 sw=2 expandtab
            '';

    extraLuaConfig = ''
              vim.opt.tabstop = 4
              vim.opt.shiftwidth = 4
            '';
  };
  programs.nvchad = {
    enable = true;
    hm-activation = true;
    
    extraPlugins = ''
      return {
        { 
          "sitiom/nvim-numbertoggle",
          lazy = false,  
        },
        { 
          "tribela/transparent.nvim",
          event = "VimEnter",
          config = true,
        },
      }
    '';
  };
}
