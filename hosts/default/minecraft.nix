{ pkgs, inputs, ... }: {

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers = {
      savage = import ../../servers/savage/server.nix { inherit pkgs inputs; };
      # test = import ../../servers/test/server.nix { inherit pkgs inputs; };
    };
  };

  systemd.services.minecraft-backup-savage = {
    description = "Backup Minecraft Server: savage";

    serviceConfig = {
      Type = "oneshot";
      User = "minecraft";
      ExecStart = "${pkgs.bash}/bin/bash ${../../scripts/backup.sh} savage 25575 password";
    };

    path = with pkgs; [
      coreutils
      findutils
      gnutar
      gzip
      mcrcon
    ];
  };

  systemd.timers.minecraft-backup-savage = {
    description = "Run backups for savage every 6 hours";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      Unit = "minecraft-backup-savage.service";
      OnCalendar = [ "00:00" "06:00" "12:00" "18:00" ];
      Persistent = true;
    };
  };

}
