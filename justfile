host := `hostname`

default:
    @just --list

rebuild:
    sudo nixos-rebuild switch --flake ~/minecraft-server/#{{host}}

update:
    nix flake update

start server:
    sudo systemctl start minecraft-server-{{server}}

stop server:
    sudo systemctl stop minecraft-server-{{server}}

restart server:
    sudo systemctl restart minecraft-server-{{server}}

logs server:
    journalctl -u minecraft-server-{{server}} -f

status server:
    systemctl status minecraft-server-{{server}}

backup server port password:
    sudo ~/minecraft-server/scripts/backup.sh {{server}} {{port}} {{password}}

clean:
    sudo nix-collect-garbage -d
    nix-collect-garbage -d
    nix store optimise
