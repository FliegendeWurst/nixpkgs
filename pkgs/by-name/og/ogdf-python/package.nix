{ lib
, fetchFromGitHub
, python3Packages
, fetchPypi
, ogdf
}:
python3Packages.buildPythonPackage rec {
  pname = "ogdf-python";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "ogdf_python";
    sha256 = "sha256-TUb8CfeRXMbnnqV8eTRlgC+dbCAIkWuMkn+8tmBFOoc=";
  };

  nativeBuildInputs = with python3Packages; [
    # rich
    # pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3Packages; [
    hatchling
    cppyy
    # python3Packages.rich
    # python3Packages.setuptools # imports pkg_resources.parse_version
  ];

  buildInputs = [
    ogdf
    # python3Packages.cppyy
  ];

  makeWrapperArgs = [
    # "--suffix PATH : ${lib.makeBinPath [ ffmpeg ]}"
  ];

  doCheck = true;
  pythonImportsCheck = [ "ogdf_python" ];

  # pythonRelaxDeps = [ "rich" ];

  meta = with lib; {
    homepage = "https://github.com/ogdf/ogdf-python";
    description = "Python Bindings for the Open Graph Drawing Framework";
    license = licenses.asl20;
    maintainers = with maintainers; [ fliegendewurst ];
  };
}
