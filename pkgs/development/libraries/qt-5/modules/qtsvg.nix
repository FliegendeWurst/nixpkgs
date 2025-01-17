{ qtModule, qtbase, stdenv }:

qtModule {
  pname = "qtsvg";
  propagatedBuildInputs = [ qtbase ];
  outputs = [
    "out"
    "dev"
    "bin"
  ];
  meta.broken = stdenv.buildPlatform != stdenv.hostPlatform;
}
