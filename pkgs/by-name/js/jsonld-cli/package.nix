{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "jsonld-cli";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "digitalbazaar";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GandTCcRYd0c0SlSdsCAcaTKfwD4g1cwHuoxA62aD74=";
  };

  postPatch = "cp ${./package-lock.json} package-lock.json";
  npmDepsHash = "sha256-6oQKHeX5P2UsXRFK7ZwmJYasuNT5Ch/bYCIUAXq5zUM=";
  dontNpmBuild = true;

  meta = with lib; {
    description = "JSON-LD command line interface tool";
    homepage = "https://github.com/digitalbazaar/jsonld-cli";
    license = licenses.bsd3;
    maintainers = with maintainers; [ msladecek ];
    mainProgram = "jsonld";
  };
}
