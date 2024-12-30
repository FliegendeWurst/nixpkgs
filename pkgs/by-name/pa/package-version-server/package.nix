{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "package-version-server";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "package-version-server";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ht5huLugAIj2FTMywdvtxjeM30klwwV8mdq36AxJ2IY=";
  };

  cargoHash = "sha256-AJldLcUTxenqVFHFPPMaga7QjnjAtyAdbj6OO1DB9IU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A language server that handles hover information in package.json files";
    homepage = "https://github.com/zed-industries/package-version-server/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felixdorn ];
    mainProgram = "package-version-server";
  };
}
