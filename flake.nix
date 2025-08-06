{
  description = "The rickyrnt personal system";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-25.05;

    home-manager = {
      url = github:nix-community/home-manager/0b491b460f52e87e23eb17bbf59c6ae64b7664c1;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = github:hyprwm/hyprland/v0.48.1;
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = github:cachix/git-hooks.nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    alt-fish = {
      url = github:rickyrnt/women-me-fear-fish-me-want;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    cider-2 = {
      url = "/home/rickyrnt/repos/cider-2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    mechabar = {
      url = github:rickyrnt/mechabar-nix/animated;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    gtk-nix = {
      url = github:the-argus/gtk-nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    wallpaper-photo = {
      url = https://images.steamusercontent.com/ugc/1170321140105641126/47F1E70BD90DB25A97F3B761B07764F7F947287E/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false;
      flake = false;
    };
    
    fonts = {
      url = path:/home/rickyrnt/nixos/dotfiles/fonts;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      checks.x86_64-linux.pre-commit-check = inputs.pre-commit-hooks.lib.x86_64-linux.run {
        src = ./.;
        hooks = {
          nixfmt-rfc-style.enable = true;
        };
      };

      nixosConfigurations.M04RYS8 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ 
          ./configuration.nix 
          ./nvidia.nix
          ./laptop.nix
        ];
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
