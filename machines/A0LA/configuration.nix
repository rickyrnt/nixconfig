{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      wmctrl = prev.wmctrl.overrideAttrs (prevAttrs: finalAttrs: {
        src = final.fetchurl { 
          # NOTE: 2019-04-11: There is also a semi-official mirror: http://tripie.sweb.cz/utils/wmctrl/
          # url = "https://sites.google.com/site/tstyblo/wmctrl/wmctrl-${finalAttrs.version}.tar.gz";
          url = "https://mirrors.mit.edu/macports/distfiles/wmctrl/wmctrl-1.07.tar.gz";
          hash = "sha256-14oe/bYvGGdCmK0DnFy9se226OFJuzqOOgGkdQqjzKk=";
        };
      });
    })
  ];

  imports = [
    ./hardware-configuration.nix
  ];

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings.main = {
          back = "f1";
          forward = "f2";
          refresh = "f3";
          zoom = "f4";
          scale = "f5";
          brightnessdown = "f6";
          brightnessup = "f7";
          mute = "f10";
          volumedown = "f11";
          volumeup = "f12";
          sleep = "delete";
          rightalt = "leftmeta";
          leftmeta = "capslock";
        };
      };
    };  
  };
  
  services.libinput = {
    touchpad = {
      accelProfile = "flat";
    };
  };
  
  environment.systemPackages = with pkgs; [
    libinput-gestures
  ];
  
  programs.iio-hyprland.enable = true;

  system.stateVersion = "25.11";
}