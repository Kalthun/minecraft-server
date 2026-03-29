host := `hostname`

default:
    @just --list

rebuild:
    sudo nixos-rebuild switch --flake ~/minecraft-server/#{{host}}

update:
    nix flake update

start server="savage":
    sudo systemctl start minecraft-server-{{server}}

stop server="savage":
    sudo systemctl stop minecraft-server-{{server}}

restart server="savage":
    sudo systemctl restart minecraft-server-{{server}}

logs server="savage":
    journalctl -u minecraft-server-{{server}} -f

status server="savage":
    systemctl status minecraft-server-{{server}}

backup server="savage" port="25575" password="password":
    sudo ~/minecraft-server/scripts/backup.sh {{server}} {{port}} {{password}}

clean:
    sudo nix-collect-garbage -d
    nix-collect-garbage -d
    nix store optimise
