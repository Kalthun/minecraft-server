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
          afk-display                     = ../../datapacks/afk_display.zip;
          anti-enderman-grief             = ../../datapacks/anti_enderman_grief.zip;
          coordinates-hud                 = ../../datapacks/coordinates_hud.zip;
          durability-ping                 = ../../datapacks/durability_ping.zip;
          multiplayer-sleep               = ../../datapacks/multiplayer_sleep.zip;
          name-colors                     = ../../datapacks/name_colors.zip;
          nether-portal-coords            = ../../datapacks/nether_portal_coords.zip;
          player-head-drops               = ../../datapacks/player_head_drops.zip;
          real-time-clock                 = ../../datapacks/real_time_clock.zip;
          silence-mobs                    = ../../datapacks/silence_mobs.zip;
          spawning-spheres                = ../../datapacks/spawning_spheres.zip;
          unlock-all-recipes              = ../../datapacks/unlock_all_recipes.zip;
          villager-workstation-highlights = ../../datapacks/villager_workstation_highlights.zip;
          wandering-trader-announcements  = ../../datapacks/wandering_trader_announcements.zip;
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
