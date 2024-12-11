{
  mkDerivation,
  cmake,
  extra-cmake-modules,
  bzip2,
  xz,
  qtbase,
  qttools,
  zlib,
  zstd,
}:

mkDerivation {
  pname = "karchive";
  nativeBuildInputs = [
    extra-cmake-modules
    qttools
  ];
  buildInputs = [
    bzip2
    qtbase
    xz
    zlib
    zstd
  ];
  strictDeps = true;
  propagatedBuildInputs = [ qtbase ];
  outputs = [
    "out"
    "dev"
  ];
}
