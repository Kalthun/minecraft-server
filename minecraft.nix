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
      package = fabricServers.fabric-1_21_11; # [] UPDATE
      jvmOpts = "-Xms2G -Xmx4G -XX:+UseG1GC"; # [] Improve

      whitelist = {
        kalthun = "97b72e9d-efc0-449c-94cd-5405f62c1be6";
        hiuule = "8d1e1c8c-d7c0-49ad-a2e2-50cb8f3e9cf2";
        LunarAlloy = "9307d0b2-89d9-45df-bcce-494a9154755d";
      };

      serverProperties = {
        server-port = 25565;
        level-seed = "4241307255164905481"; # Large Mushroom Island @ 517 70 -224
        difficulty = "hard";
        gamemode = "survival";
        max-players = 8;
        motd = "Savage Survival 3.0";
        enable-rcon = true;
        "rcon.port" = 25575;
        "rcon.password" = rconPassword;
        broadcast-rcon-to-ops = true;
        white-list = true;
      };

      symlinks = {

	      "mods" = linkFarmFromDrvs "mods" (builtins.attrValues {
          FabricAPI       = fetchurl { url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/i5tSkVBH/fabric-api-0.141.3%2B1.21.11.jar";                    sha256 = "sha256-hsRTqGE5Zi53VpfQOwynhn9Uc3SGjAyz49wG+Y2/7vU="; };
          ClothConfigAPI  = fetchurl { url = "https://cdn.modrinth.com/data/9s6osm5g/versions/xuX40TN5/cloth-config-21.11.153-fabric.jar";                   sha256 = "sha256-ikDITl7N5SWs+2xOE7gALaz8o++VNNf69ugEllb0I8g="; };
          Lithium         = fetchurl { url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/Ow7wA0kG/lithium-fabric-0.21.4%2Bmc1.21.11.jar";               sha256 = "sha256-UTXEHaW0PL3LKUJL3mUZUUOsQITiODTI6sBllCIBx4s="; };
          FerriteCore     = fetchurl { url = "https://cdn.modrinth.com/data/uXXizFIs/versions/Ii0gP3D8/ferritecore-8.2.0-fabric.jar";                        sha256 = "sha256-92vXYMv0goDMfEMYD1CJpGI1+iTZNKis89oEpmTCxxU="; };
          C2ME            = fetchurl { url = "https://cdn.modrinth.com/data/VSNURh3q/versions/olrVZpJd/c2me-fabric-mc1.21.11-0.3.6.0.0.jar";                 sha256 = "sha256-DwWNNWBfzM3xl+WpB3QDSubs3yc/NMMV3c1I9QYx3f8="; };
          NoisiumForked   = fetchurl { url = "https://cdn.modrinth.com/data/hasdd01q/versions/VyMvRQKq/noisium-fabric-2.8.3%2Bmc1.21.11.jar";                sha256 = "sha256-CTiufqNWCeWByqr6xtK0K/U9DU25OpFXhPe3tBbMMPg="; };
          Krypton         = fetchurl { url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/O9LmWYR7/krypton-0.2.10.jar";                                  sha256 = "sha256-lCkdVpCgztf+fafzgP29y+A82sitQiegN4Zrp0Ve/4s="; };
          DistantHorizons = fetchurl { url = "https://cdn.modrinth.com/data/uCdwusMi/versions/GT3Bm3GN/DistantHorizons-2.4.5-b-1.21.11-fabric-neoforge.jar"; sha256 = "sha256-dpTHoX5V9b7yG0VsIqKxxOSAYLN0Z97itx1MEuWGvD8="; };
          SimpleVoiceChat = fetchurl { url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/pFTZ8sqQ/voicechat-fabric-1.21.11-2.6.12.jar";                 sha256 = "sha256-HwedHcqW2UhPdxPNROKWUcwIxAp0kj0gSdB7/dX3bcA="; };
        });

        "world/datapacks" = linkFarm "datapacks" [
          { name = "afk-display.zip";                     path = ./datapacks/afk-display.zip; }
          { name = "anti-enderman-grief.zip";             path = ./datapacks/anti-enderman-grief.zip; }
          { name = "coordinates-hud.zip";                 path = ./datapacks/coordinates-hud.zip; }
          { name = "durability-ping.zip";                 path = ./datapacks/durability-ping.zip; }
          { name = "multiplayer-sleep.zip";               path = ./datapacks/multiplayer-sleep.zip; }
          { name = "name-colors.zip";                     path = ./datapacks/name-colors.zip; }
          { name = "nether-portal-coords.zip";            path = ./datapacks/nether-portal-coords.zip; }
          { name = "player-head-drops.zip";               path = ./datapacks/player-head-drops.zip; }
          { name = "real-time-clock.zip";                 path = ./datapacks/real-time-clock.zip; }
          { name = "silence-mobs.zip";                    path = ./datapacks/silence-mobs.zip; }
          { name = "unlock-all-recipes.zip";              path = ./datapacks/unlock-all-recipes.zip; }
          { name = "villager-workstation-highlights.zip"; path = ./datapacks/villager-workstation-highlights.zip; }
          { name = "wandering-trader-announcements.zip";  path = ./datapacks/wandering-trader-announcements.zip; }
        ];

      };

    };
  };

  # TUI
  environment.systemPackages = [
    mcrcon
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
