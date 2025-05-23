{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "ssl-proxy";
  version = "0.2.7-unstable-2024-02-05";

  src = fetchFromGitHub {
    owner = "suyashkumar";
    repo = "ssl-proxy";
    rev = "6b0f364be9bbf0de46520a6b85d30792fcc3cb80";
    hash = "sha256-tYAsz99YCOOEyxPp8Yp+PTn+q2Edir+xy4Vs0yyHWOQ=";
  };

  vendorHash = "sha256-PQ465+4AcH0wP4z2GsGdf/yABaGezaPq+eM0U2lu13o=";

  checkTarget = "test";

  meta = with lib; {
    homepage = "https://github.com/suyashkumar/ssl-proxy";
    description = "Simple single-command SSL reverse proxy with autogenerated certificates (LetsEncrypt, self-signed)";
    longDescription = ''
      A handy and simple way to add SSL to your thing running on a VM--be it your personal jupyter
      notebook or your team jenkins instance. ssl-proxy autogenerates SSL certs and proxies
      HTTPS traffic to an existing HTTP server in a single command.
    '';
    license = licenses.mit;
    mainProgram = "ssl-proxy";
    maintainers = [ maintainers.konst-aa ];
    platforms = platforms.linux ++ platforms.darwin ++ platforms.windows;
  };
}
