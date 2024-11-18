{
  stdenv,
  lib,
  unzip,
  buildNpmPackage,
  fetchurl,
  fetchFromGitHub,
  makeBinaryWrapper,
  alsa-lib,
  electron,
  mesa,
  nss,
  nspr,
  systemd,
  makeDesktopItem,
  copyDesktopItems,
  wrapGAppsHook3,
  metaCommon,
  version,
  dpkg,
  fakeroot,
}:

let
  pname = "trilium-next-desktop";
  inherit version;

  linuxSource.url = "https://github.com/TriliumNext/Notes/releases/download/v${version}/trilium-linux-x64-${version}.tar.xz";
  linuxSource.sha256 = "034cqj0g33kkyprkh1gzk0ba4h8j8lw2l4l0jbhv4z9gr21d3va6";

  darwinSource.url = "https://github.com/TriliumNext/Notes/releases/download/v${version}/trilium-mac-x64-${version}.zip";
  darwinSource.sha256 = "1n0zjbm21ab13ij1rpi6fp854vis78cw3j8zhz39kcbidb5k429d";

  meta = metaCommon // {
    mainProgram = "trilium";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };

  linux = buildNpmPackage rec {
    inherit pname version meta;

    src = fetchFromGitHub {
      owner = "TriliumNext";
      repo = "Notes";
      rev = "refs/tags/v${version}";
      hash = "sha256-SiU0+BX/CmiiCqve12kglh6Qa2TtTYIYENGFwyGiMsU=";
    };

    postPatch = ''
      substituteInPlace package.json \
        --replace-fail "cross-env node" "node" \
        --replace-fail "npm run" "npm run --loglevel=verbose"
    '';

    npmDepsHash = "sha256-TumJ1d696FpaeOrD3aZuP1PrVExlXHY4o1z4agyDXBU=";

    nativeBuildInputs = [
      makeBinaryWrapper
      wrapGAppsHook3
      copyDesktopItems
      dpkg fakeroot
    ];

    buildInputs = [
      #alsa-lib
      #mesa
      #nss
      #nspr
      #systemd
    ];

    env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

    npmInstallFlags = [ "--loglevel=verbose" ];
    npmBuildFlags = [ "--loglevel=verbose" ];
    npmBuildScript = "make-electron";
    #npmBuildScript = "webpack";

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

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      mkdir -p $out/share/trilium
      mkdir -p $out/share/icons/hicolor/128x128/apps

      cp -r ./* $out/share/trilium
      makeWrapper ${lib.getExe electron} $out/bin/trilium \
        --add-flags $out/share/trilium/resources/app.asar

      ln -s $out/share/trilium/icon.png $out/share/icons/hicolor/128x128/apps/trilium.png
      runHook postInstall
    '';

    dontStrip = true;

    passthru.updateScript = ./update.sh;
  };

  darwin = stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchurl darwinSource;
    nativeBuildInputs = [ unzip ];

    installPhase = ''
      mkdir -p $out/Applications
      cp -r *.app $out/Applications
    '';
  };

in
if stdenv.isDarwin then darwin else linux
