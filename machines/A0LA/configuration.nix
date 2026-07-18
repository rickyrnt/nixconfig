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
    (final: prev: {
      iio-hyprland = prev.iio-hyprland.overrideAttrs (prevAttrs: finalAttrs: {
        src = final.fetchFromGitHub { 
          owner = "commonkestrel";
          repo = "iio-hyprland";
          rev = "d356f13cb89ab9b080ac4b9e5579c0c2ccf46c7c";
          hash = "sha256-K1HcwsSEHtolWltX3Qz/on31Tgi1eKjr/gRF1uu9l18=";
        };
      });
    })
    (final: prev: {
      wvkbd = prev.wvkbd.overrideAttrs (prevAttrs: finalAttrs: {
        makeFlags = [ "LAYOUT=deskintl" ];
        meta.mainProgram = "wvkbd-deskintl";
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
          rightalt = "capslock";
          # leftmeta = "capslock";
          rightcontrol = "layer(fnlock)";
        };
        settings.fnlock = {
          brightnessdown = "brigtnessdown";
          brightnessup = "brightnessup";
          mute = "mute";
          volumedown = "volumedown";
          volumeup = "volumeup";
          back = "previoussong";
          forward = "nextsong";
          refresh = "play";
          "/" = "C-/";
        };
      };
    };  
  };
  
  services.libinput = {
    touchpad = {
      accelProfile = "flat";
    };
  };
  
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt
    ];
  };
  services.xserver.videoDrivers = [ "modesetting" ];
  
  environment.systemPackages = with pkgs; [
    libinput-gestures
  ];
  
  programs.iio-hyprland.enable = true;

  system.stateVersion = "25.11";
}