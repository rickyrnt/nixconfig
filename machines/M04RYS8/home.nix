{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:
{
  # The home.stateVersion option does not have a default and must be set
  home.stateVersion = "25.05";
  
  home.packages = with pkgs; [
    virt-viewer

    pkgs-unstable.heroic
    vice
    prismlauncher
    gzdoom
    kdePackages.kdenlive

    bottles
    # wine
    wine64

    carla
    yabridge
    yabridgectl
  ];

  services.flatpak = {
    packages = [
      "io.github.Soundux"
    ];
  };
  
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs; [
      obs-studio-plugins.obs-pipewire-audio-capture
    ];
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
  
  programs.zsh = {
    shellAliases = {
      nvidiacheck = "cat /sys/class/drm/card0/device/power_state";
    };
  };
  
  wayland.windowManager.hyprland = {
    settings = with inputs.hmHyprLib.lib; {
      # Autostart
      on = autostart [
        "waybar"
        "hyprpaper"
        "systemctl --user start hyprpolkitagent"
      ];
    };
  };
}