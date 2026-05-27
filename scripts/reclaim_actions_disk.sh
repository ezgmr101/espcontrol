#!/usr/bin/env bash
set -euo pipefail

DOCKER_COMMAND=${DOCKER:-docker}
KEEP_STORAGE=${ESPCONTROL_DOCKER_BUILD_CACHE_KEEP:-2GB}

disk_report() {
  local label=$1
  echo "${label}:"
  df -h "${GITHUB_WORKSPACE:-$PWD}" "$HOME" 2>/dev/null || true
}

if ! ${DOCKER_COMMAND} info >/dev/null 2>&1; then
  echo "Docker is not available; skipping Docker disk cleanup."
  exit 0
fi

disk_report "Disk before cleanup"
${DOCKER_COMMAND} container prune -f >/dev/null || true
${DOCKER_COMMAND} image prune -f >/dev/null || true
${DOCKER_COMMAND} builder prune -f --keep-storage "${KEEP_STORAGE}" >/dev/null || true
${DOCKER_COMMAND} system df || true
disk_report "Disk after cleanup"
