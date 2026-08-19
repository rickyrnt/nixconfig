{
  description = "The rickyrnt personal system";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-26.05;
    
    nixpkgs-unstable.url = github:nixos/nixpkgs/nixos-unstable;

    home-manager = {
      url = github:nix-community/home-manager/release-26.05;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = github:hyprwm/hyprland/v0.56.1;
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprgrass = {
     url = "github:horriblename/hyprgrass/230495900cef1a5681bf8f8abf797939d1d64c1b";
     inputs.hyprland.follows = "hyprland"; # IMPORTANT
    };
    
    hmHyprLib = {
      url = "github:andiurne/hmHyprLib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = github:cachix/git-hooks.nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    alt-fish = {
      url = github:rickyrnt/women-me-fear-fish-me-want;
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
    
    wallpaper-photo-morris = {
      url = https://images.steamusercontent.com/ugc/1170321140105641126/47F1E70BD90DB25A97F3B761B07764F7F947287E/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false;
      flake = false;
    };
    
    wallpaper-photo-aola = {
      url = https://cdn.mos.cms.futurecdn.net/LCFTiCY5Jt7eA5hHF6zg7Y-1200-80.jpg;
      flake = false;
    };
    
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/v0.7.0";
    };
    
    fonts = {
      url = path:./dotfiles/fonts;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  nixConfig = {
    substituters = [
      "https://hyprland.cachix.org"
      "https://ford.zubron-tetra.ts.net/nix-store/?trusted=1"
    ];
    narinfo-cache-negative-ttl = 0;
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "ford.zubron-tetra.ts.net:C22wBOL1baaXKU0r50WJjhtsRIVVaIOY6LaakPUFSXE="
    ];
    trusted-substituters = [
      "https://ford.zubron-tetra.ts.net/nix-store/"
    ];
  };

  outputs =
    { 
      self, 
      nixpkgs, 
      nixpkgs-unstable, 
      home-manager, 
      nix-flatpak,
      ...
    }@inputs:
    {
      checks.x86_64-linux.pre-commit-check = inputs.pre-commit-hooks.lib.x86_64-linux.run {
        src = ./.;
        hooks = {
          nixfmt-rfc-style.enable = true;
        };
      };

      nixosConfigurations = {
        M04RYS8 = let
          system = "x86_64-linux";
          pkgs-unstable = import nixpkgs-unstable { inherit system; };
          hostname = "M04RYS8";
          wallpaper-photo = inputs.wallpaper-photo-morris;
        in nixpkgs.lib.nixosSystem {
          specialArgs = { 
            inherit inputs pkgs-unstable hostname wallpaper-photo; 
          };
          modules = [ 
            ./configuration.nix 
            ./machines/M04RYS8/configuration.nix
            ./nvidia.nix
            ./laptop.nix
            home-manager.nixosModules.home-manager { 
              home-manager = {
                extraSpecialArgs = { inherit system inputs pkgs-unstable hostname wallpaper-photo; };
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "hm-backup";
                users.rickyrnt.imports = [
                  ./home.nix
                  ./machines/M04RYS8/home.nix
                ];
              };
            }
          ];
        };
        A0LA = let
          system = "x86_64-linux";
          pkgs-unstable = import nixpkgs-unstable { inherit system; };
          hostname = "A0LA";
          wallpaper-photo = inputs.wallpaper-photo-aola;
        in nixpkgs.lib.nixosSystem {
          specialArgs = { 
            inherit inputs pkgs-unstable hostname wallpaper-photo; 
          };
          modules = [ 
            ./configuration.nix 
            ./machines/A0LA/configuration.nix
            ./laptop.nix
            home-manager.nixosModules.home-manager { 
              home-manager = {
                extraSpecialArgs = { inherit system inputs pkgs-unstable hostname wallpaper-photo; };
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "hm-backup";
                users.rickyrnt.imports = [
                  ./home.nix
                  ./machines/A0LA/home.nix
                ];
              };
            }
          ];
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
