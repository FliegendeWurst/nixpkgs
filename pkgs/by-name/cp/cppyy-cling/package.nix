{ lib
, fetchFromGitHub
, python3Packages
, fetchPypi
, ogdf
, cmake
, cling
, pkg-config
}:
python3Packages.buildPythonPackage rec {
  pname = "cppyy-cling";
  version = "6.30.0";
  # pyproject = true;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XZ4FUaTLYY6zOSABs9wsYpTwIlfwL81NhomZugT5KvE=";
  };

  nativeBuildInputs = with python3Packages; [
    # rich
    # pythonRelaxDepsHook
    setuptools
    python3Packages.cmake
    pkg-config
  ];
  # dontUseCmakeConfigure = true;

  propagatedBuildInputs = with python3Packages; [
    # hatchling
    # cppyy
    # python3Packages.rich
    cling.unwrapped
  ];

  buildInputs = [
    # ogdf
    # python3Packages.cppyy
    cling.unwrapped
  ];
  #cmakeFlags = [ 
  #  "-DCMAKE_PREFIX_PATH=${cling.unwrapped}/lib/cmake/cling"
  #];

  preConfigure = ''
    cd src
  '';

  postConfigure = ''
    cd ..
  '';

  #preBuild = ''
  #  sh ./src/build/unix/compiledata.sh
  #'';
  #buildPhase = ''
  #  python setup.py egg_info
  #  python create_src_directory.py
  #  python setup.py sdist
  #'';

  makeWrapperArgs = [
    # "--suffix PATH : ${lib.makeBinPath [ ffmpeg ]}"
  ];

  doCheck = true;
  pythonImportsCheck = [ "cppyy_cling" ];

  # pythonRelaxDeps = [ "rich" ];

  meta = with lib; {
    homepage = "https://github.com/wlav/cppyy-backend/tree/master/cling";
    description = "Automatic, dynamic Python-C++ bindings (backend)";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fliegendewurst ];
  };
}
