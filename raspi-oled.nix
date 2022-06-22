{ lib, fetchFromGitHub, rustPlatform, pkg-config, sqlite }:

rustPlatform.buildRustPackage rec {
  pname = "raspi-oled";
  version = "unstable-infdev";

  src = /home/arne/src/raspi-oled;

  cargoSha256 = "sha256-id5oJHY1dGVILXVbGaR4PDKCsjeU0ARF7FyWIfZHg0s=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ sqlite ];

  meta = with lib; {
    description = "raspi-oled";
  };
}

