{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  installPhase = ''
    mkdir -p $out/
    cp -R ./* $out/
  '';
  src = pkgs.fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "5e39e0841d4942757079779b4f0087f921288af6";
    sha256 = "09vi9dr0n0bhq8cj4jq1h17jw2ssi79zi9lhn0j6kgbxrqk2g8vf";
  };
}
