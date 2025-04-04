{ config, pkgs, lib, ... }:
  let
    mechasrc = pkgs.fetchFromGitHub {
      owner = "sejjy";
      repo = "mechabar";
      rev = "3ef006bc949e1ebd415e14c0403f7a3dff5a5c02";
      hash = "sha256-7B7OeK/WNiMZIfH6LK0Ba9nZM/xdmn4MVXpk67zbMwM=";
    };
  in
rec {
  programs.waybar.enable = true;

  home.packages = with pkgs; [
    bluetui
    bluez
    brightnessctl
    pipewire
    rofi-wayland
    nerdfonts
    wireplumber
  ];

  xdg.configFile.rofi = {
    source = "${mechasrc}/rofi";
    recursive = true;
  };
  
  # programs.waybar.style = builtins.readFile "${mechasrc}/style.css";
  programs.waybar.style = ./style.css;
  # xdg.configFile."waybar/theme.css".source = "${mechasrc}/theme.css";
  xdg.configFile."waybar/theme.css".source = ./theme.css;
  # xdg.configFile."waybar/animation.css".source = "${mechasrc}/animation.css";
  xdg.configFile."waybar/animation.css".source = ./animation.css;

  xdg.configFile."waybar/themes" = {
    source = "${mechasrc}/waybar/themes";
    recursive = true;
  };

  xdg.configFile."waybar/scripts" = {
    source = "${mechasrc}/scripts";
    recursive = true;
    executable = true;
  };
  
  xdg.configFile."waybar/config.jsonc".source = lib.mkIf (!programs.waybar?settings) "${mechasrc}/config.jsonc";
}