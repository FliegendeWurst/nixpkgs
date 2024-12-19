{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "gnome-pomodoro-watcher";
  version = "unstable-2023-12-20";

  src = fetchFromGitHub {
    owner = "sei40kr";
    repo = "gnome-pomodoro-watcher";
    rev = "7c1443d470c9a6bfc07fd9d26a138f136de96515";
    hash = "sha256-VQjjLK2gnxbf7CzRjNrS/562fBGVAFMTxj6F71hOXrU=";
  };

  cargoHash = "sha256-xhp+RZtY+55f4qK97t02LHZkXkGH94YYcHArpJxqQ5k=";

  meta = with lib; {
    description = "A helper tool to watch GNOME Pomodoro timer";
    homepage = "https://github.com/sei40kr/gnome-pomodoro-watcher";
    license = licenses.mit;
    maintainers = with maintainers; [ sei40kr ];
    mainProgram = "gnome-pomodoro-watcher";
  };
}
