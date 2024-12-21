{
  k3sVersion = "1.31.3+k3s1";
  k3sCommit = "6e6af9885f20413c28da7ba15feac3774375e822";
  k3sRepoSha256 = "1jd71s0c23dqynsjw52hq4qzq3wprkv6wjsfjbyq9rnhmiv9qpn2";
  k3sVendorHash = "sha256-LG/tB6RF6Cp7Txyr9k2BsnNWPCGmaDCDB1x1aoVpOv4=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.6.0-k3s1";
  k3sCNISha256 = "0g7zczvwba5xqawk37b0v96xysdwanyf1grxn3l3lhxsgjjsmkd7";
  containerdVersion = "1.7.23-k3s2";
  containerdSha256 = "0lp9vxq7xj74wa7hbivvl5hwg2wzqgsxav22wa0p1l7lc1dqw8dm";
  criCtlVersion = "1.31.0-k3s2";
}
