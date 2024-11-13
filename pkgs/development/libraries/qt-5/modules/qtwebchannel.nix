{ lib
, stdenv
, qtModule
, qtbase
, qtdeclarative
}:

qtModule {
  pname = "qtwebchannel";
  propagatedBuildInputs = [ qtbase qtdeclarative ];
  strictDeps = false; # TODO
  outputs = [ "out" "dev" ] ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [ "bin" ];
}
