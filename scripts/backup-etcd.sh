#!/usr/bin/env bash
# Kubernetes etcd backup script

BACKUP_DIR="/mnt/backups/k3s-etcd"
DATE=$(date +%Y%m%d-%H%M%S)

sudo k3s etcd-snapshot \
  --snapshot-compress \
  --snapshot-dir="$BACKUP_DIR" \
  --s3 \
  --s3-bucket="my-backups" \
  --s3-endpoint="s3.eu-west-1.amazonaws.com"

find "$BACKUP_DIR" -type f -mtime +30 -delete