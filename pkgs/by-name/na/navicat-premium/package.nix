{
  fetchurl,
  appimageTools,
  lib,
  libGL,
  glib,
  glibc,
  pango,
  harfbuzz,
  fontconfig,
  libX11,
  freetype,
  e2fsprogs,
  expat,
  p11-kit,
  libxcb,
  libgpg-error,
  stdenv,
  cjson,
  libxcrypt-legacy,
  curl,
  makeWrapper,
  autoPatchelfHook,
  libxkbcommon,
  libselinux,
}:
let
  pname = "navicat-premium";
  version = "17.1.3";
  appimageContents = appimageTools.extractType2 {
    inherit pname version;
    src = fetchurl {
      url = "https://web.archive.org/web/20241104191829if_/https://dn.navicat.com/download/navicat17-premium-en-x86_64.AppImage";
      hash = "sha256-ndMzGzHQ8MBt/bPRZWmP/aRo5ALGkZftYjcRirL26bM=";
    };
  };
in
stdenv.mkDerivation {
  inherit pname version;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    libgpg-error
    libxcb
    p11-kit
    expat
    e2fsprogs
    freetype
    libX11
    fontconfig
    harfbuzz
    pango
    glibc
    glib
    libGL
    cjson
    curl
    libxcrypt-legacy
    libxkbcommon
    libselinux
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    cp -a ${appimageContents}/usr $out/
    chmod -R u+rwX,go+rX,go-w $out
    mkdir -p $out/usr
    ln -s $out/lib $out/usr/lib

    runHook postInstall
  '';

  preFixup = ''
    wrapProgram $out/bin/navicat \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libGL
          glib
          glibc
          pango
          harfbuzz
          fontconfig
          libX11
          freetype
          e2fsprogs
          expat
          p11-kit
          libxcb
          libgpg-error
          libxkbcommon
          libselinux
        ]
      }:$out/lib" \
      --set QT_PLUGIN_PATH "$out/plugins" \
      --set QT_QPA_PLATFORM "xcb" \
      --set QT_STYLE_OVERRIDE "Fusion" \
      --chdir "$out"
  '';

  meta = {
    homepage = "https://www.navicat.com/products/navicat-premium";
    description = "Database development tool that allows you to simultaneously connect to many databases";
    mainProgram = "navicat";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ aucub ];
    platforms = [ "x86_64-linux" ];
  };
}
