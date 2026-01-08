{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
rec {
  # home.nix

  # nixpkgs.overlays = [
  #   (final: prev: {
  #     wineasio = prev.wineasio.overrideAttrs {
  #       installPhase = ''
  #         runHook preInstall
  #         install -D build32/wineasio32.dll    $out/lib/wine/i386-windows/wineasio32.dll
  #         install -D build32/wineasio32.dll.so $out/lib/wine/i386-unix/wineasio32.dll.so
  #         install -D build64/wineasio64.dll    $out/lib/wine/x86_64-windows/wineasio64.dll
  #         install -D build64/wineasio64.dll.so $out/lib/wine/x86_64-unix/wineasio64.dll.so
  #         install -D $src/wineasio-register    $out/bin/wineasio-register
  #         sed -i "s/u32=(/u32=(\n\"''${out//\//\\/}\/lib\/wine\/i386-unix\/wineasio32.dll.so\"/" $out/bin/wineasio-register
  #         sed -i "s/u64=(/u64=(\n\"''${out//\//\\/}\/lib\/wine\/x86_64-unix\/wineasio64.dll.so\"/" $out/bin/wineasio-register
  #         runHook postInstall
  #       '';
  #     };
  #   })
  # ];

  hardware.opentabletdriver.enable = true;
  services.onedrive.enable = true;

  # home-hyprland.nix

  nixpkgs.overlays = [
    (final: prev: {
      qogir-icon-theme = prev.qogir-icon-theme.overrideAttrs {
        patches = [ ./dotfiles/qogir-color-change.patch ];
      };
    })
    (self: super: {
      libresprite = super.callPackage ./libresprite-1.1.nix {};
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
    withUWSM = false;
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

  # comma.nix

  programs.command-not-found.enable = pkgs.lib.mkForce false;
}