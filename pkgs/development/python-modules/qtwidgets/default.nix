{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyqt5,
  setuptools-scm,
}:
buildPythonPackage {
  pname = "qtwidgets";
  version = "1.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "xyven1";
    repo = "python-qtwidgets";
    rev = "8d49b4edccfe8fa638a54c83b864174bec55576d";
    sha256 = "sha256-cWig3Hfv+v4w1pJQSQoLTOp2zD8U1F/IoMbyuNLtle8=";
  };

  build-inputs = [ setuptools-scm ];

  dependencies = [ pyqt5 ];

  doCheck = false;

  meta = {
    description = "Custom widget library for PyQt5 and PySide2 (Qt for Python). Free to use in your own applications.";
    homepage = "https://github.com/pythonguis/python-qtwidgets";
    license = with lib.licenses; [ mit ];
  };
}
