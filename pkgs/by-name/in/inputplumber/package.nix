{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
  libiio,
  libevdev,
}:

rustPlatform.buildRustPackage rec {
  pname = "inputplumber";
  version = "0.39.2";

  src = fetchFromGitHub {
    owner = "ShadowBlip";
    repo = "InputPlumber";
    rev = "refs/tags/v${version}";
    hash = "sha256-Glq7iJ1AHy99AGXYg5P3wAd3kAMJnt5P2vZzyn7qBY4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "evdev-0.12.2" = "sha256-OUU7QQnC3sgq0WwlWrm+ymustTtAoNqXhoZ/wixcgeY=";
      "virtual-usb-0.1.0" = "sha256-1apEKO5C9TjZ9IUJfvPOEvwq+mwsUSa5m0S7YSi2whw=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    udev
    libevdev
    libiio
  ];

  postInstall = ''
    cp -r rootfs/usr/* $out/
  '';

  meta = {
    description = "Open source input router and remapper daemon for Linux";
    homepage = "https://github.com/ShadowBlip/InputPlumber";
    license = lib.licenses.gpl3Plus;
    changelog = "https://github.com/ShadowBlip/InputPlumber/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ shadowapex ];
    mainProgram = "inputplumber";
  };
}
