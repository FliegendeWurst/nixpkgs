{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "task-keeper";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "linux-china";
    repo = "task-keeper";
    rev = "refs/tags/v${version}";
    hash = "sha256-lcwWl1ycMSmHgYT4m+CofwefqnjxjvuJkcv1Pe0OtEo=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
  cargoHash = "sha256-OVDwaMpA2gw0asdQ+yNRKmcmXLs+ddJI/lodewXujro=";

  # tests depend on many packages (java, node, python, sbt, ...) - which I'm not currently willing to set up 😅
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/linux-china/task-keeper";
    description = "CLI to manage tasks from different task runners or package managers";
    license = licenses.asl20;
    maintainers = with maintainers; [ tennox ];
    mainProgram = "tk";
  };
}
