{
  lib,
  stdenv,
  prism-model-checker-unwrapped,
  java,
  symlinkJoin,
  makeWrapper,
  writeText,
}:
let
  desktopEntry = writeText "prism-model-checker-xprism.desktop" ''
    [Desktop Entry]
    Type=Application
    Icon=prism-model-checker
    Terminal=false
    Categories=Science;Math
    Comment=Probabalistic Symbolic Model Checker
    Name=XPrism
    Version=${prism-model-checker-unwrapped.version}
    Exec=xprism
  '';
in
symlinkJoin {
  name = "prism-model-checker-${prism-model-checker-unwrapped.version}";
  nativeBuildInputs = [ makeWrapper ];
  paths = [
    prism-model-checker-unwrapped
    java
  ];

  postBuild = ''
    rm -rf $out/bin
    mkdir --parents $out/bin
    for f in $(ls ${prism-model-checker-unwrapped}/bin); do
      makeWrapper "${prism-model-checker-unwrapped}/bin/$f" "$out/bin/$f" \
          --set JAVA_HOME ${java.home} \
          --set PRISM_JAVA ${java.home}/bin/java \
          --prefix PATH: ${lib.makeBinPath [ java ]}
    done
    mkdir --parents $out/share/applications
    cp ${desktopEntry} $out/share/applications/prism-model-checker-xprism.desktop
  '';
  meta = prism-model-checker-unwrapped.meta;
}
