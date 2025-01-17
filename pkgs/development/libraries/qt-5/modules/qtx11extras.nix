{ qtModule, qtbase, stdenv }:

qtModule {
  pname = "qtx11extras";
  propagatedBuildInputs = [ qtbase ];
  meta.broken = stdenv.buildPlatform != stdenv.hostPlatform;
}
