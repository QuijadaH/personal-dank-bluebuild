#!/usr/bin/env bash

set -euo pipefail

FSTAB="/etc/fstab"

if [[ $EUID -ne 0 ]]; then
  echo "Run as root."
  exit 1
fi

cp "$FSTAB" "${FSTAB}.bak.$(date +%F-%H%M%S)"

# --- Hardcoded entries below ---
ENTRIES=(
"LABEL=WD-1TB  /var/mnt/WD-1TB@FILES  btrfs  subvol=/@files,noatime,compress=zstd:3,autodefrag,space_cache=v2  0  0"
"LABEL=WD-1TB  /var/mnt/WD-1TB@SEEDS  btrfs  subvol=/@seeds,noatime,compress=zstd:3,autodefrag,space_cache=v2  0 0"
"LABEL=WD-1TB  /var/mnt/WD-1TB@STEAM  btrfs  subvol=/@steam,noatime,autodefrag,space_cache=v2  0 0"
)

mkdir -p /var/mnt/WD-1TB@FILES
mkdir -p /var/mnt/WD-1TB@SEEDS
mkdir -p /var/mnt/WD-1TB@STEAM
mkdir -p /var/mnt/SAMSUNG@STORAGE

for entry in "${ENTRIES[@]}"; do
  if grep -Fxq -- "$entry" "$FSTAB"; then
    echo "Skipping (already exists): $entry"
  else
    echo "$entry" >> "$FSTAB"
    echo "Added: $entry"
  fi
done

systemctl daemon-reload

echo "Done updating /etc/fstab"