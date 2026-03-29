#!/usr/bin/env bash
set -euo pipefail

server="${1:-savage}"
seed="${2:-}"
world_dir="/srv/minecraft/${server}/world"
props="/srv/minecraft/${server}/server.properties"

if ! sudo test -f "$props"; then
  echo "error: server.properties not found: $props" >&2
  exit 1
fi

current_seed="$(sudo grep '^level-seed=' "$props" | cut -d= -f2- || true)"

if [[ "$seed" == "random" ]]; then
  prompt="Reset '${server}' with a random seed? This deletes ${world_dir} [yes/N]: "
elif [[ -z "$seed" ]]; then
  prompt="Reset '${server}' reusing current seed '${current_seed}'? This deletes ${world_dir} [yes/N]: "
elif [[ "$seed" =~ ^-?[0-9]+$ ]]; then
  prompt="Reset '${server}' with seed '${seed}'? This deletes ${world_dir} [yes/N]: "
else
  echo "error: seed must be a number, 'random', or blank" >&2
  exit 1
fi

read -r -p "$prompt" confirm
[[ "$confirm" == "yes" ]] || { echo "Aborted."; exit 0; }

sudo systemctl stop "minecraft-server-${server}"

if [[ "$seed" == "random" ]]; then
  sudo sed -i '/^level-seed=/d' "$props"
elif [[ "$seed" =~ ^-?[0-9]+$ ]]; then
  if sudo grep -q '^level-seed=' "$props"; then
    sudo sed -i "s/^level-seed=.*/level-seed=${seed}/" "$props"
  else
    echo "level-seed=${seed}" | sudo tee -a "$props" >/dev/null
  fi
fi

sudo rm -rf "$world_dir"
sudo systemctl start "minecraft-server-${server}"
