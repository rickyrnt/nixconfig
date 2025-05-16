{ pkgs, lib, inputs, ... }:
{
  programs.command-not-found.enable = pkgs.lib.mkForce false;

  home-manager.users.rickyrnt = {
    home = {
      packages = with pkgs; [
          inputs.nix-index-database.packages.x86_64-linux.comma-with-db
      ];
    };
    programs = {
      nix-index = {
        enable = true;
        package = inputs.nix-index-database.packages.x86_64-linux.nix-index-with-db;
      };

      command-not-found.enable = false;
    };
  };
}