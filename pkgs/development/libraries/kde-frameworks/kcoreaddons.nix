{
  mkDerivation,
  extra-cmake-modules,
  qtbase,
  qttools,
  shared-mime-info,
}:

mkDerivation {
  pname = "kcoreaddons";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    qttools
    shared-mime-info
  ];
  propagatedBuildInputs = [ qtbase ];
  # env.NIX_CFLAGS_COMPILE = "-D_GLIBCXX_SYSHDR";
}
