{
  appimageTools,
  lib,
  fetchurl,
  makeWrapper,
}:

appimageTools.wrapType2 rec {
  pname = "Cider";
  version = "2.3.2";

  src = fetchurl {
    url = "file://${./Cider-${version}.AppImage}";
    hash = "sha256-buHunUtFQZ14YNHngx3Hwqm5RonwE6C/SDh2xrTWUGI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      wrapProgram $out/bin/${pname} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

      install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-warn 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${contents}/usr/share/icons $out/share
    '';

  meta = with lib; {
    description = "New look into listening and enjoying Apple Music in style and performance";
    homepage = "https://github.com/ciderapp/Cider";
    license = licenses.agpl3Only;
    mainProgram = "cider";
    maintainers = [ maintainers.cigrainger ];
    platforms = [ "x86_64-linux" ];
  };
}