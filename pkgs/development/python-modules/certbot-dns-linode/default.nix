{
  buildPythonPackage,
  pythonPackages,
  acme,
  certbot,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "certbot-dns-linode";
  format = "setuptools";

  inherit (certbot) src version;
  disabled = pythonOlder "3.6";

  sourceRoot = "${src.name}/certbot-dns-linode";

  propagatedBuildInputs = [
    acme
    certbot
    pythonPackages.dns-lexicon
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "-o cache_dir=$(mktemp -d)" ];

  meta = certbot.meta // {
    description = "Linode DNS Authenticator plugin for Certbot
";
  };
}
