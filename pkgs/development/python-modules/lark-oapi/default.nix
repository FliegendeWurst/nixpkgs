{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  requests-toolbelt,
  pycryptodome,
  websockets,
  protobuf3,
  httpx,
}:

buildPythonPackage rec {
  pname = "lark-oapi";
  version = "1.3.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jhis9H7z94KCJy2EM79Hy44ouDnmSIXirJ7fOCZA2G8=";
  };

  dependencies = [
    requests
    requests-toolbelt
    pycryptodome
    websockets
    protobuf3
    httpx
  ];

  meta = with lib; {
    homepage = "https://github.com/larksuite/oapi-sdk-python";
    description = "Larksuite development interface SDK";
    license = licenses.mit;
    maintainers = with maintainers; [ yoctocell ];
  };
}
