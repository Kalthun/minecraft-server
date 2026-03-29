#!/usr/bin/env bash
set -euo pipefail

server="${1:-savage}"
seed="${2:-}"
server_nix="./servers/${server}/server.nix"
world_dir="/srv/minecraft/${server}/world"

if [[ -n "$seed" ]]; then
  prompt="Reset '${server}' with seed '${seed}'? This deletes ${world_dir} [yes/N]: "
else
  prompt="Reset '${server}'? This deletes ${world_dir} [yes/N]: "
fi

read -r -p "$prompt" confirm
[[ "$confirm" == "yes" ]] || { echo "Aborted."; exit 0; }

sudo systemctl stop "minecraft-server-${server}"

if [[ -n "$seed" ]]; then
  sed -i "s|level-seed = \".*\";|level-seed = \"${seed}\";|" "$server_nix"
  sudo nixos-rebuild switch --flake .#"$(hostname)"
fi

sudo rm -rf "$world_dir"
sudo systemctl start "minecraft-server-${server}"
