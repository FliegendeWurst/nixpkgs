{
  stdenv,
  lib,
  fetchzip,
  kmod,
  kernel,
}:

let
  modDestDir = "$(out)/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/ethernet/motorcomm";

in
stdenv.mkDerivation rec {
  pname = "yt6801";

  version = "1.0.29";
  src = fetchzip {
    stripRoot = false;
    url = "https://www.motor-comm.com/Public/Uploads/uploadfile/files/20240812/yt6801-linux-driver-${version}.zip";
    sha256 = "sha256-oz6CeOUN6QWKXxe3WUZljhGDTFArsknjzBuQ4IchGeU=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ kmod ];

  postPatch = ''
    substituteInPlace src/Makefile \
      --replace-fail "sudo ls -l" "ls -l" \
      --replace-fail 'depmod $(shell uname -r)' "" \
      --replace-fail 'modprobe $(KFILE)' ""
  '';

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KSRC_BASE="
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "KDST=kernel/drivers/net/ethernet/motorcomm"
    "INSTALL_MOD_PATH=$(out)"
    "ko_dir=${modDestDir}"
    "ko_full=${modDestDir}/yt6801.ko.xz"
  ];

  meta = {
    homepage = "https://www.motor-comm.com/product/ethernet-control-chip";
    description = "YT6801 Gigabit PCIe Ethernet controller chip";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ indexyz ];
    platforms = lib.platforms.linux;
  };
}
