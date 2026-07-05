{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  services.xserver.xkb = {
    model = "chromebook";
    options = "chromebook-led:no_fkeys";
  };

  system.stateVersion = "25.11";
}