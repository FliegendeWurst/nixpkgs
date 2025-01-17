{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,

  # for passthru.tests
  distributed,
  jupyter-server,
  jupyterlab,
  matplotlib,
  mitmproxy,
  pytest-tornado,
  pytest-tornasync,
  pyzmq,
  sockjs-tornado,
  urllib3,
}:

buildPythonPackage rec {
  pname = "tornado";
  version = "6.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tornadoweb";
    repo = "tornado";
    tag = "v${version}";
    hash = "sha256-qgJh8pnC1ALF8KxhAYkZFAc0DE6jHVB8R/ERJFL4OFc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  # relax performance-sensitive tests
  preCheck = ''
    substituteInPlace tornado/test/ioloop_test.py \
      --replace-fail 'self.assertLess(delta, 0.1)' 'self.assertLess(delta, 2)'
    substituteInPlace tornado/test/gen_test.py \
      --replace-fail 'gen.with_timeout(datetime.timedelta(seconds=0.2), tester())' \
                     'gen.with_timeout(datetime.timedelta(seconds=4.0), tester())'
    substituteInPlace tornado/test/autoreload_test.py \
      --replace-fail 'for i in range(40):' 'for i in range(800):'
  '';

  disabledTestPaths = [
    # additional tests that have extra dependencies, run slowly, or produce more output than a simple pass/fail
    # https://github.com/tornadoweb/tornado/blob/v6.2.0/maint/test/README
    "maint/test"

    # AttributeError: 'TestIOStreamWebMixin' object has no attribute 'io_loop'
    "tornado/test/iostream_test.py"
  ];

  disabledTests = [
    # Exception: did not get expected log message
    "test_unix_socket_bad_request"
  ];

  pythonImportsCheck = [ "tornado" ];

  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    inherit
      distributed
      jupyter-server
      jupyterlab
      matplotlib
      mitmproxy
      pytest-tornado
      pytest-tornasync
      pyzmq
      sockjs-tornado
      urllib3
      ;
  };

  meta = with lib; {
    description = "Web framework and asynchronous networking library";
    homepage = "https://www.tornadoweb.org/";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
