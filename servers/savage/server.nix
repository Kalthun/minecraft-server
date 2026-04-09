{ pkgs, inputs, ... }:
with pkgs;
{

  enable = true;
  package = fabricServers.fabric-1_21_11; # [🔄]
  jvmOpts = "-Xms16G -Xmx16G"; # [🪧]

  whitelist = { # [🪧]
    kalthun         = "97b72e9d-efc0-449c-94cd-5405f62c1be6";
    hiuule          = "8d1e1c8c-d7c0-49ad-a2e2-50cb8f3e9cf2";
    LunarAlloy      = "9307d0b2-89d9-45df-bcce-494a9154755d";
    eggplantgrunt   = "926c1118-702a-4b0c-bad1-6bfb6c75bcc4";
    lordvaderkush11 = "68dbf8e6-b6be-4986-9919-42c9f857490f";
  };

  serverProperties = {

    # Server
    server-port = 25565; # [🚨] Must be unique for each server
    motd = "Savage Survival 3.0";
    level-seed = "4241307255164905481"; # [ℹ️] Set seed declaritively
    level-name = "world";
    difficulty = "hard";
    gamemode = "survival";
    max-players = 8;
    white-list = true;
    pause-when-empty-seconds = -1;
    simulation-distance = 10;
    view-distance = 10;

    # Mcrcon
    enable-rcon = true;
    broadcast-rcon-to-ops = true;
    "rcon.port" = 25575; # [🚨] Must be unique for each server
    "rcon.password" = "password";

    # Resourcepack
    resource-pack = "https://github.com/Kalthun/minecraft-server/releases/download/ss-rp/ss-rp-1_21_11-v4.zip";
    resource-pack-sha1 = "a556dd0928cb910be41d3cffb039a338d8d2bdd4";
    resource-pack-prompt = "{\"text\":\"See things my way.\"}";
    require-resource-pack = false;
  };

  symlinks = {

    # Server mods # [🔄]
    "mods" = linkFarmFromDrvs "mods" (builtins.attrValues {
      Almanac         = fetchurl { url = "https://cdn.modrinth.com/data/Gi02250Z/versions/Tcl38ycb/Almanac-1.21.11-x-fabric-1.6.2.jar";                    sha256 = "sha256-YOXvEKmZf1KAt5d2i7E2H7Hg2AWMvdgFxWNeQFa89/s="; };
      AppleSkin       = fetchurl { url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/59ti1rvg/appleskin-fabric-mc1.21.11-3.0.8.jar";                  sha256 = "sha256-BP6De+jxC7XmuZkjhZRGbFm9tkGlRRLxnx5nJB2IKuM="; };
      C2ME            = fetchurl { url = "https://cdn.modrinth.com/data/VSNURh3q/versions/olrVZpJd/c2me-fabric-mc1.21.11-0.3.6.0.0.jar";                   sha256 = "sha256-DwWNNWBfzM3xl+WpB3QDSubs3yc/NMMV3c1I9QYx3f8="; };
      Carpet          = fetchurl { url = "https://cdn.modrinth.com/data/TQTTVgYE/versions/HzPcczDK/fabric-carpet-1.21.11-1.4.194%2Bv251223.jar";           sha256 = "sha256-G01m8DMr2l3u4IdV5JPC1qxk1k1SheETSqA2BJdcJSE="; };
      Chunky          = fetchurl { url = "https://cdn.modrinth.com/data/fALzjamp/versions/1CpEkmcD/Chunky-Fabric-1.4.55.jar";                              sha256 = "sha256-M8vZvODjNmhRxLWYYQQzNOt8GJIkjx7xFAO77bR2vRU="; };
      ClothConfigAPI  = fetchurl { url = "https://cdn.modrinth.com/data/9s6osm5g/versions/xuX40TN5/cloth-config-21.11.153-fabric.jar";                     sha256 = "sha256-ikDITl7N5SWs+2xOE7gALaz8o++VNNf69ugEllb0I8g="; };
      Clumps          = fetchurl { url = "https://cdn.modrinth.com/data/Wnxd13zP/versions/OgBE8Rz4/Clumps-fabric-1.21.11-29.0.0.1.jar";                    sha256 = "sha256-4yESCFKYF+XvzQ4u6W+cjFFui7reWihs1rii9OcPYWM="; };
      DistantHorizons = fetchurl { url = "https://cdn.modrinth.com/data/uCdwusMi/versions/GT3Bm3GN/DistantHorizons-2.4.5-b-1.21.11-fabric-neoforge.jar";   sha256 = "sha256-dpTHoX5V9b7yG0VsIqKxxOSAYLN0Z97itx1MEuWGvD8="; };
      FabricAPI       = fetchurl { url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/i5tSkVBH/fabric-api-0.141.3%2B1.21.11.jar";                      sha256 = "sha256-hsRTqGE5Zi53VpfQOwynhn9Uc3SGjAyz49wG+Y2/7vU="; };
      FastNoise       = fetchurl { url = "https://cdn.modrinth.com/data/OnlVIpq5/versions/fP2AezPw/zfastnoise-1.0.25%2B1.21.11.jar";                       sha256 = "sha256-eYkfD/ohen/P0+F8lRMKoh9v9RiXfmG6zuSRbaOC0+Q="; };
      FerriteCore     = fetchurl { url = "https://cdn.modrinth.com/data/uXXizFIs/versions/Ii0gP3D8/ferritecore-8.2.0-fabric.jar";                          sha256 = "sha256-92vXYMv0goDMfEMYD1CJpGI1+iTZNKis89oEpmTCxxU="; };
      InventoryManage = fetchurl { url = "https://cdn.modrinth.com/data/F7wXag4i/versions/j6rPwIOk/inventorymanagement-1.6.1%2B1.21.11.jar";               sha256 = "sha256-q1viTTMxCW50aRmGyu8oKvDyt8qB8a1RASaagQOeDC8="; };
      JustEnoughItems = fetchurl { url = "https://cdn.modrinth.com/data/u6dRKJwZ/versions/DNqt9cK5/jei-1.21.11-fabric-27.4.0.17.jar";                      sha256 = "sha256-F7+JsqOhkiKLKQrntaX6R4BiLpeydRef+pMB5/XAGiQ="; };
      Krypton         = fetchurl { url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/O9LmWYR7/krypton-0.2.10.jar";                                    sha256 = "sha256-lCkdVpCgztf+fafzgP29y+A82sitQiegN4Zrp0Ve/4s="; };
      LetMeDespawn    = fetchurl { url = "https://cdn.modrinth.com/data/vE2FN5qn/versions/7gmpSYHk/LetMeDespawn-1.21.11-x-fabric-1.6.2.jar";               sha256 = "sha256-UKfHwvvBZW5EiBhq2npiVpJ/x0rEiavaxWZ/Z9/BhtM="; };
      Lithium         = fetchurl { url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/Ow7wA0kG/lithium-fabric-0.21.4%2Bmc1.21.11.jar";                 sha256 = "sha256-UTXEHaW0PL3LKUJL3mUZUUOsQITiODTI6sBllCIBx4s="; };
      QuickPack       = fetchurl { url = "https://cdn.modrinth.com/data/pSISfJ4O/versions/GKLuxqjp/quick-pack-fabric-1.2.0%2B1.21.10.jar";                 sha256 = "sha256-UQrbmKRZld8fqmjIShrEpkLmKesP+0i4yGsHVa2Du7s="; };
      ResourcefulConf = fetchurl { url = "https://cdn.modrinth.com/data/M1953qlQ/versions/8bR7M6K7/ResourcefulConfig-fabric-1.21.11-3.11.3.jar";           sha256 = "sha256-gIaWEhWOueF1NGyji9dodeaex73g9BHx2tlZGoxYJpU="; };
      ScalableLux     = fetchurl { url = "https://cdn.modrinth.com/data/Ps1zyz6x/versions/PV9KcrYQ/ScalableLux-0.1.6%2Bfabric.c25518a-all.jar";            sha256 = "sha256-ekpzcThhg8dVUjtWtVolHXWsLCP0Cvik8PijNbBdT8I="; };
      ServerCore      = fetchurl { url = "https://cdn.modrinth.com/data/4WWQxlQP/versions/zg8VIycZ/servercore-fabric-1.5.15%2B1.21.11.jar";                sha256 = "sha256-78ehY/DFOdA8XsQsCS+b5WoP6GZrhxpjCCUC73kzBRA="; };
      Servux          = fetchurl { url = "https://cdn.modrinth.com/data/zQhsx8KF/versions/wdbe92T5/servux-fabric-1.21.11-0.9.2.jar";                       sha256 = "sha256-UoxQj5VeDOemObqBJbI9DhBUcMBD05k8PfOU9xcTDOM="; };
      SimpleVoiceChat = fetchurl { url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/pFTZ8sqQ/voicechat-fabric-1.21.11-2.6.12.jar";                   sha256 = "sha256-HwedHcqW2UhPdxPNROKWUcwIxAp0kj0gSdB7/dX3bcA="; };
      Spark           = fetchurl { url = "https://cdn.modrinth.com/data/l6YH9Als/versions/gonLOAU1/spark-1.10.170-fabric.jar";                             sha256 = "sha256-U2UqZoLWmxqJJO6a6OYZJVUWOatUC9U/mBSxEpQ15+U="; };
      StructLayOpti   = fetchurl { url = "https://cdn.modrinth.com/data/ayPU0OHc/versions/YDgvKeWI/structure_layout_optimizer-1.1.4%2B1.21.11-fabric.jar"; sha256 = "sha256-b72REzpa/xTawgCNie3HzQdwyza1nk5x3UdN13PK560="; };
    });

    # Server datapacks # [🔄]
    "world/datapacks" = linkFarm "datapacks" [
      { name = "afk-display.zip";                     path = ./datapacks/afk-display.zip; }
      { name = "anti-enderman-grief.zip";             path = ./datapacks/anti-enderman-grief.zip; }
      { name = "coordinates-hud.zip";                 path = ./datapacks/coordinates-hud.zip; }
      { name = "durability-ping.zip";                 path = ./datapacks/durability-ping.zip; }
      { name = "kill-empty-boats.zip";                path = ./datapacks/kill-empty-boats.zip; }
      { name = "multiplayer-sleep.zip";               path = ./datapacks/multiplayer-sleep.zip; }
      { name = "name-colors.zip";                     path = ./datapacks/name-colors.zip; }
      { name = "player-head-drops.zip";               path = ./datapacks/player-head-drops.zip; }
      { name = "real-time-clock.zip";                 path = ./datapacks/real-time-clock.zip; }
      { name = "silence-mobs.zip";                    path = ./datapacks/silence-mobs.zip; }
      { name = "silk-touch-budding-amethyst";         path = ./datapacks/silk-touch-budding-amethyst.zip; }
      { name = "timber.zip";                          path = ./datapacks/timber.zip; }
      { name = "unlock-all-recipes.zip";              path = ./datapacks/unlock-all-recipes.zip; }
      { name = "villager-workstation-highlights.zip"; path = ./datapacks/villager-workstation-highlights.zip; }
      { name = "wandering-trader-announcements.zip";  path = ./datapacks/wandering-trader-announcements.zip; }
      # { name = "wood-stripper.zip";                          path = /.datapacks/} # not in 1.21.11
    ];

  };

}
