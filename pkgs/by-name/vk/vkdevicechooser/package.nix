{
  lib,
  stdenv,
  fetchFromGitHub,
  writeText,
  meson,
  vulkan-headers,
  vulkan-validation-layers,
  ninja,
  jq,
}:

stdenv.mkDerivation rec {
  pname = "vkdevicechooser";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "aejsmith";
    repo = "vkdevicechooser";
    rev = version;
    hash = "sha256-low5vkuZT4gWta4PeoCaP/jIO1uszACq+LTZopo8BAI=";
  };

  nativeBuildInputs = [
    meson
    jq
  ];

  buildInputs = [
    vulkan-headers
    vulkan-validation-layers
    ninja
  ];

  # Help vulkan-loader find the validation layers
  setupHook = writeText "setup-hook" ''
    addToSearchPath XDG_DATA_DIRS @out@/share
  '';

  mesonFlags = [ "-Dc_args=-I${vulkan-validation-layers}/include" ];

  # Include absolute paths to layer libraries in their associated
  # layer definition json files.
  preFixup = ''
    for f in "$out"/share/vulkan/explicit_layer.d/*.json "$out"/share/vulkan/implicit_layer.d/*.json; do
      jq <"$f" >tmp.json ".layer.library_path = \"$out/lib/\" + .layer.library_path"
      mv tmp.json "$f"
    done
  '';

  meta = {
    description = "Vulkan layer to force a specific device to be used";
    homepage = "https://github.com/aejsmith/vkdevicechooser";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sigmike ];
  };
}
