#!/bin/sh
set -eu

ENV_PATH="/data/.env"
APP_ENV_PATH="/app/.env"
BACKEND_ENV_PATH="/app/backend/.env"

mkdir -p /data

if [ ! -f "$ENV_PATH" ]; then
    {
        echo "SERVER_HOST=0.0.0.0"
        echo "SERVER_PORT=${PORT:-9800}"
        echo "DATABASE_URL=${DATABASE_URL:-sqlite:////data/ai_polish.db}"
        echo "SECRET_KEY=${SECRET_KEY:-change-this-secret-key}"
        echo "ADMIN_USERNAME=${ADMIN_USERNAME:-admin}"
        echo "ADMIN_PASSWORD=${ADMIN_PASSWORD:-change-this-password}"
        echo "USE_STREAMING=${USE_STREAMING:-false}"
        echo "POLISH_MODEL=${POLISH_MODEL:-gpt-5}"
        echo "POLISH_API_KEY=${POLISH_API_KEY:-}"
        echo "POLISH_BASE_URL=${POLISH_BASE_URL:-}"
        echo "ENHANCE_MODEL=${ENHANCE_MODEL:-gpt-5}"
        echo "ENHANCE_API_KEY=${ENHANCE_API_KEY:-}"
        echo "ENHANCE_BASE_URL=${ENHANCE_BASE_URL:-}"
        echo "COMPRESSION_MODEL=${COMPRESSION_MODEL:-gpt-5}"
        echo "COMPRESSION_API_KEY=${COMPRESSION_API_KEY:-}"
        echo "COMPRESSION_BASE_URL=${COMPRESSION_BASE_URL:-}"
        echo "HISTORY_COMPRESSION_THRESHOLD=${HISTORY_COMPRESSION_THRESHOLD:-5000}"
        echo "MAX_CONCURRENT_USERS=${MAX_CONCURRENT_USERS:-5}"
        echo "DEFAULT_USAGE_LIMIT=${DEFAULT_USAGE_LIMIT:-1}"
        echo "SEGMENT_SKIP_THRESHOLD=${SEGMENT_SKIP_THRESHOLD:-15}"
        echo "API_REQUEST_INTERVAL=${API_REQUEST_INTERVAL:-6}"
        echo "MAX_UPLOAD_FILE_SIZE_MB=${MAX_UPLOAD_FILE_SIZE_MB:-0}"
    } > "$ENV_PATH"
fi

rm -f "$APP_ENV_PATH" "$BACKEND_ENV_PATH"
ln -s "$ENV_PATH" "$APP_ENV_PATH"
ln -s "$ENV_PATH" "$BACKEND_ENV_PATH"

exec "$@"
