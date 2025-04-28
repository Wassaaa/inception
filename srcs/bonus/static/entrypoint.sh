#!/bin/sh
set -euo pipefail

echo ">> Starting Nginx ($*)"
exec "$@"
