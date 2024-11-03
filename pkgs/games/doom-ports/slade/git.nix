{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, which
, zip
, wxGTK
, gtk3
, sfml
, fluidsynth
, curl
, freeimage
, ftgl
, glew
, lua
, mpg123
, wrapGAppsHook3
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "slade";
  version = "3.2.6-unstable-2024-10-23";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = "98f9b5cbf4bd832a4f9792bc0ea216fcb8d6e9a5";
    hash = "sha256-XrJYs5qC6PzhmTBDAw3Mv7eLuTVgp8jT9F2wiMpr/LY=";
  };

  postPatch = lib.optionalString (!stdenv.hostPlatform.isx86) ''
    sed -i '/-msse/d' src/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    which
    zip
    wrapGAppsHook3
  ];

  buildInputs = [
    wxGTK
    gtk3
    sfml
    fluidsynth
    curl
    freeimage
    ftgl
    glew
    lua
    mpg123
  ];

  cmakeFlags = [
    "-DwxWidgets_LIBRARIES=${wxGTK}/lib"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-narrowing";

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix GDK_BACKEND : x11
    )
  '';

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/sirjuddington/SLADE.git";
  };

  meta = with lib; {
    description = "Doom editor";
    homepage = "http://slade.mancubus.net/";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ertes ];
  };
}
