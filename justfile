host := `hostname`
server-name := "savage"

default:
    @just --list

rebuild:
    sudo nixos-rebuild switch --flake ~/minecraft-server/#{{host}}

update:
    nix flake update

start:
    sudo systemctl start minecraft-server-{{server-name}}

stop:
    sudo systemctl stop minecraft-server-{{server-name}}

restart:
    sudo systemctl restart minecraft-server-{{server-name}}

logs:
    journalctl -u minecraft-server-{{server-name}} -f

status:
    systemctl status minecraft-server-{{server-name}}