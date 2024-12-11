{
  lib,
  buildGoModule,
  fetchFromGitLab,
  unstableGitUpdater,
}:
buildGoModule {
  pname = "webtunnel";
  version = "unstable-2024-07-06"; # package is not versioned upstream
  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "webtunnel";
    rev = "e64b1b3562f3ab50d06141ecd513a21ec74fe8c6";
    hash = "sha256-25ZtoCe1bcN6VrSzMfwzT8xSO3xw2qzE4Me3Gi4GbVs=";
  };

  vendorHash = "sha256-3AAPySLAoMimXUOiy8Ctl+ghG5q+3dWRNGXHpl9nfG0=";
  passthru.updateScript = unstableGitUpdater {
    url = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/webtunnel";
  };

  meta = with lib; {
    description = "Pluggable Transport based on HTTP Upgrade(HTTPT)";
    homepage = "https://community.torproject.org/relay/setup/webtunnel/";
    maintainers = with maintainers; [ gbtb ];
    license = licenses.mit;
    platforms = platforms.linux;
  };

}
