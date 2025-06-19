{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.default
    ./home-hyprland.nix
    ./comma.nix
  ];
  
  nixpkgs.overlays = [
    (final: prev: {
      wineasio = prev.wineasio.overrideAttrs {
        installPhase = ''
          runHook preInstall
          install -D build32/wineasio32.dll    $out/lib/wine/i386-windows/wineasio32.dll
          install -D build32/wineasio32.dll.so $out/lib/wine/i386-unix/wineasio32.dll.so
          install -D build64/wineasio64.dll    $out/lib/wine/x86_64-windows/wineasio64.dll
          install -D build64/wineasio64.dll.so $out/lib/wine/x86_64-unix/wineasio64.dll.so
          install -D $src/wineasio-register    $out/bin/wineasio-register
          sed -i "s/u32=(/u32=(\n\"''${out//\//\\/}\/lib\/wine\/i386-unix\/wineasio32.dll.so\"/" $out/bin/wineasio-register
          sed -i "s/u64=(/u64=(\n\"''${out//\//\\/}\/lib\/wine\/x86_64-unix\/wineasio64.dll.so\"/" $out/bin/wineasio-register
          runHook postInstall
        '';
      };
    })
  ];
  
  home-manager.backupFileExtension = "backup";
  
  hardware.opentabletdriver.enable = true;
  services.onedrive.enable = true;

  home-manager.users.rickyrnt = rec {
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

    home.packages = with pkgs; [
      python3
      python311Packages.pip
      pipx
      vscode
      obsidian
      git
      texliveBasic
      libgcc
      libreoffice-qt6-fresh

      # mtpaint
      vesktop
      steam
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

      cmatrix
      godot
    ] ++ [
      inputs.cider-2.packages.x86_64-linux.cider-2
    ];

    xdg.enable = true;

    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      pictures = "${config.users.users.rickyrnt.home}/Pictures";
    };

    home.sessionVariables = {
      XDG_SCREENSHOTS_DIR = "${xdg.userDirs.pictures}/Screenshots";
    };

    xdg.configFile = {
      "vesktop/themes/theme.css".source = ./dotfiles/discordtransparent.css;
    };
    
    programs.feh.enable = true;

    # Wayland, X, etc. support for session vars
    systemd.user.sessionVariables = config.home-manager.users.rickyrnt.home.sessionVariables;

    services.dunst.enable = true;
    services.dunst.settings = {
      global = {
        follow = "keyboard";
        frame_width = 1;
        font = "Monospace 9";
        corner_radius = 4;
        corners = "top_left, bottom_right";
        mouse_right_click = "do_action, close_current";
        mouse_middle_click = "close_all";

        background = "#20001088";
        foreground = "#FFF";
        frame_color = "#CC0099AA";
        highlight = "#A40A60";
      };
      urgency_critical.frame_color = "#00AAAAAA";
      urgency_low.frame_color = "#20001088";
    };

    programs.git = {
      enable = true;
      userEmail = "rick.yarnot.255@gmail.com";
      userName = "rickyrnt";
    };

    programs.rofi = {
      enable = true;
      location = "top";
      package = pkgs.rofi-wayland;
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
        nvidiacheck = "cat /sys/class/drm/card2/device/power_state";
      };

      initExtra = ''
        				neofetch | lolcat 2> /dev/null
        				eval "$(thefuck --alias)"
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
      enable = true;
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
  };
}
