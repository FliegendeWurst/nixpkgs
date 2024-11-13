{
  lib,
  stdenv,
  runCommand,
  megacmd,
  unzip,
  makeWrapper,
  steam-run,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation rec {
  pname = "legends-of-equestria";
  version = "2024.05.01";

  src =
    runCommand "mega-loe"
      {
        inherit pname version;
        nativeBuildInputs = [
          megacmd
          unzip
        ];
        url = "https://mega.nz/file/NjIwwJoK#MVi3C3FAcSQPd7FRpQc0CoStBG8jSFuPn0jD-pG3zY0";
        outputHashAlgo = "sha256";
        outputHash = "VXBtEB3G5MTrWn9OOvmCG3sDoasjbKkLJruhdQZa4SQ=";
        outputHashMode = "recursive";
      }
      ''
        export HOME=$TMPDIR
        dest="$TMPDIR/mega-loe"
        mkdir -p "$dest"
        mega-get "$url" "$dest"
        mkdir -p "$out"
        unzip -d "$out" "$dest/$(ls "$dest")"
      '';

  dontBuild = true;
  buildInputs = [ steam-run ];
  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  installPhase = ''
    mkdir -p $out/libexec
    cp -r LoE $out/libexec

    mkdir -p $out/bin
    chmod +x $out/libexec/LoE/LoE.x86_64
    makeWrapper ${lib.getExe steam-run} $out/bin/LoE \
      --add-flags "$out/libexec/LoE/LoE.x86_64"

    mkdir -p $out/share/icons/hicolor/128x128/apps
    ln -s $out/libexec/LoE/LoE_Data/Resources/UnityPlayer.png \
      $out/share/icons/hicolor/128x128/apps/legends-of-equestria.png
  '';

  passthru.updateScript = ./update.sh;

  desktopItems = [
    (makeDesktopItem {
      name = "legends-of-equestria";
      comment = meta.description;
      desktopName = "Legends of Equestria";
      genericName = "Legends of Equestria";
      exec = "LoE";
      icon = "legends-of-equestria";
      categories = [ "Game" ];
    })
  ];

  meta = {
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ ulysseszhan ];
    mainProgram = "LoE";
    homepage = "https://www.legendsofequestria.com";
    description = "Free-to-play MMORPG";
    downloadPage = "https://www.legendsofequestria.com/downloads";
  };

}
