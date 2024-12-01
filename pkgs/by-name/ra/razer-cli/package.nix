{
  lib,
  python3,
  fetchFromGitHub,
  xrdb,
}:

# requires openrazer-daemon to be running on the system
# on NixOS hardware.openrazer.enable or pkgs.openrazer-daemon

python3.pkgs.buildPythonApplication {
  pname = "razer-cli";
  version = "2.2.1-unstable-2024-04-04";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lolei";
    repo = "razer-cli";
    rev = "e4c9a93f012fea2362e18c3374a38bc77a62d86b";
    hash = "sha256-HWEYcYYHQs2uZZtiK+BaKU2yc90dJ+FEbR+ohq0Wkpw=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = [
    python3.pkgs.openrazer
  ];

  buildInputs = [
    xrdb
  ];

  meta = {
    homepage = "https://github.com/LoLei/razer-cli";
    description = "Command line interface for controlling Razer devices on Linux";
    mainProgram = "razer-cli";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.kaylorben ];
    platforms = lib.platforms.linux;
  };
}
