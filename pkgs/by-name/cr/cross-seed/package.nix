{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "cross-seed";
  version = "6.0.0-43";

  src = fetchFromGitHub {
    owner = "cross-seed";
    repo = "cross-seed";
    rev = "v${version}";
    hash = "sha256-oglNCTZ9o4saqnQ0imsjNeobsTFn9ZT6yVjOzBO+BTo=";
  };

  npmDepsHash = "sha256-Ta5QKHn3tX4ZGZEiMg8RYlJykM7TuQWVML/v9ujWYVU=";

  meta = {
    description = "Fully-automatic torrent cross-seeding with Torznab";
    homepage = "https://cross-seed.org";
    license = lib.licenses.asl20;
    mainProgram = "cross-seed";
    maintainers = with lib.maintainers; [ mkez ];
  };
}
