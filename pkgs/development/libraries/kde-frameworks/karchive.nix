{
  mkDerivation,
  cmake,
  extra-cmake-modules,
  bzip2, xz, qtbase, qttools, zlib, zstd
}:

mkDerivation {
  pname = "karchive";
  nativeBuildInputs = [ qttools extra-cmake-modules ];
  buildInputs = [ bzip2 xz zlib zstd qtbase ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
