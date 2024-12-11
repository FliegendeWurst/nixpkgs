{
  qtModule,
  qtbase,
  qtdeclarative,
}:

qtModule {
  pname = "qtwebsockets";
  nativeBuildInputs = [ qtdeclarative ];
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  outputs = [
    "out"
    "dev"
    "bin"
  ];
}
