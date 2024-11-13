{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  versionCheckHook,
  dbip-country-lite,
}:

buildGoModule rec {
  pname = "nezha";
  version = "0.20.6";

  src = fetchFromGitHub {
    owner = "naiba";
    repo = "nezha";
    rev = "refs/tags/v${version}";
    hash = "sha256-A/9l8W0fOrVXoh8TA1NFMlCs+8unc+jgmmVMPfFheWI=";
  };

  postPatch = ''
    cp ${dbip-country-lite.mmdb} pkg/geoip/geoip.db
  '';

  patches = [
    # Nezha originally used ipinfo.mmdb to provide geoip query feature.
    # Unfortunately, ipinfo.mmdb must be downloaded with token.
    # Therefore, we patch the nezha to use dbip-country-lite.mmdb in nixpkgs.
    ./dbip.patch
  ];

  vendorHash = "sha256-IMS9o9f/65r4RClg1/0gAb/zbXvky8NTYrhOfXeDXEo=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/naiba/nezha/service/singleton.Version=${version}"
  ];

  checkFlags = "-skip=^TestSplitDomainSOA$";

  postInstall = ''
    mv $out/bin/dashboard $out/bin/nezha
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  meta = {
    description = "Self-hosted, lightweight server and website monitoring and O&M tool";
    homepage = "https://github.com/naiba/nezha";
    changelog = "https://github.com/naiba/nezha/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "nezha";
  };
}
