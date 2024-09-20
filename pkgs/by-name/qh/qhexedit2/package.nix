{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  qt6,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qhexedit2";
  version = "0.8.9-unstable-2024-10-05";

  # Use unstable because of some significant improvements to the program
  src = fetchFromGitHub {
    owner = "Simsys";
    repo = "qhexedit2";
    rev = "3a468e4ae52d929eb7e96a3918ab8f8e7d55fc58";
    hash = "sha256-7c5bihdLe5+wsl0GGv4fcQeU6qQvnTPNrJmhYAFeLaI=";
  };

  patches = [
    # Adds support for the version flag
    (fetchpatch {
      url = "https://github.com/Simsys/qhexedit2/commit/85a6732fe1e8b829b2b34519909514a62ad91099.patch";
      hash = "sha256-m8OBcuKiFoiAR7/f/JxCfiY8v2KwLogHfbqHSO5QPyw=";
    })
  ];

  postPatch = ''
    # Replace QPallete::Background with QPallete::Window in all files, since QPallete::Background was removed in Qt 6
    find . -type f -exec sed -i 's/QPalette::Background/QPalette::Window/g' {} +
  '';

  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools
    qt6.qtwayland
  ];

  qmakeFlags = [
    "./example/qhexedit.pro"
  ];

  # A custom installPhase is needed because no [native] build input provides an installPhase hook
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp qhexedit $out/bin

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    # I would use testers.testVersion except for some reason it fails
    # TODO: Debug why testVersion reports a non-zero status code in the nix sandbox
  };

  meta = {
    description = "Hex Editor for Qt";
    homepage = "https://github.com/Simsys/qhexedit2";
    changelog = "https://github.com/Simsys/qhexedit2/releases";
    mainProgram = "qhexedit";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
