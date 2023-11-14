{ lib
, fetchFromGitHub
, python3Packages
, fetchPypi
, ogdf
}:
python3Packages.buildPythonPackage rec {
  pname = "cppyy";
  version = "3.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-yV/PnFdTGeXTzzEJsBAsaRtPrXZPja5ER5CYDC/q7rg=";
  };

  nativeBuildInputs = with python3Packages; [
    # rich
    # pythonRelaxDepsHook
    setuptools # from setuptools.build_meta import _BACKEND
  ];

  propagatedBuildInputs = with python3Packages; [
    # hatchling
    # cppyy
    # python3Packages.rich
  ];

  buildInputs = [
    # ogdf
    # python3Packages.cppyy
  ];

  makeWrapperArgs = [
    # "--suffix PATH : ${lib.makeBinPath [ ffmpeg ]}"
  ];

  doCheck = true;
  pythonImportsCheck = [ "cppyy" ];

  # pythonRelaxDeps = [ "rich" ];

  meta = with lib; {
    homepage = "https://github.com/wlav/cppyy";
    description = "Automatic, dynamic Python-C++ bindings";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fliegendewurst ];
  };
}
