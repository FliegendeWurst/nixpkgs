{ appimageTools, fetchurl, system, lib }:
let
  pname = "edex-ui";
  name =  "eDEX-UI";
  version = "2.2.8";
  platform = "Linux-x86_64";
  src = fetchurl {
    url = "https://github.com/GitSquared/edex-ui/releases/download/v${version}/${name}-${platform}.AppImage";
    hash = "sha256-yPKM1yHKAyygwZYLdWyj5k3EQaZDwy6vu3nGc7QC1oE=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/${pname}.png \
      $out/share/icons/hicolor/512x512/apps/${pname}.png
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname} %U'
  '';

  meta = with lib; {
    description = "A cross-platform, customizable science fiction terminal emulator with advanced monitoring & touchscreen support.";
    mainProgram = "edex-ui";
    homepage = "https://github.com/GitSquared/edex-ui";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ yassinebenarbia ];
  };
}
