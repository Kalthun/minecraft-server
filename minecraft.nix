{ pkgs, inputs, ... }:
with pkgs;
let
  nix-minecraft = inputs.nix-minecraft;
  rconPassword = "password";
in
{
  nixpkgs.overlays = [ nix-minecraft.overlay ];

  # Server
  services.minecraft-servers = {

    enable = true;
    eula = true;

    servers.savage = {

      enable = true;
      package = fabricServers.fabric-1_21_11; # [] VERSION
      jvmOpts = "-Xms2G -Xmx4G -XX:+UseG1GC";

      whitelist = {
        kalthun = "97b72e9d-efc0-449c-94cd-5405f62c1be6";
      };

      serverProperties = {
        server-port = 25565;
        difficulty = "hard";
        gamemode = "survival";
        max-players = 8;
        motd = "Savage Survival SMP";
        enable-rcon = true;
        "rcon.port" = 25575;
        "rcon.password" = rconPassword;
        broadcast-rcon-to-ops = true;
        white-list = true;
      };

      symlinks = {

	      "mods" = linkFarmFromDrvs "mods" (builtins.attrValues {

          FabricAPI = fetchurl {
            url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/i5tSkVBH/fabric-api-0.141.3%2B1.21.11.jar";
            sha256 = "sha256-hsRTqGE5Zi53VpfQOwynhn9Uc3SGjAyz49wG+Y2/7vU=";
          };

        });

        "world/datapacks" = linkFarmFromDrvs "datapacks" [
          ./datapacks/afk-display.zip
          ./datapacks/anti-enderman-grief.zip
          ./datapacks/coordinates-hud.zip
          ./datapacks/durability-ping.zip
          ./datapacks/multiplayer-sleep.zip
          ./datapacks/name-colors.zip
          ./datapacks/nether-portal-coords.zip
          ./datapacks/player-head-drops.zip
          ./datapacks/real-time-clock.zip
          ./datapacks/silence-mobs.zip
          ./datapacks/spawning-spheres.zip
          ./datapacks/unlock-all-recipes.zip
          ./datapacks/villager-workstation-highlights.zip
          ./datapacks/wandering-trader-announcements.zip
        ];

      };

    };
  };

  # TUI
  environment.systemPackages = [
    zellij
    mcrcon

    (writeShellScriptBin "mc-cmd" ''
      exec ${mcrcon}/bin/mcrcon -H 127.0.0.1 -P 25575 -p ${rconPassword} "$@"
    '')

    (writeShellScriptBin "mc-hash" ''
      nix hash convert --hash-algo sha256 --to sri $(nix-prefetch-url "$1")
    '')

  ];

  # Tailscale
  services.tailscale.enable = true;

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false; # change later
      PermitRootLogin = "no";
    };
  };

  # Firewall
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [ 25565 ];
    allowedUDPPorts = [ 25565 ];
  };

}
