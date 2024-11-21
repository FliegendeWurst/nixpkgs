{
  lib,
  fetchFromGitHub,
  python3Packages,
  qt6Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "nagstamon";
  version = "3.16.2";

  src = fetchFromGitHub {
    owner = "HenriWahl";
    repo = "Nagstamon";
    rev = "refs/tags/v${version}";
    hash = "sha256-9w8ux+AeSg0vDhnk28/2eCE2zYLvAjD7mB0pJBMFs2I=";
  };

  # Test assumes darwin
  doCheck = false;

  buildInputs = [
    qt6Packages.qtmultimedia
    qt6Packages.qtbase
    qt6Packages.qtsvg
  ];

  nativeBuildInputs = [ qt6Packages.wrapQtAppsHook ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    arrow
    configparser
    pyqt6
    psutil
    requests
    beautifulsoup4
    keyring
    requests-kerberos
    lxml
    dbus-python
    python-dateutil
    pysocks
  ];

  meta = with lib; {
    description = "Status monitor for the desktop";
    homepage = "https://nagstamon.de/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      pSub
      liberodark
    ];
    badPlatforms = platforms.darwin;
  };
}
