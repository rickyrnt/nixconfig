{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:
{
  # The home.stateVersion option does not have a default and must be set
  home.stateVersion = "26.05";
  
  home.packages = with pkgs; [
  ];
}