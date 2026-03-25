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

        "world/datapacks" = linkFarmFromDrvs "datapacks" (builtins.attrValues {

          afk-display = builtins.path {
            path = ./datapacks/afk-display.zip;
            name = "afk-display.zip";
          };

          anti-enderman-grief = builtins.path {
            path = ./datapacks/anti-enderman-grief.zip;
            name = "anti-enderman-grief.zip";
          };

          coordinates-hud = builtins.path {
            path = ./datapacks/coordinates-hud.zip;
            name = "coordinates-hud.zip";
          };

          durability-ping = builtins.path {
            path = ./datapacks/durability-ping.zip;
            name = "durability-ping.zip";
          };

          multiplayer-sleep = builtins.path {
            path = ./datapacks/multiplayer-sleep.zip;
            name = "multiplayer-sleep.zip";
          };

          name-colors = builtins.path {
            path = ./datapacks/name-colors.zip;
            name = "name-colors.zip";
          };

          nether-portal-coords = builtins.path {
            path = ./datapacks/nether-portal-coords.zip;
            name = "nether-portal-coords.zip";
          };

          player-head-drops = builtins.path {
            path = ./datapacks/player-head-drops.zip;
            name = "player-head-drops.zip";
          };

          real-time-clock = builtins.path {
            path = ./datapacks/real-time-clock.zip;
            name = "real-time-clock.zip";
          };

          silence-mobs = builtins.path {
            path = ./datapacks/silence-mobs.zip;
            name = "silence-mobs.zip";
          };

          spawning-spheres = builtins.path {
            path = ./datapacks/spawning-spheres.zip;
            name = "spawning-spheres.zip";
          };

          unlock-all-recipes = builtins.path {
            path = ./datapacks/unlock-all-recipes.zip;
            name = "unlock-all-recipes.zip";
          };

          villager-workstation-highlights = builtins.path {
            path = ./datapacks/villager-workstation-highlights.zip;
            name = "villager-workstation-highlights.zip";
          };

          wandering-trader-announcements = builtins.path {
            path = ./datapacks/wandering-trader-announcements.zip;
            name = "wandering-trader-announcements.zip";
          };

        });

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
