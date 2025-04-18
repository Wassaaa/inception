#!/bin/sh
set -euo pipefail

# run every init script once
for f in /docker-entrypoint-initdb.d/*; do
  [ -x "$f" ] && "$f"
done

# Start MariaDB server
exec "$@"
