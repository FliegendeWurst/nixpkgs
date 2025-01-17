{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gettext,
  libdvdread,
  libxml2,
  freetype,
  fribidi,
  libpng,
  zlib,
  pkg-config,
  flex,
  bison,
  docbook2x,
}:

stdenv.mkDerivation rec {
  pname = "dvdauthor";
  version = "0.7.2-unstable-2021-11-05";

  src = fetchFromGitHub {
    owner = "ldo";
    repo = "dvdauthor";
    rev = "fe8fe3578f95f34889e7ed17591d02dceb4f42ed";
    hash = "sha256-sb6i2pVm2PVMX+SA+n9Lng5jej2fI1HB7SF7HvnKe6Q=";
  };

  postPatch = ''
    for f in doc/*; do
      substituteInPlace $f --replace-quiet \
        '<!doctype book PUBLIC' '<?xml version="1.0" encoding="utf-8"?><!DOCTYPE book PUBLIC'
    done
    rm doc/root.sgml
  '';

  preAutoreconf = ''
    mkdir autotools
    cp ${gettext}/share/gettext/config.rpath autotools/
  '';

  buildInputs = [
    libpng
    freetype
    libdvdread
    libxml2
    zlib
    fribidi
    flex
    bison
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    docbook2x
  ];

  meta = with lib; {
    description = "Tools for generating DVD files to be played on standalone DVD players";
    homepage = "https://dvdauthor.sourceforge.net/"; # or https://github.com/ldo/dvdauthor
    license = licenses.gpl2;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
