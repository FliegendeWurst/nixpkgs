{
  stdenv,
  lib,
  unzip,
  fetchurl,
  fetchzip,
  makeBinaryWrapper,
  # use specific electron since it has to load a compiled module
  electron_31,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  wrapGAppsHook3,
  asar,
}:

let
  pname = "trilium-next-desktop";
  version = "0.90.8";

  linuxSource.url = "https://github.com/TriliumNext/Notes/releases/download/v${version}/TriliumNextNotes-v${version}-linux-x64.zip";
  linuxSource.sha256 = "0l9a2l79jcbr4522k03bbzli9gv96pr15cyig6fg9qpf71cjvda1";

  darwinSource.url = "https://github.com/TriliumNext/Notes/releases/download/v${version}/TriliumNextNotes-v${version}-macos-x64.zip";
  darwinSource.sha256 = "0wki6a6bpp698r51wvyl7xh8y8csj5yaihaxfplp8q33zp9nw2q8";

  meta = {
    description = "Hierarchical note taking application with focus on building large personal knowledge bases";
    homepage = "https://github.com/TriliumNext/Notes";
    license = lib.licenses.agpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      eliandoran
      fliegendewurst
    ];
    mainProgram = "trilium";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };

  linux = stdenv.mkDerivation rec {
    inherit pname version meta;

    src = fetchurl linuxSource;

    nativeBuildInputs = [
      unzip
      makeBinaryWrapper
      wrapGAppsHook3
      copyDesktopItems
      autoPatchelfHook
      asar
    ];

    buildInputs = [
      stdenv.cc.cc.lib
    ];

    desktopItems = [
      (makeDesktopItem {
        name = "Trilium";
        exec = "trilium";
        icon = "trilium";
        comment = meta.description;
        desktopName = "TriliumNext Notes";
        categories = [ "Office" ];
        startupWMClass = "trilium notes next";
      })
    ];

    # Remove trilium-portable.sh, so trilium knows it is packaged making it stop auto generating a desktop item on launch
    postPatch = ''
      rm ./trilium-portable.sh
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      mkdir -p $out/share/trilium
      mkdir -p $out/share/icons/hicolor/512x512/apps

      cp -r ./* $out/share/trilium
      rm $out/share/trilium/{*.so*,trilium,chrome_crashpad_handler,chrome-sandbox}

      # Rebuild the ASAR archive, hardcoding the resourcesPath
      tmp=$(mktemp -d)
      asar extract $out/share/trilium/resources/app.asar $tmp
      rm $out/share/trilium/resources/app.asar

      for f in "src/services/i18n.ts" "dist/src/services/i18n.js" "dist/src/build/src/services/i18n.js" "build/src/services/i18n.js"; do
        substituteInPlace $tmp/$f \
          --replace-fail "process.resourcesPath" "'$out/share/trilium/resources'"
      done
      autoPatchelf $tmp
      cp $tmp/src/public/icon.png $out/share/icons/hicolor/512x512/apps/trilium.png

      asar pack $tmp/ $out/share/trilium/resources/app.asar
      rm -rf $tmp

      makeWrapper ${lib.getExe electron_31} $out/bin/trilium \
        "''${gappsWrapperArgs[@]}" \
        --set-default ELECTRON_IS_DEV 0 \
        --add-flags $out/share/trilium/resources/app.asar

      runHook postInstall
    '';

    dontStrip = true;
    dontWrapGApps = true;

    passthru.updateScript = ./update.sh;
  };

  darwin = stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchzip darwinSource;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications
      cp -r *.app $out/Applications
      runHook postInstall
    '';
  };

in
if stdenv.hostPlatform.isDarwin then darwin else linux
