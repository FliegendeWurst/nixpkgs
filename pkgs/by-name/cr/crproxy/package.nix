{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "crproxy";
  version = "0.12.2"; # stable

  src = fetchFromGitHub {
    owner = "DaoCloud";
    repo = "crproxy";
    rev = "v${version}";
    hash = "sha256-PiM61gVZfrL+F1xPUMefj4UzJk1DipL7d3zkOTt1SUg=";
  };

  vendorHash = "sha256-htxMoIRTeTiC+/zo2EZNtJjwZPTZ5Gy0KP6qqt62bb4=";

  env.CGO_ENABLED = 0;

  doCheck = false;

  meta = with lib; {
    description = "CRProxy (Container Registry Proxy) is a generic image proxy";
    homepage = "https://github.com/DaoCloud/crproxy";
    license = licenses.mit;
    maintainers = with maintainers; [ SenseT ];
  };
}
