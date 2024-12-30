{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.crproxy;

  allowImageListFile = pkgs.writeTextFile {
    name = "crproxy-allow-image-list";
    text = lib.strings.concatLines cfg.allowImageList;
  };
  useAllowImageList = (lib.length cfg.allowImageList) != 0;
  blockIPListFile = pkgs.writeTextFile {
    name = "crproxy-block-ip-list";
    text = lib.strings.concatLines cfg.blockIPList;
  };
  useBlockIPList = (lib.length cfg.blockIPList) != 0;
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    concatStringsSep
    concatLists
    optionals
    literalExpression
    mkPackageOption
    ;
in
{
  options.services.crproxy = {
    enable = mkEnableOption "CRProxy, a generic Docker image proxy";

    package = mkPackageOption pkgs "crproxy" { };

    listenAddress = mkOption {
      default = ":8080";
      example = literalExpression ''
        ":8080"
      '';
      type = types.str;
      description = "Address and port to listen on.";
    };

    behindProxy = mkOption {
      default = false;
      example = literalExpression ''
        true
      '';
      type = types.bool;
      description = "Behind the reverse proxy, such as nginx";
    };

    userpass = mkOption {
      default = [ ];
      example = literalExpression ''
        [ "user1:password@docker.io" "user2:password@ghcr.io" ]
      '';
      type = types.listOf types.str;
      description = "host and username and password -u user:pwd@host";
    };

    allowHostList = mkOption {
      default = [ ];
      example = literalExpression ''
        [ "192.168.233.233" "10.233.233.233" "1.1.1.1" ]
      '';
      type = types.listOf types.str;
      description = "allow host list, specifiy which host(s) can access.";
    };

    allowImageList = mkOption {
      default = [ ];
      example = literalExpression ''
        [
          "busybox"
          "hello-world"
        ]
      '';
      type = types.listOf types.str;
      description = "allow image list";
    };

    blockMessage = mkOption {
      type = types.str;
      default = "This image is not allowed for my proxy!";
      example = literalExpression ''
        "Not allowed"
      '';
      description = "block message";
    };

    blockIPList = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "block ip list";
    };

    defaultRegistry = mkOption {
      type = types.str;
      default = "docker.io";
      example = literalExpression ''
        "docker.io"
      '';
      description = "default registry used for non full-path docker pull, like:docker.io";
    };

    simpleAuth = mkOption {
      type = types.bool;
      default = false;
      description = "enable simple auth";
    };

    simpleAuthUser = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "simple auth user and password (default [])";
    };

    privilegedIPList = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = "privileged IP list";
    };

    extraOptions = mkOption {
      default = [ ];
      type = types.listOf types.str;
      example = literalExpression ''
        [
          "--retry=3"
          "--limit-delay"
        ]
      '';
      description = ''
        see https://github.com/DaoCloud/crproxy/blob/master/cmd/crproxy/main.go for more.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.crproxy = {
      wantedBy = [ "network-online.target" ];
      serviceConfig = {
        RestartSec = 5;
        ExecStart = concatStringsSep " " concatLists [
          [
            "${cfg.package}/bin/crproxy"
            "--default-registry=${cfg.defaultRegistry}"
            "--address=${cfg.listenAddress}"
          ]
          (optionals cfg.behindProxy [ "--behind" ])
          (optionals useAllowImageList [ "--allow-image-list-from-file=${allowImageListFile}" ])
          (optionals useAllowImageList [ "--block-message=${cfg.blockMessage}" ])
          (optionals useBlockIPList [ "--block-ip-list-from-file=${blockIPListFile}" ])
          (optionals cfg.simpleAuth [ "--simple-auth" ])
          (map (e: "--simple-auth-user=${e}") cfg.simpleAuthUser)
          (map (e: "--allow-host-list=${e}") cfg.allowHostList)
          (map (e: "--privileged-ip-list=${e}") cfg.privilegedIPList)
          (map (e: "--user=${e}") cfg.userpass)

          cfg.extraOptions
        ];
      };
    };
  };
}
