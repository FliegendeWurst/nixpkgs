{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:
rustPlatform.buildRustPackage rec {
  pname = "utpm";
  version = "dev-0363e5";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "typst-project-0.1.0" = "sha256-Qys3F6Maq0HpC/50yyAZRpsOQ+ePzaz/TuHdfjtQRwY";
    };
  };

  src = fetchFromGitHub {
    owner = "Thumuss";
    repo = pname;
    rev = version;
    hash = "sha256-fvdMhSbsknKHQ9GTlzB2keHYkBFV/FULcHAQnhTRoFo=";
  };

  env.OPENSSL_NO_VENDOR = 1;

  buildInputs = [
    openssl
  ];
  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    description = "A package manager for typst";
    longDescription = ''
      UTPM is a package manager for local and remote packages. Create quickly
      new projects and templates from a singular tool, and then publish it directly
      to Typst!
    '';
    homepage = "https://github.com/Thumuss/utpm";
    license = lib.licenses.mit;
    mainProgram = "utpm";
    maintainers = with lib.maintainers; [ louis-thevenet ];
  };
}
