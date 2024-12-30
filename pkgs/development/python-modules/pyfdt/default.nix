{
  lib,
  bison,
  buildPythonPackage,
  fetchFromGitHub,
  flex,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyfdt";
  version = "0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "superna9999";
    repo = "pyfdt";
    rev = "refs/tags/pyfdt-${version}";
    hash = "sha256-x5RQI4giQVywCbBSL5MOpa2k0E88gj+NDRMjoja4rQM=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ flex bison ];

  checkPhase = ''
    runHook preCheck
    bash tests/do_tests.bash
    runHook postCheck
  '';

  # https://github.com/superna9999/pyfdt/issues/21
  # dtc-parser.tab.o:/build/source/tests/dtc/dtc-parser.tab.c:1079: multiple definition of `yylloc'
  doCheck = false;

  pythonImportsCheck = [ "pyfdt" ];

  meta = {
    homepage = "https://github.com/superna9999/pyfdt";
    description = "Flattened device tree parser";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ralismark ];
  };
}
