{
  qtModule,
  qtbase,
  qtdeclarative,
}:

qtModule {
  pname = "qtcharts";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  strictDeps = false;
  outputs = [
    "out"
    "dev"
    "bin"
  ];
}
