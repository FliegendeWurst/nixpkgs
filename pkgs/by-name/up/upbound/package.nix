{
  callPackage,
  version-channel ? "stable",
}:
callPackage ./package-common.nix { inherit version-channel; }
