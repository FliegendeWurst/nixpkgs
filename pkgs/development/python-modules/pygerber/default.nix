{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  poetry-core,

  # dependencies
  numpy,
  click,
  pillow,
  pydantic,
  pyparsing,
  typing-extensions,
  tzlocal,

  # optional dependencies
  pygls,
  lsprotocol,
  drawsvg,
  pygments,
  shapely,

}:

let
  pillow_10_4 = pillow.overrideAttrs (prev: {
    version = "10.4.0";
    src = fetchFromGitHub {
      owner = "python-pillow";
      repo = "pillow";
      rev = "refs/tags/10.4.0";
      hash = "sha256-Q3yvFyJf4gFaVY9X4PlgCE2rU1l9NEXkHBaNZfoHhvU=";
    };
  });

in
buildPythonPackage rec {
  pname = "pygerber";
  version = "2.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Argmaster";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+s89tHNTNP+0VMilfDczbOBG/e3DuUBu0113US69KKM=";
  };

  nativeBuildInputs = [ poetry-core ];
  propagatedBuildInputs = [
    numpy
    click
    pillow_10_4
    pydantic
    pyparsing
    typing-extensions
    tzlocal
  ];

  passthru.optional-dependencies = {
    language_server = [
      pygls
      lsprotocol
    ];
    svg = [ drawsvg ];
    pygments = [ pygments ];
    shapely = [ shapely ];
    all = [
      pygls
      lsprotocol
      drawsvg
      pygments
      shapely
    ];
  };

  pythonImportsCheck = [ "pygerber" ];

  meta = {
    description = "PyGerber is a Python implementation of Gerber X3/X2 format. It is based on Ucamco's The Gerber Layer Format Specification.";
    homepage = "https://github.com/Argmaster/pygerber";
    changelog = "https://argmaster.github.io/pygerber/stable/Changelog.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ clemjvdm ];
  };
}
