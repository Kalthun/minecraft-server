host := `hostname`

default:
    @just --list


# NixOS

rebuild:
    sudo nixos-rebuild switch --flake ~/minecraft-server/#{{host}}

update:
    nix flake update

clean:
    sudo nix-collect-garbage -d
    nix-collect-garbage -d
    nix store optimise


# Minecraft

start server="savage":
    sudo systemctl start minecraft-server-{{server}}

stop server="savage":
    sudo systemctl stop minecraft-server-{{server}}

restart server="savage":
    sudo systemctl restart minecraft-server-{{server}}

status server="savage":
    systemctl status minecraft-server-{{server}}

logs server="savage":
    journalctl -u minecraft-server-{{server}} -f

backup server="savage" port="25575" password="password":
    sudo ./scripts/backup.sh {{server}} {{port}} {{password}}

reset server="savage" seed="":
    ./scripts/reset.sh {{server}} {{seed}}
