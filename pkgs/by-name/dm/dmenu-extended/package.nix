{
  lib,
  fetchFromGitHub,
  python3Packages,
  dmenu,
}:

python3Packages.buildPythonApplication rec {

  pname = "dmenu-extended";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MarkHedleyJones";
    repo = "dmenu-extended";
    rev = version;
    hash = "sha256-IYp5S3etgiF2Js94HmQ737QjnWNbvLcA4RzvcDfycq4=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = [
    python3Packages.setuptools
    dmenu
  ];

  meta = with lib; {
    description = "An extension to dmenu for quickly opening files and folders";
    homepage = "https://github.com/MarkHedleyJones/dmenu-extended";
    license = licenses.mit;
    maintainers = with maintainers; [ ByteSudoer ];
    mainProgram = "dmenu-extended";
    platforms = platforms.unix;
  };
}
