{ haskell, haskellPackages }:

let
  generated = haskellPackages.callPackage ./generated.nix { };
in
haskell.lib.compose.justStaticExecutables generated
