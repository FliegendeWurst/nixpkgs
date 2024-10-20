{ fetchurl, stdenv, lib
, enableStatic ? stdenv.hostPlatform.isStatic
, enableShared ? !stdenv.hostPlatform.isStatic
}:

# assert !stdenv.hostPlatform.isLinux || stdenv.hostPlatform != stdenv.buildPlatform; # TODO: improve on cross

stdenv.mkDerivation rec {
  pname = "libiconv";
  version = "1.16";

  src = fetchurl {
    url = "mirror://gnu/libiconv/${pname}-${version}.tar.gz";
    sha256 = "016c57srqr0bza5fxjxfrx6aqxkqy0s3gkhcg7p7fhk5i6sv38g6";
  };

  enableParallelBuilding = true;

  setupHooks = [
    ../../../build-support/setup-hooks/role.bash
    ./setup-hook.sh
  ];

  postPatch =
    lib.optionalString ((stdenv.hostPlatform != stdenv.buildPlatform && stdenv.hostPlatform.isMinGW) || stdenv.cc.nativeLibc)
      ''
        sed '/^_GL_WARN_ON_USE (gets/d' -i srclib/stdio.in.h
      ''
    + lib.optionalString (!enableShared) ''
      sed -i -e '/preload/d' Makefile.in
    '';

  configureFlags = [
    (lib.enableFeature enableStatic "static")
    (lib.enableFeature enableShared "shared")
  ] ++ lib.optional stdenv.isFreeBSD "--with-pic";

  meta = {
    description = "An iconv(3) implementation";

    longDescription = ''
      Some programs, like mailers and web browsers, must be able to convert
      between a given text encoding and the user's encoding.  Other programs
      internally store strings in Unicode, to facilitate internal processing,
      and need to convert between internal string representation (Unicode)
      and external string representation (a traditional encoding) when they
      are doing I/O.  GNU libiconv is a conversion library for both kinds of
      applications.
    '';

    homepage = "https://www.gnu.org/software/libiconv/";
    license = lib.licenses.lgpl2Plus;

    maintainers = [ ];
    mainProgram = "iconv";

    # This library is not needed on GNU platforms.
    hydraPlatforms = with lib.platforms; cygwin ++ darwin ++ freebsd;
  };
}
