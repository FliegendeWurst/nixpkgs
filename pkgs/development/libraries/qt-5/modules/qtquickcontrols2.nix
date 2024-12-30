{ qtModule, qtdeclarative }:

qtModule {
  pname = "qtquickcontrols2";
  nativeBuildInputs = [ qtdeclarative ];
  propagatedBuildInputs = [ qtdeclarative ];
  outputs = [
    "out"
    "dev"
    "bin"
  ];
}
