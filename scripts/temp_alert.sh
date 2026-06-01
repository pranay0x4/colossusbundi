#!/usr/bin/env sh

set -eu

if [ "${TELEGRAM_BOT_TOKEN:-}" = "" ] || [ "${TELEGRAM_CHAT_ID:-}" = "" ]; then
  echo "TELEGRAM_BOT_TOKEN and TELEGRAM_CHAT_ID must be set" >&2
  exit 1
fi

MESSAGE="${1:-ColossusBundi Temp alert}"
HOSTNAME_VALUE="$(hostname)"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S %Z')"

PAYLOAD="host=${HOSTNAME_VALUE}%0Atime=${TIMESTAMP}%0Amessage=${MESSAGE}"

curl -fsS \
  -X POST \
  "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  -d "chat_id=${TELEGRAM_CHAT_ID}" \
  -d "text=${PAYLOAD}"
