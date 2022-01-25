{
  mkDerivation, lib, fetchFromGitLab, fetchpatch, extra-cmake-modules, kdoctools,
  boost, qttools, qtwebkit,
  breeze-icons, karchive, kcodecs, kcompletion, kconfig, kconfigwidgets, kcoreaddons,
  kcrash, kguiaddons, ki18n, kiconthemes, kitemviews, kio, ktexteditor, ktextwidgets,
  kwidgetsaddons, kxmlgui,
  kdb, kproperty, kreport, lcms2, libmysqlclient, marble, postgresql
}:

mkDerivation rec {
  pname = "kexi";
  version = "unstable-2021-11-15";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "office";
    repo = "kexi";
    rev = "03a20ecca78cbe6559f533107eca79d08df7b9f1";
    sha256 = "15chzyh7ifw78lii07vv8ff13la5273a2c0dsbxg76va0qfl058l";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

  buildInputs = [
    boost qttools qtwebkit
    breeze-icons karchive kcodecs kcompletion kconfig kconfigwidgets kcoreaddons
    kcrash kguiaddons ki18n kiconthemes kitemviews kio ktexteditor ktextwidgets
    kwidgetsaddons kxmlgui
    kdb kproperty kreport lcms2 libmysqlclient marble postgresql
  ];

  propagatedUserEnvPkgs = [ kproperty ];

  patches = [
    # Changes in Qt 5.13 mean that QDate isn't exported from certain places,
    # which the build was relying on. This patch explicitly imports QDate where
    # needed.
    # Should be unnecessary with kexi >= 3.3
    #(fetchpatch {
    #  url = "https://cgit.kde.org/kexi.git/patch/src/plugins/forms/widgets/kexidbdatepicker.cpp?id=511d99b7745a6ce87a208bdbf69e631f1f136d53";
    #  sha256 = "0m5cwq2v46gb1b12p7acck6dadvn7sw4xf8lkqikj9hvzq3r1dnj";
    #})
    # Use plain Marble package instead of KexiMarble (fixes build issues)
    #./plain-marble.patch
    # Fix build issues with newer gcc versions
    #./template-C-linkage.patch
    #./include.patch
  ];
  
  postPatch = let
    replacements = [
      {
        from = "find_package(KDb \${KEXI_FRAMEWORKS_MIN_VERSION} REQUIRED COMPONENTS \${KDB_REQUIRED_COMPONENTS})";
        to = "find_package(KDb 3.2.0 REQUIRED COMPONENTS \${KDB_REQUIRED_COMPONENTS})";
      }
      {
        from = "find_package(KReport \${KEXI_FRAMEWORKS_MIN_VERSION})";
        to = "find_package(KReport 3.2.0)";
      }
      {
        from = "find_package(KPropertyWidgets \${KEXI_FRAMEWORKS_MIN_VERSION} REQUIRED COMPONENTS KF)";
        to = "find_package(KPropertyWidgets 3.2.0 REQUIRED COMPONENTS KF)";
      }
    ];
  in ''
    substituteInPlace CMakeLists.txt \
       ${lib.concatMapStringsSep " " (r: "--replace '${r.from}' '${r.to}'") replacements}
  '';

  meta = with lib; {
    description = "A open source visual database applications creator, a long-awaited competitor for programs like MS Access or Filemaker";
    longDescription = ''
      Kexi is a visual database applications creator.
      It can be used for creating database schemas,
      inserting data, performing queries, and processing data.
      Forms can be created to provide a custom interface to your data.
      All database objects - tables, queries and forms - are stored in the database,
      making it easy to share data and design.
    '';
    homepage = "http://kexi-project.org/";
    maintainers = with maintainers; [ zraexy ];
    platforms = platforms.linux;
    license = with licenses; [ gpl2 lgpl2 ];
  };
}
