{ callPackage, ... } @ args:

callPackage ./. (args // {
  version = "3.4.3";
  hash = "sha256-tBEkQUoACkVMSKaocTrayiNxv0EFeR9JUiSAY1bs0HQ=";
})
