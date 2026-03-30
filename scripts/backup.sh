#!/usr/bin/env bash
set -euo pipefail

SERVER_NAME="${1:?usage: backup.sh <server-name> <rcon-port> <rcon-password>}"
RCON_PORT="${2:?usage: backup.sh <server-name> <rcon-port> <rcon-password>}"
RCON_PASSWORD="${3:?usage: backup.sh <server-name> <rcon-port> <rcon-password>}"

BASE_DIR="/srv/minecraft"
LEVEL_NAME="world"

SERVER_DIR="${BASE_DIR}/${SERVER_NAME}"
WORLD_DIR="${SERVER_DIR}/${LEVEL_NAME}"
BACKUP_DIR="${BASE_DIR}/backups/${SERVER_NAME}"

if [[ ! -d "$SERVER_DIR" ]]; then
  echo "error: server directory not found: $SERVER_DIR" >&2
  exit 1
fi

if [[ ! -d "$WORLD_DIR" ]]; then
  echo "error: world directory not found: $WORLD_DIR" >&2
  exit 1
fi

mkdir -p "$BACKUP_DIR"

timestamp="$(date +%F-%H%M%S)"
backup_file="${BACKUP_DIR}/${LEVEL_NAME}-${timestamp}.tar.gz"

cleanup() {
  mcrcon -H 127.0.0.1 -P "$RCON_PORT" -p "$RCON_PASSWORD" "save-on" || true
}
trap cleanup EXIT

echo "[$(date --iso-8601=seconds)] Starting backup for ${SERVER_NAME}"
echo "[$(date --iso-8601=seconds)] Backup file: ${backup_file}"
mcrcon -H 127.0.0.1 -P "$RCON_PORT" -p "$RCON_PASSWORD" "say [Backup] Starting world backup..."
mcrcon -H 127.0.0.1 -P "$RCON_PORT" -p "$RCON_PASSWORD" "say [Backup] Saving and locking world data..."

mcrcon -H 127.0.0.1 -P "$RCON_PORT" -p "$RCON_PASSWORD" "save-all flush"
mcrcon -H 127.0.0.1 -P "$RCON_PORT" -p "$RCON_PASSWORD" "save-off"

tar -C "$SERVER_DIR" \
  --exclude="${LEVEL_NAME}/data/DistantHorizons.sqlite" \
  -czf "$backup_file" \
  "$LEVEL_NAME"

mcrcon -H 127.0.0.1 -P "$RCON_PORT" -p "$RCON_PASSWORD" "save-on"

find "$BACKUP_DIR" -maxdepth 1 -type f -name "${LEVEL_NAME}-*.tar.gz" -printf '%T@ %p\n' \
  | sort -nr \
  | tail -n +3 \
  | cut -d' ' -f2- \
  | xargs -r rm -f

echo "[$(date --iso-8601=seconds)] Backup complete for ${SERVER_NAME}"
mcrcon -H 127.0.0.1 -P "$RCON_PORT" -p "$RCON_PASSWORD" "say [Backup] Backup complete."
