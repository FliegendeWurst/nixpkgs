{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  cmake,
  pyqt6,
  numpy,
  numpy-stl,
  scipy,
  shapely,
  cryptography,
  doxygen,
  gettext,
  colorlog,
  pyclipper,
}:

buildPythonPackage rec {
  version = "5.9.0";
  pname = "uranium";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "Uranium";
    rev = version;
    hash = "sha256-sjrDR7f5TETy5jkX8O3NQOGUqEAlQX43rFdfWUlwkZY=";
  };

  buildInputs = [
    python
    gettext
  ];
  dependencies = [
    pyqt6
    numpy
    numpy-stl
    scipy
    shapely
    cryptography
    colorlog
    pyclipper
  ];
  nativeBuildInputs = [
    cmake
    doxygen
  ];
  dontUseCmakeConfigure = true;

  postPatch = ''
    sed -i 's,/python''${PYTHON_VERSION_MAJOR}/dist-packages,/python''${PYTHON_VERSION_MAJOR}.''${PYTHON_VERSION_MINOR}/site-packages,g' CMakeLists.txt
    sed -i \
     -e "s,Resources.addSearchPath(os.path.join(os.path.abspath(os.path.dirname(__file__)).*,Resources.addSearchPath(\"$out/share/uranium/resources\")," \
     -e "s,self._plugin_registry.addPluginLocation(os.path.join(os.path.abspath(os.path.dirname(__file__)).*,self._plugin_registry.addPluginLocation(\"$out/lib/uranium/plugins\")," \
     UM/Application.py
  '';

  meta = with lib; {
    description = "Python framework for building Desktop applications";
    homepage = "https://github.com/Ultimaker/Uranium";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      abbradar
      gebner
    ];
  };
}
