{
  lib,
  stdenv,
  coreutils,
  fetchFromGitHub,
  java,
  cctools,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "prism-model-checker-unwrapped";
  version = "4.8.1";

  src = fetchFromGitHub {
    owner = "prismmodelchecker";
    repo = "prism";
    rev = "v${finalAttrs.version}";
    hash = "sha256-igFRIjPfx0BFpQjaW/vgMEnH2HLC06aL3IMHh+ELB6U=";
  };

  nativeBuildInputs = [ java ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ cctools ];

  postPatch = ''
    substituteInPlace prism/install.sh --replace-fail "/bin/mv" "mv"
  '';

  makeFlags = [ "JAVA_DIR=${java}" ];
  preBuild = ''
    cd prism
  '';

  buildPhase = ''
    runHook preBuild
    make $makeFlags release_config clean_all all binary
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir --parents $out/share/
    cp -r bin/ $out/
    cp -r lib/ $out/
    cp -r etc/scripts $out/share/
    cp -r etc/syntax-highlighters $out/share/
    cp -r etc/prism.css $out/share/
    cp -r etc/prism.tex $out/share/
    cp -r etc/prism-eclipse-formatter.xml $out/share/
    for size in 16 24 32 48 64 128 256; do
        mkdir --parents $out/share/icons/hicolor/''\${size}x''\${size}/apps
        cp etc/icons/p''\${size}.png $out/share/icons/hicolor/''\${size}x''\${size}/apps/prism-model-checker.png
    done
    mv install.sh $out/
    cd $out
    ./install.sh
    rm install.sh
    runHook postInstall
  '';

  meta = {
    description = "Probabalistic Symbolic Model Checker";

    homepage = "https://www.prismmodelchecker.org";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.astrobeastie ];
    platforms = lib.platforms.unix;
  };
})
