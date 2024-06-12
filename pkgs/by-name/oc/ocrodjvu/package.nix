{
  lib,
  python3Packages,
  fetchFromGitHub,
  djvulibre,
  docbook-xsl-ns,
  glibcLocales,
  libxml2,
  libxml2Python,
  libxslt,
  pkg-config,
  tesseract5,
  withCuneiform ? false,
  cuneiform,
  withGocr ? false,
  gocr,
  withOcrad ? false,
  ocrad,
}:

python3Packages.buildPythonApplication rec {
  pname = "ocrodjvu";
  version = "0.13.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FriedrichFroebel";
    repo = "ocrodjvu";
    rev = version;
    hash = "sha256-EiMCrRFUAJbu9QLgKpFIKqigCZ77lpTDD6AvZuMbyhA=";
  };

  build-system =
    with python3Packages;
    [
      cython
      djvulibre
      docbook-xsl-ns
      glibcLocales
      html5lib
      libxml2
      libxml2Python
      libxslt
      packaging
      pillow
      pkg-config
      pyicu
      setuptools
      tesseract5
      wheel
    ]
    ++ lib.optional withCuneiform cuneiform
    ++ lib.optional withGocr gocr
    ++ lib.optional withOcrad ocrad;

  dependencies = with python3Packages; [
    lxml
    python-djvulibre
  ];

  nativeCheckInputs = [ python3Packages.unittestCheckHook ];

  unittestFlagsArray = [
    "tests"
    "-v"
  ];

  meta = with lib; {
    description = "Wrapper for OCR systems that allows you to perform OCR on DjVu files";
    homepage = "https://github.com/FriedrichFroebel/ocrodjvu";
    changelog = "https://github.com/FriedrichFroebel/ocrodjvu/blob/${version}/doc/changelog";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dansbandit ];
    mainProgram = "ocrodjvu";
  };
}
