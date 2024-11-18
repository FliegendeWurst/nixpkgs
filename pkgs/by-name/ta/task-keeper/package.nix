{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "task-keeper";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "linux-china";
    repo = "task-keeper";
    rev = "8b6d5432289dcb90f21b5d2a5d0a0338aa4c95b1";
    hash = "sha256-l/sqYuFrSDJN4Y9NN2fpkEI7AWctezLRi/pNAkPmHRk=";
  };

  cargoHash = "sha256-Dzua9gp8xMcpL8JMvQbLCjE171rxQSKK/mmD58C3DMc=";

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
