{
  lib,
  stdenv,
  testers,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  container-structure-test,
}:
buildGoModule rec {
  version = "1.19.3";
  pname = "container-structure-test";
  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = "container-structure-test";
    rev = "v${version}";
    sha256 = "sha256-KLLACXUn6dtVCI+gCMHU9hoAJBOAVyhfwxtzsopWS4U=";
  };
  vendorHash = "sha256-pBq76HJ+nluOMOs9nqBKp1mr1LuX2NERXo48g8ezE9k=";

  subPackages = [ "cmd/container-structure-test" ];
  ldflags = [ "-X github.com/${src.owner}/${src.repo}/pkg/version.version=${version}" ];
  preBuild = ''
    ldflags+=" -X github.com/${src.owner}/${src.repo}/pkg/version.buildDate=$(date +'%Y-%m-%dT%H:%M:%SZ')"
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      $out/bin/${pname} completion $shell > executor.$shell
      installShellCompletion executor.$shell
    done
  '';

  passthru.tests.version = testers.testVersion {
    package = container-structure-test;
    version = version;
    command = "${container-structure-test}/bin/${pname} version";
  };

  meta = {
    homepage = "https://github.com/GoogleContainerTools/container-structure-test";
    description = "The Container Structure Tests provide a powerful framework to validate the structure of a container image.";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rubenhoenle ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    mainProgram = "container-structure-test";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
