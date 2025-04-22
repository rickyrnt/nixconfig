{
  description = "The rickyrnt personal system";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-24.11;

    home-manager = {
      url = github:nix-community/home-manager/0b491b460f52e87e23eb17bbf59c6ae64b7664c1;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = github:hyprwm/hyprland;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    rose-pine-hyprcursor = {
      url = github:ndom91/rose-pine-hyprcursor;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.M04RYS8 = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./configuration.nix ];
    };
  };
}
