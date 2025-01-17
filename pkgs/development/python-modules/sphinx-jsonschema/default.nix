{
  lib,
  buildPythonPackage,
  fetchPypi,
  docutils,
  requests,
  setuptools,
  jsonpointer,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "sphinx-jsonschema";
  version = "1.19.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "sphinx-jsonschema";
    sha256 = "sha256-sjhf4ces8udZFSrv7QyxfJIGRbKnXJk0AAycUo59U8E=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    docutils
    requests
    jsonpointer
    pyyaml
  ];

  meta = {
    description = "A Sphinx extension to display a JSON Schema";
    homepage = "https://github.com/lnoor/sphinx-jsonschema";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      JulianFP
    ];
  };
}
