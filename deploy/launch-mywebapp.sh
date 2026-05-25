#!/bin/bash
set -euo pipefail

CONFIG="${CONFIG_PATH:-${DEPLOY_APP_CONFIG_FILE:-/etc/mywebapp/config.yaml}}"
cd "${DEPLOY_APP_DIR:?}"
export NODE_ENV=production

case "${1:-}" in
	migrate) exec node src/migrate.js --config "$CONFIG" ;;
	serve | socket) export CONFIG_PATH="$CONFIG"; exec node src/index.js ;;
	*)
		echo "usage: $0 migrate|serve|socket" >&2
		exit 1
		;;
esac
