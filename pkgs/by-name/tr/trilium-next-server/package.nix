{
  stdenv,
  lib,
  autoPatchelfHook,
  fetchurl,
  nixosTests,
  makeBinaryWrapper,
}:

let
  version = "0.90.8";

  serverSource.url = "https://github.com/TriliumNext/Notes/releases/download/v${version}/TriliumNextNotes-v${version}-server-linux-x64.tar.xz";
  serverSource.sha256 = "0ax2z3siaxvmdiasn3ddll0yvllkyi3g2xbks5h6vmgh59ivjh2x";
in
stdenv.mkDerivation {
  pname = "trilium-next-server";
  inherit version;

  src = fetchurl serverSource;

  nativeBuildInputs = [
    autoPatchelfHook
    makeBinaryWrapper
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  patches = [
    # patch logger to use console instead of rolling files
    ./0001-Use-console-logger-instead-of-rolling-files.patch
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/share/trilium-server

    cp -r ./* $out/share/trilium-server

    makeWrapper $out/share/trilium-server/node/bin/node $out/bin/trilium-server \
      --chdir "$out/share/trilium-server" \
      --add-flags "src/main"

    runHook postInstall
  '';

  meta = {
    description = "Hierarchical note taking application with focus on building large personal knowledge bases";
    homepage = "https://github.com/TriliumNext/Notes";
    license = lib.licenses.agpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      eliandoran
      fliegendewurst
    ];
    mainProgram = "trilium-server";
  };
}
