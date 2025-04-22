{
  description = "A configuration flake for the rickyrnt personal system";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-24.11;
    home-manager.url = github:nix-community/home-manager/release-24.11;
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.M04RYS8 = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./configuration.nix ];
    };
  };
}
