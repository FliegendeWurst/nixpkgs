{ lib, stdenvNoCC
, fetchurl
, jre
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, testers
, key
}:

stdenvNoCC.mkDerivation rec {
  pname = "key";
  version = "2.12.1";

  src = fetchurl {
  	url = "https://github.com/KeYProject/key/releases/download/KEY-${version}/key-${version}-exe.jar";
    sha256 = "1cawmfbf8ivkxzrv36z215lqdljj9kicjjvzymfir4300hfc4bl6";
  };
  icon = fetchurl {
    url = "https://raw.githubusercontent.com/KeYProject/key/9d102b50e56ca61ec728ff90170ae4380cd6cc82/key.ui/src/main/resources/de/uka/ilkd/key/gui/images/key-color-icon-square.png";
    hash = "sha256-bYyVnUiKkcN2FsIFwowjJrKT9bRX3SHeJXMOzQR2qhM=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  executable-name = "KeY";

  desktopItems = [
    (makeDesktopItem {
      name = "KeY";
      exec = executable-name;
      icon = "key";
      comment = meta.description;
      desktopName = "KeY";
      genericName = "KeY";
      categories = [ "Science" ];
    })
  ];

  dontUnpack = true;

  installPhase = ''
  	runHook preInstall

    mkdir -p $out/bin $out/share/java $out/share/icons/hicolor/256x256/apps

    cp ${src} "$out/share/java/key.jar"
    cp ${icon} $out/share/icons/hicolor/256x256/apps/key.png

    makeWrapper ${jre}/bin/java $out/bin/KeY \
      --add-flags "-jar $out/share/java/key.jar"

	  runHook postInstall
  '';

  passthru.tests.version =
    testers.testVersion {
      package = key;
      command = "KeY --help";
    };

  meta = with lib; {
    description = "Java formal verification tool";
    homepage = "https://www.key-project.org"; # also https://formal.iti.kit.edu/key/
    longDescription = ''
      The KeY System is a formal software development tool that aims to
      integrate design, implementation, formal specification, and formal
      verification of object-oriented software as seamlessly as possible.
      At the core of the system is a novel theorem prover for the first-order
      Dynamic Logic for Java with a user-friendly graphical interface.
    '';
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fliegendewurst ];
    mainProgram = executable-name;
    platforms = platforms.all;
	  broken = lib.versionOlder jre.version "11";
  };
}
