{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "stgpytools";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Setsugennoao";
    repo = "stgpytools";
    rev = "1cfcf8b26315db706ad1947b4ab3ef938a857061"; # upstream did not tag release
    hash = "sha256-tJTq4xPxuFAZLzhworjjixFNWDb0FfBKLBLnttFYvH4=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [
    "stgpytools"
    "stgpytools.enums"
    "stgpytools.exceptions"
    "stgpytools.functions"
    "stgpytools.types"
    "stgpytools.utils"
  ];

  doCheck = false; # no tests

  meta = {
    description = "Collection of stuff that's useful in general python programming";
    homepage = "https://github.com/Setsugennoao/stgpytools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
