{
  lib,
  stdenv,
  fetchurl,

  makeWrapper,
  perl,
  strace,
}:

stdenv.mkDerivation rec {
  pname = "pvs-studio";
  version = "7.33.85330.89";

  src =
    let
      system = stdenv.hostPlatform.system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
    in
    fetchurl {
      url = selectSystem {
        x86_64-darwin = "https://cdn.pvs-studio.com/pvs-studio-${version}-macos.tgz";
        x86_64-linux = "https://cdn.pvs-studio.com/pvs-studio-${version}-x86_64.tgz";
      };
      hash = selectSystem {
        x86_64-darwin = "sha256-gSqIAK3jy3MnO/1ISrD8K1G2Ltld59Nb1GKuJDE3kwY=";
        x86_64-linux = "sha256-Tdrlq3cLxhYOTV9qjbdgeO5XR0Wy2+Ijc7bg5KDbYrk=";
      };
    };

  nativeBuildInputs = [ makeWrapper ];

  nativeRuntimeInputs = lib.makeBinPath [
    perl
    strace
  ];

  installPhase = ''
    runHook preInstall

    install -D -m 0755 bin/* -t $out/bin
    install -D -m 0644 etc/bash_completion.d/* -t $out/etc/bash_completion.d

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/pvs-studio-analyzer" \
      --prefix PATH ":" ${nativeRuntimeInputs}
  '';

  meta = {
    description = "Static analyzer for C and C++";
    homepage = "https://pvs-studio.com/en/pvs-studio";
    license = lib.licenses.unfreeRedistributable;
    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ paveloom ];
  };
}
