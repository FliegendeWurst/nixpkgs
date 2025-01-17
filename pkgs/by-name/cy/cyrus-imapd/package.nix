{
  # build tools
  stdenv,
  autoreconfHook,
  makeWrapper,
  pkg-config,
  writeShellScriptBin,

  # check hook
  versionCheckHook,

  # fetchers
  fetchFromGitHub,

  # build inputs
  bash,
  bison,
  brotli,
  coreutils,
  cunit,
  cyrus_sasl,
  fig2dev,
  flex,
  icu,
  jansson,
  lib,
  libbsd,
  libcap,
  libchardet,
  libical,
  libmysqlclient,
  libsrs2,
  libuuid,
  libxcrypt,
  libxml2,
  nghttp2,
  openssl,
  pcre2,
  perl,
  postgresql,
  rsync,
  shapelib,
  sqlite,
  unixtools,
  valgrind,
  wslay,
  xapian,
  xxd,
  zlib,

  # feature flags
  enableAutoCreate ? true,
  enableBackup ? true,
  enableCalalarmd ? true,
  enableHttp ? true,
  enableIdled ? true,
  enableJMAP ? true,
  enableMurder ? true,
  enableNNTP ? false,
  enableReplication ? true,
  enableSrs ? true,
  enableUnitTests ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  enableXapian ? true,
  withLibcap ? true,
  withMySQL ? false,
  withOpenssl ? true,
  withPgSQL ? false,
  withSQLite ? true,
  withZlib ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cyrus-imapd";
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "cyrusimap";
    repo = "cyrus-imapd";
    tag = "cyrus-imapd-${finalAttrs.version}";
    hash = "sha256-dyybRqmrVX+ERGpToS5JjGC6S/B0t967dLCWfeUrLKA=";
  };

  nativeBuildInputs = [
    bison
    flex
    makeWrapper
    perl
    pkg-config
    xxd
    autoreconfHook
    (writeShellScriptBin "cc" "exec ${stdenv.cc.targetPrefix}cc $@")
  ];
  buildInputs =
    [
      bash
      unixtools.xxd
      pcre2
      flex
      valgrind
      fig2dev
      # perl
      cyrus_sasl.dev
      icu
      jansson
      libbsd
      libuuid
      libxcrypt
      openssl
      zlib
      libsrs2
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ libcap ]
    ++ lib.optionals (enableHttp || enableCalalarmd || enableJMAP) [
      brotli.dev
      libical.dev
      libxml2.dev
      nghttp2.dev
      shapelib
    ]
    ++ lib.optionals enableJMAP [
      libchardet
      wslay
    ]
    ++ lib.optionals enableXapian [
      rsync
      xapian
    ]
    ++ lib.optionals withMySQL [ libmysqlclient ]
    ++ lib.optionals withPgSQL [ postgresql ]
    ++ lib.optionals withSQLite [ sqlite ];

  enableParallelBuilding = true;

  postPatch =
    let
      managesieveLibs =
        [
          zlib
          cyrus_sasl
          sqlite
        ]
        # Darwin doesn't have libuuid, try to build without it
        ++ lib.optional (!stdenv.hostPlatform.isDarwin) libuuid;
      imapLibs = managesieveLibs ++ [ pcre2 ];
      mkLibsString = lib.strings.concatMapStringsSep " " (l: "-L${lib.getLib l}/lib");
    in
    ''
      patchShebangs cunit/*.pl
      patchShebangs imap/promdatagen
      patchShebangs tools/*

      echo ${finalAttrs.version} > VERSION

      substituteInPlace cunit/command.testc \
        --replace-fail /usr/bin/touch ${lib.getExe' coreutils "touch"} \
        --replace-fail /bin/echo ${lib.getExe' coreutils "echo"} \
        --replace-fail /usr/bin/tr ${lib.getExe' coreutils "tr"} \
        --replace-fail /bin/sh ${stdenv.shell}

      # fix for https://github.com/cyrusimap/cyrus-imapd/issues/3893
      substituteInPlace perl/imap/Makefile.PL.in \
        --replace-fail  '"$LIB_SASL' '"${mkLibsString imapLibs} -lpcre2-posix $LIB_SASL'
      substituteInPlace perl/sieve/managesieve/Makefile.PL.in \
        --replace-fail  '"$LIB_SASL' '"${mkLibsString managesieveLibs} $LIB_SASL'
    '';

  postFixup = ''
    patchShebangs --host $out/bin/{cyr_cd.sh,installsieve}
    wrapProgram $out/bin/cyradm --set PERL5LIB $(find $out/lib/perl5 -type d | tr "\\n" ":")
    substituteInPlace $out/bin/.cyradm-wrapped --replace-fail "${lib.replaceStrings ["/bin/bash"] ["/bin/sh"] stdenv.shell}" "/bin/sh"
    patchShebangs --host $out/bin/.cyradm-wrapped
  '';

  configureFlags = [
    "--with-pidfile=/run/cyrus/master.pid"
    (lib.enableFeature enableAutoCreate "autocreate")
    (lib.enableFeature enableSrs "srs")
    (lib.enableFeature enableIdled "idled")
    (lib.enableFeature enableMurder "murder")
    (lib.enableFeature enableBackup "backup")
    (lib.enableFeature enableReplication "replication")
    (lib.enableFeature enableUnitTests "unit-tests")
    (lib.enableFeature (enableHttp || enableCalalarmd || enableJMAP) "http")
    (lib.enableFeature enableJMAP "jmap")
    (lib.enableFeature enableNNTP "nntp")
    (lib.enableFeature enableXapian "xapian")
    (lib.enableFeature enableCalalarmd "calalarmd")
    (lib.withFeature withZlib "zlib=${zlib}")
    (lib.withFeature withOpenssl "openssl")
    (lib.withFeature withLibcap "libcap=${libcap}")
    (lib.withFeature withMySQL "mysql")
    (lib.withFeature withPgSQL "pgsql")
    (lib.withFeature withSQLite "sqlite")
  ];

  env = lib.optionalAttrs enableXapian {
    RSYNC_BIN = lib.getExe rsync;
    XAPIAN_CONFIG = lib.getExe' (lib.getDev xapian) "xapian-config";
  };

  checkInputs = [ cunit ];
  doCheck = true;

  versionCheckProgram = "${builtins.placeholder "out"}/libexec/master";
  versionCheckProgramArg = "-V";
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    homepage = "https://www.cyrusimap.org";
    description = "Email, contacts and calendar server";
    changelog = "https://www.cyrusimap.org/imap/download/release-notes/${lib.versions.majorMinor finalAttrs.version}/x/${finalAttrs.version}.html";
    license = with lib.licenses; [ bsdOriginal ];
    mainProgram = "cyradm";
    maintainers = with lib.maintainers; [
      moraxyc
      pingiun
    ];
    platforms = lib.platforms.unix;
  };
})
