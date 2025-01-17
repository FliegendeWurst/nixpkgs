{
  lib,
  stdenv,
  fetchFromGitHub,
  cairo,
  fftw,
  gtkmm2,
  lv2,
  lvtk,
  pkg-config,
  wafHook,
  python311,
}:

stdenv.mkDerivation rec {
  pname = "ams-lv2";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "blablack";
    repo = "ams-lv2";
    rev = version;
    sha256 = "1lz2mvk4gqsyf92yxd3aaldx0d0qi28h4rnnvsaz4ls0ccqm80nk";
  };

  nativeBuildInputs = [
    pkg-config
    wafHook
    python311
  ];
  buildInputs = [
    cairo
    fftw
    gtkmm2
    lv2
    lvtk
  ];

  postPatch = ''
    # U was removed in python 3.11 because it had no effect
    substituteInPlace waflib/*.py \
      --replace-quiet "m='rU" "m='r"
    substituteInPlace wscript \
      --replace-fail "autowaf.check_pkg(conf, 'lvtk-plugin-1', uselib_store='LVTK_PLUGIN', atleast_version='1.2.0')" "" \
      --replace-fail "autowaf.check_pkg(conf, 'lvtk-ui-1', uselib_store='LVTK_UI', atleast_version='1.2.0')" "" \
      --replace-fail "autowaf.check_pkg(conf, 'lvtk-gtkui-1', uselib_store='LVTK_GTKGUI', atleast_version='1.2.0')" ""
  '';

  meta = with lib; {
    description = "LV2 port of the internal modules found in Alsa Modular Synth";
    homepage = "https://github.com/blablack/ams-lv2";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
    # Build uses `-msse` and `-mfpmath=sse`
    badPlatforms = [ "aarch64-linux" ];
  };
}
