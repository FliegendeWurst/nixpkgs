{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  lua,
  makeWrapper,
  perl,
  python3,
  unstableGitUpdater,
  testers,
  cuberite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cuberite";
  version = "0-unstable-2024-09-08";

  src = fetchFromGitHub {
    owner = "cuberite";
    repo = "cuberite";
    rev = "0325de7dacaf1e2feaea5eaab4791bc23d78f9e7";
    fetchSubmodules = true; # TODO: Switch to nixpkgs-packaged dependencies
    hash = "sha256-Gz7WUBcQcUnEs9LD3/Epi9RBZrERCVgLtIlDH1tiK4E=";
  };

  patches = [
    ./add-version-info.patch
  ];

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    makeWrapper
    cmake
    lua # Used to check lua properties: https://github.com/cuberite/cuberite/blob/0325de7dacaf1e2feaea5eaab4791bc23d78f9e7/CheckLua.cmake
    perl
    python3
  ];

  cmakeFlags = [
    (lib.cmakeFeature "OVERRIDE_VERSION" "${finalAttrs.src.rev}-nixpkgs")
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "RELEASE") # Recommended by upstream
    (lib.cmakeBool "BUILD_TOOLS" true) # Build additional executables
    (lib.cmakeBool "SELF_TEST" true) # Enable tests
    (lib.cmakeBool "NO_NATIVE_OPTIMIZATION" (finalAttrs.NIX_ENFORCE_NO_NATIVE or true)) # Causes non-deterministic builds; NIX_ENFORCE_NO_NATIVE supports impureUseNativeOptimizations
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/bin/test $out/include

    # Copy Cuberite main program
    cp Server/Cuberite $out/bin/Cuberite

    # Copy all executables to bin or bin/test depending on the name, and drop any '-exe' suffixes
    for executable in bin/*; do
      if [[ $executable == *Test ]]; then
        cp $executable $out/bin/test
      else
        cp $executable $out/bin/$(basename $executable -exe)
      fi
    done

    # Wrap main executable to add lua interpreter to PATH
    wrapProgram $out/bin/Cuberite --prefix PATH : ${lua}/bin

    # Add lowercase symlink for Cuberite
    ln -s Cuberite $out/bin/cuberite

    cp -r include/. $out/include

    runHook postInstall
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
    tests = {
      version = testers.testVersion {
        package = cuberite;
        version = "${finalAttrs.src.rev}-nixpkgs";
      };
      basicGenerator = testers.runCommand {
        name = "runCommand-basicGenerator-test";
        script = "${cuberite}/bin/test/BasicGeneratorTest";
      };
      blockState = testers.runCommand {
        name = "runCommand-blockState-test";
        script = "${cuberite}/bin/test/BlockStateTest";
      };
      # TODO: Test fails for some reason. Investigate.
      # blockTypePalette = testers.runCommand {
      #   name = "runCommand-blockTypePalette-test";
      #   script = "${cuberite}/bin/test/BlockTypePaletteTest";
      # };
      blockTypeRegistry = testers.runCommand {
        name = "runCommand-blockTypeRegistry-test";
        script = "${cuberite}/bin/test/BlockTypeRegistryTest";
      };
      noiseSpeed = testers.runCommand {
        name = "runCommand-noiseSpeed-test";
        script = "${cuberite}/bin/test/NoiseSpeedTest";
      };
      palettedBlockArea = testers.runCommand {
        name = "runCommand-palettedBlockArea-test";
        script = "${cuberite}/bin/test/PalettedBlockAreaTest";
      };
      uuid = testers.runCommand {
        name = "runCommand-uuid-test";
        script = "${cuberite}/bin/test/UUIDTest";
      };
    };
  };

  meta = {
    description = "Lightweight, fast and extensible Minecraft server written in C++";
    homepage = "https://cuberite.org/";
    mainProgram = "cuberite";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
