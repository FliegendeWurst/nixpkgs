{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
  pciutils,
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "powerstation";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "ShadowBlip";
    repo = "PowerStation";
    tag = "v${version}";
    hash = "sha256-n6ijmLpc2yXUGVtR/lMIIZcUUUvYmG4dIqoqPykFesw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-c1QNwycihWKAFAcgPOB4cagtxRdIMcibxEDnknb6zU8=";

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    udev
    pciutils
  ];

  postInstall = ''
    cp -r rootfs/usr/* $out/
  '';

  meta = {
    description = "Open source TDP control and performance daemon with DBus interface";
    homepage = "https://github.com/ShadowBlip/PowerStation";
    license = lib.licenses.gpl3Plus;
    changelog = "https://github.com/ShadowBlip/PowerStation/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ shadowapex ];
    mainProgram = "powerstation";
  };
}
