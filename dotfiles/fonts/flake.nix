{
  description =
    "A flake giving access to fonts that I use, outside of nixpkgs.";
    # adapted from https://github.com/jeslie0/fonts/blob/main/flake.nix

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        defaultPackage = pkgs.symlinkJoin {
          name = "myfonts-0.1.4";
          paths = builtins.attrValues
            self.packages.${system}; # Add font derivation names here
        };

        packages.bahnschrift = pkgs.stdenvNoCC.mkDerivation {
          name = "bahnschrift-font";
          dontConfigue = true;
          src = pkgs.fetchzip {
            url = "https://www.dafontfree.io/wp-content/uploads/download-manager-files/Bahnschrift-Font-Family.zip";
            sha256 = "sha256-+kv9lzbYHPWN3nXzOAA8qrtf3O5MHOG3/N+/u5OQwlk=";
            stripRoot = false;
          };
          installPhase = ''
            mkdir -p $out/share/fonts
            cp -R $src $out/share/fonts/truetype/
          '';
          meta = { description = "The Bahnschrift Font Family derivation."; };
        };

      });
}