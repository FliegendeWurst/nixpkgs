{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "bmputil";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "blackmagic-debug";
    repo = "bmputil";
    rev = "v${version}";
    hash = "sha256-LKtdwQbsPNEu3EDTowOXeFmi5OHOU3kq5f5xxevBjtM=";
  };
  cargoHash = "sha256-iRaNpQ/XG++7nSzzBI9C/yamGci1vnPiq8weMjkg9Sw=";
  postInstall = ''
    install -Dm 444 ${./50-blackmagic.conf} $out/lib/udev/rules.d/50-blackmagic.conf
  '';

  meta = {
    description = "Black Magic Probe Firmware Manager";
    homepage = "https://github.com/blackmagic-debug/bmputil";
    license = lib.licenses.mit;
    mainProgram = "bmputil";
    maintainers = [ lib.maintainers.shimun ];
  };
}
