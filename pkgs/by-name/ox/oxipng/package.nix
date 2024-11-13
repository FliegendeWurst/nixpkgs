{ lib, stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "9.1.2";
  pname = "oxipng";

  # do not use fetchCrate (only repository includes tests)
  src = fetchFromGitHub {
    owner = "shssoichiro";
    repo = "oxipng";
    rev = "refs/tags/v${version}";
    hash = "sha256-0yOdvqleOjlhVADrwnT90bUTa+aLJfsfUvVaS9s3eKE=";
  };

  cargoHash = "sha256-LZ3YIosDpjDYVACWQsr/0XhgX4fyo8CyZG58WfLSzCs=";

  doCheck = true;

  meta = {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "Multithreaded lossless PNG compression optimizer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dywedir ];
    mainProgram = "oxipng";
  };
}
