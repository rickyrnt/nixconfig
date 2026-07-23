{
  config,
  pkgs,
  inputs,
  lib,
  pkgs-unstable,
  wallpaper-photo,
  hostname,
  ...
}:
rec {
  imports = [
    inputs.nix4nvchad.homeManagerModule
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ./home-hyprland.nix
    ./programs/comma.nix
  ];
  
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
    inputs.hyprgrass.packages.${pkgs.system}.default
    python3
    vscode
    obsidian
    git
    texliveBasic
    libgcc
    libreoffice-qt6-fresh
    
    openfortivpn
    startVpn
    bitwarden-desktop
    
    steam-run
    zoom-us
    calibre
    graphviz
    aseprite
    libwacom
    libnotify
    musescore
    handbrake
    audacity
    mathematica
    
    cmatrix
    terminal-toys
    godot
    (discord.override {
      withEquicord = true;
    })
    # jellyfin-media-player
    
    (callPackage ./programs/cider-2.nix {})

    pkgs-unstable.make-minimal-bootstrap-sources
  ];

  xdg.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
    pictures = "${config.home.homeDirectory}/Pictures";
  };

  home.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "${xdg.userDirs.pictures}/Screenshots";
  };

  xdg.configFile = let
    jsonFormat = pkgs.formats.json { };  
  in {
    "Equicord/themes/clearvision.css".source = pkgs.substitute {
      src = ./dotfiles/ClearVision_v7.theme.css;
      substitutions = [
        "--replace"
        "@WALLPAPER@"
        "${wallpaper-photo}"
      ];
    };
    "Equicord/settings/settings.json" = {
      force = true;
      source = jsonFormat.generate "Equicord-settings" {
        enabledThemes = [ "clearvision.css" ];
        transparent = "true";
        autoUpdate = true;
        autoUpdateNotification = true;
        plugins = {
          ChatInputButtonAPI.enabled = true;
          CommandsAPI.enabled = true;
          DynamicImageModalAPI.enabled = true;
          MemberListDecoratorsAPi.enabled = true;
          MessageAccessoriesAPI.enabled = true;
          MessageDecorationsAPI.enabled = true;
          MessageEventsAPI.enabled = true;
          MessagePopoverAPI.enabled = true;
          MessageUpdaterAPI.enabled = true;
          ServerListAPI.enabled = true;
          UserSettingsAPi.enabled = true;
          AlwaysExpandRoles.enabled = true;
          AlwaysTrust = {
            enabled = true;
            domain = true;
            file = true;
          };
          BetterFolders = {
            enabled = true;
            sidebar = true;
            showFolderIcon = 1;
            keepIcons = false;
            closeAllHomeButton = false;
            closeAllFolders = false;
            forceOpen = false;
            sidebarAnim = true;
            closeOthers = false;
          };
          BetterGifAltText.enabled = true;
          BetterGifPicker.enabled = true;
          BetterSettings = {
            enabled = true;
            disableFade = true;
            eagerLoad = true;
            organizeMenu = true;
          };
          BetterUploadButton.enabled = true;
          BiggerStreamPreview.enabled = true;
          CallTimer = {
            enabled = true;
            format = "stopwatch";
          };
          ClearURLs.enabled = true;
          CopyFileContents.enabled = true;
          CopyUserURLs.enabled = true;
          CrashHandler.enabled = true;
          CustomRPC = {
              enabled = true;
              type = 0;
              timestampMode = 2;
              appName = "with MAGIC";
              appID = "1134332107544592486";
              details = "IAMA MAGIC MAN";
              state = "HHHAHHAHAHHAAAHAHAAAHAHAA";
              imageBig = "ganglemicrowave";
              imageBigTooltip = "goodness";
              buttonOneText = "BUTTON";
              buttonOneURL = "https://en.wikipedia.org/wiki/Button";
          };
          Dearrow = {
            enabled = true;
            hideButton = false;
            replaceElements = 0;
            dearrowByDefault = true;
          };
          DontRoundMyTimestamps.enabled = true;
          Experiments = {
            enabled = true;
            toolbarDevMenu = false;
          };
          FakeNitro = {
              enabled = true;
              enableStickerBypass = true;
              enableStreamQualityBypass = true;
              enableEmojiBypass = true;
              transformEmojis = true;
              transformStickers = true;
              transformCompoundSentence = false;
              emojiSize = 48;
              hyperLinkText = "{{NAME}}";
              useHyperLinks = true;
              disableEmbedPermissionCheck = false;
          };
          FavoriteEmojiFirst.enabled = true;
          FavoriteGifSearch = {
            enabled = true;
            searchOption = "hostandpath";
          };
          FixSpotifyEmbeds.enabled = true;
          FixYoutubeEmbeds.enabled = true;
          FriendsSince.enabled = true;
          FullSearchContext.enabled = true;
          FullUserInChatbox.enabled = true;
          GameActivityToggle = {
            enabled = true;
            oldIcon = false;
            location = "PANEL";
          };
          GifPaste.enabled = true;
          GreetStickerPicker.enabled = true;
          HideMedia.enabled = true;
          ImageZoom = {
              enabled = true;
              saveZoomValues = true;
              invertScroll = true;
              nearestNeighbour = false;
              square = false;
              zoom = 1.6;
              size = 560.9025270758123;
              zoomSpeed = 0.5;
          };
          ImplicitRelationships = {
            enabled = true;
            sortByAffinity = true;
          };
          KeepCurrentChannel.enabled = true;
          MemberCount = {
            enabled = true;
            memberList = true;
            toolTip = true;
            voiceActivity = true;
          };
          MentionAvatars = {
            enabled = true;
            showAtSymbol = true;
          };
          MessageClickActions = {
            enabled = true;
            requireModifier = false;
            enableDoubleClickToEdit = true;
            enableDoubleClickToReply = true;
          };
          MessageLinkEmbeds = {
            enabled = true;
            listMode = "blacklist";
            idList = "";
            outomodEmbeds = "never";
          };
          MessageLogger = {
              enabled = true;
              deleteStyle = "text";
              logDeletes = true;
              collapseDeleted = false;
              logEdits = true;
              inlineEdits = true;
              ignoreBots = false;
              ignoreSelf = false;
              ignoreUsers = "";
              ignoreChannels = "";
              ignoreGuilds = "";
          };
          MutualGroupDMs.enabled = true;
          NoOnboardingDelay.enabled = true;
          NoTypingAnimation.enabled = true;
          NormalizeMessageLinks.enabled = true;
          OpenInApp = {
              enabled = true;
              spotify = true;
              steam = true;
              epic = true;
              tidal = true;
              itunes = true;
          };
          PauseInvitesForever.enabled = true;
          PermissionFreeWill = {
            enabled = true;
            lockout = true;
            onboarding = true;
          };
          petpet.enabled = true;
          PictureInPicture.enabled = true;
          PinDMs = {
            enabled = true;
            userBasedCategoryList = {
              "276163256949800973" = [];
            };
            pinOrder = 0;
            canCollapseDmSection = false;
          };
          PreviewMessage.enabled = true;
          ReactErrorDecoder.enabled = true;
          ReadAllNotificationsButton.enabled = true;
          RelationshipNotifier = {
              enabled = true;
              offlineRemovals = true;
              groups = true;
              servers = true;
              friends = true;
              friendRequestCancels = true;
              notices = false;
          };
          ReplyTimestamp.enabled = true;
          RevealAllSpoilers.enabled = true;
          ReverseImageSearch.enabled = true;
          SendTimestamps = {
            enabled = true;
            replaceMessageContents = true;
          };
          ServerInfo.enabled = true;
          ServerListIndicators = {
            enabled = true;
            mode = 2;
          };
          ShikiCodeblocks = {
              enabled = true;
              useDevIcon = "GREYSCALE";
              theme = "https://raw.githubusercontent.com/shikijs/textmate-grammars-themes/2d87559c7601a928b9f7e0f0dda243d2fb6d4499/packages/tm-themes/themes/dark-plus.json";
          };
          ShowHiddenThings = {
            enabled = true;
            showTimeouts = true;
            showInvitesPaused = true;
            showModView = true;
          };
          SilentMessageToggle = {
            enabled = true;
            persistState = false;
          };
          SilentTyping = {
            enabled = true;
            isEnabled = true;
            showIcon = false;
          };
          SortFriendRequests = {
            enabled = true;
            showDates = false;
          };
          SpotifyCrack = {
            enabled = true;
            noSpotifyAutoPause = true;
            keepSpotifyActivityOnIdle = false;
          };
          StartupTimings.enabled = true;
          "Translate+" = {
            enabled = true;
            target = "en";
            toki = true;
            sitelen = true;
            shavian = true;
          };
          TypingIndicator = {
            enabled = true;
            includeMutedChannels = false;
            includeCurrentChannel = true;
            indicatorMode = 3;
          };
          TypingTweaks = {
            enabled = true;
            alternativeFormatting = true;
            showRoleColors = true;
            showAvatars = true;
          };
          Unindent.enabled = true;
          UnlockedAvatarZoom.enabled = true;
          UnsuppressEmbeds.enabled = true;
          UserMessagesPronouns = {
            enabled = true;
            showSelf = true;
            pronounsFormat = "LOWERCASE";
          };
          UserVoiceShow = {
            enabled = true;
            showInUserProfileModal = true;
            showInMemberList = true;
            showInMessages = true;
          };
          ValidReply.enabled = true;
          ValidUser.enabled = true;
          VencordToolbox.enabled = true;
          ViewIcons = {
            enabled = true;
            format = "webp";
            imgSize = "1024";
          };
          ViewRaw = {
            enabled = true;
            clickMethod = "Left";
            messageContextMenu = false;
          };
          VolumeBooster = {
            enabled = true;
            multiplier = 2;
          };
          WebKeybinds.enabled = true;
          WebScreenShareFixes = {
            enabled = true;
            experimentalAV1Support = false;
          };
          WhoReacted.enabled = false;
          YoutubeAdblock.enabled = true;
          BadgeAPI.enabled = true;
          NoTrack = {
            enabled = true;
            disableAnalytics = true;
          };
          WebContextMenus = {
            enabled = true;
            addBack = true;
          };
          Settings = {
            enabled = true;
            settingsLocation = "aboveNitro";
          };
          SupportHelper.enabled = true;
          ExpressionCloner.enabled = true;
          DisableDeepLinks.enabled = true;
          CustomCommands = {
            enabled = true;
            clyde = true;
            tagList = {};
          };
        };
      };
    };
  };
  
  xdg.portal.enable = true;
  
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
    lfs.enable = true;
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
    dotDir = "${config.xdg.configHome}/zsh";

    shellAliases = {
      nixedit = "nvim /home/rickyrnt/nixos/configuration.nix";
      nixmake = "sudo nixos-rebuild switch --flake /home/rickyrnt/nixos#${hostname}";
      vim = "nvim";
      s = "kitten ssh";
    };

    initContent = ''
      fastfetch | lolcat 2> /dev/null
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

    initLua = ''
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
