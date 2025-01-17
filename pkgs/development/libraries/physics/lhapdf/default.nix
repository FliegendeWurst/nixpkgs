{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  bash,
  buildPackages,
  python,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "lhapdf";
  version = "6.5.5";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/lhapdf/LHAPDF-${version}.tar.gz";
    sha256 = "sha256-ZB1eoJQreeREfhXlozSR/zxwMtcdYYEZk14UrSf146U=";
  };

  # The Apple SDK only exports locale_t from xlocale.h whereas glibc
  # had decided that xlocale.h should be a part of locale.h
  postPatch =
    ''
      substituteInPlace configure --replace-fail '$PYTHON' "${lib.getExe python.pythonOnBuildForHost}"
      patchShebangs --build wrappers/python/build.py.in
    ''
    + lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.cc.isGNU) ''
      substituteInPlace src/GridPDF.cc --replace '#include <locale>' '#include <xlocale.h>'
    '';

  nativeBuildInputs =
    [
      autoconf
      bash
      makeWrapper
      python
    ]
    ++ lib.optionals (python != null && lib.versionAtLeast python.version "3.10") [
      python.pkgs.cython
    ];
  buildInputs = [ python ];

  configureFlags = [
    "ACLOCAL=${lib.getExe' buildPackages.automake "aclocal"}"
    "AUTOMAKE=${lib.getExe' buildPackages.automake "automake"}"
  ] ++ lib.optionals (python == null) [ "--disable-python" ];

  preBuild = lib.optionalString (python != null && lib.versionAtLeast python.version "3.10") ''
    rm wrappers/python/lhapdf.cpp
  '';

  makeFlags = [
    "PYTHON=${lib.getExe python.pythonOnBuildForHost}"
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  passthru = {
    pdf_sets = import ./pdf_sets.nix { inherit lib stdenv fetchurl; };
  };

  postInstall = ''
    patchShebangs --build $out/bin/lhapdf-config
    wrapProgram $out/bin/lhapdf --prefix PYTHONPATH : "$(toPythonPath "$out")"
  '';

  meta = with lib; {
    description = "General purpose interpolator, used for evaluating Parton Distribution Functions from discretised data files";
    license = licenses.gpl3;
    homepage = "https://www.lhapdf.org";
    platforms = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
