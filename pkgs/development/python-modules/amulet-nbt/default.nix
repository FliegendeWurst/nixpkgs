{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  cmake,
  pybind11,
  setuptools,
  wheel,
  versioneer,
  cython,

  # dependencies
  numpy,
  mutf8,
  black,
  pre-commit,
  sphinx,
  sphinx-autodoc-typehints,
  sphinx-rtd-theme,

  pytestCheckHook,
  nix-update-script,
}:
let
  version = "4.0.0a10";
in
buildPythonPackage {
  pname = "amulet-nbt";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Amulet-Team";
    repo = "Amulet-NBT";
    tag = version;
    hash = "sha256-xTlgfSNTfU4zhqJwKJW226OSWOgVKwMAEgrL8VBUu68=";
  };

  disabled = pythonOlder "3.11";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "pybind11[global]" "pybind11" \
      --replace-fail '"amulet-compiler-target == 1.0",' ""
    # FIXME: Drop for 4.x
    substituteInPlace setup.py \
      --replace-fail "versioneer.get_version()" "'${version}'"
  '';

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
  ];

  build-system = [
    pybind11
    setuptools
    wheel
    cython
    versioneer
    numpy
  ];

  dependencies = [
    numpy
    mutf8
  ];

  optional-dependencies = {
    dev = [
      black
      pre-commit
    ];
    docs = [
      sphinx
      sphinx-autodoc-typehints
      sphinx-rtd-theme
    ];
  };

  pythonImportsCheck = [ "amulet_nbt" ];

  nativeCheckInputs = [ pytestCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python library for reading and writing binary NBT and stringified NBT";
    homepage = "https://github.com/Amulet-Team/Amulet-NBT";
    changelog = "https://github.com/Amulet-Team/Amulet-NBT/releases/tag/${version}";
    license = with lib.licenses; [ amulet ];
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
