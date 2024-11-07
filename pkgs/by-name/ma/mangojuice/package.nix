{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  cmake,
  vala,
  pkg-config,
  makeBinaryWrapper,

  gtk4,
  libadwaita,
  glib,
  libgee,

  mangohud,
  mesa-demos,
  vulkan-tools,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mangojuice";
  version = "0.7.8";

  src = fetchFromGitHub {
    owner = "radiolamp";
    repo = "mangojuice";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-EWpXikyO7N2NjONqnTx8+9w16Pt5ne7qX67bYirShjc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    cmake
    vala
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [
    gtk4
    libadwaita
    glib
    mangohud
    libgee
  ];

  postFixup =
    let
      path = lib.makeBinPath [
        mangohud
        mesa-demos
        vulkan-tools
      ];
    in
    ''
      wrapProgram $out/bin/mangojuice \
        --prefix PATH : ${path}
    '';

  meta = {
    description = "Convenient alternative to GOverlay for setting up MangoHud";
    homepage = "https://github.com/radiolamp/mangojuice";
    license = with lib.licenses; [ gpl3Only ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pluiedev ];
  };
})
