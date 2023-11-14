{ lib
, fetchFromGitHub
, python3Packages
, fetchPypi
, ogdf
, cppyy-cling
}:
python3Packages.buildPythonPackage rec {
  pname = "cppyy-backend";
  version = "1.15.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-QZe/tPmNK5TV0S3coxSzyj07CJ3EddWBvrCSwqcD0YM=";
  };

  nativeBuildInputs = with python3Packages; [
    # rich
    # pythonRelaxDepsHook
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    # hatchling
    # cppyy
    # python3Packages.rich
    cppyy-cling
  ];

  buildInputs = [
    # ogdf
    # python3Packages.cppyy
  ];

  makeWrapperArgs = [
    # "--suffix PATH : ${lib.makeBinPath [ ffmpeg ]}"
  ];

  doCheck = true;
  pythonImportsCheck = [ "cppyy_backend" ];

  # pythonRelaxDeps = [ "rich" ];

  meta = with lib; {
    homepage = "https://github.com/wlav/cppyy-backend/tree/master/clingwrapper";
    description = "Automatic, dynamic Python-C++ bindings (backend)";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fliegendewurst ];
  };
}
