{
  stdenvNoCC,
  pname ? ""
}
:
stdenvNoCC.mkDerivation {
  name = "undefined-variable-${pname}";

  dontUnpack = true;

  installPhase = ''
    mkdir $out
  '';
}