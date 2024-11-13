{ mkDerivation, extra-cmake-modules, qtbase, qttools, gperf, cmake }:

mkDerivation {
  pname = "kcodecs";
  nativeBuildInputs = [ gperf extra-cmake-modules ];
  buildInputs = [ qttools ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
