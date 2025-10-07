#!/bin/bash
#
# ==========================================================
#  Docker Compose multi-env deployer (dev/prod)
#  For GitLab + GitLab Runner + SonarQube + Nexus
#  Compatible Synology / Linux
# ==========================================================

set -e

# --- CONFIGURATION ----------------------------------------

COMPOSE_FILE="docker-compose.yml"
DEFAULT_ENV_DEV=".env.dev"
DEFAULT_ENV_PROD=".env.prod"

# --- FUNCTIONS --------------------------------------------

print_help() {
  echo "Usage: $0 [dev|prod|down|logs|status]"
  echo
  echo "Commands:"
  echo "  dev      Start services with $DEFAULT_ENV_DEV"
  echo "  prod     Start services with $DEFAULT_ENV_PROD"
  echo "  down     Stop and remove all services"
  echo "  logs     Follow logs from all containers"
  echo "  status   Show running containers"
  echo
  exit 0
}

start_env() {
  local env_file=$1

  if [ ! -f "$env_file" ]; then
    echo "[x] Error: $env_file not found!"
    exit 1
  fi

  echo "-> Using environment: $env_file"
  export ENV_FILE="$env_file"

  docker compose --env-file "$env_file" up -d
  echo "[ok] Stack started with $env_file"
}

stop_env() {
  echo "-> Stopping containers..."
  docker compose down
  echo "[ok] Containers stopped."
}

show_logs() {
  docker compose logs -f
}

show_status() {
  docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
}

# --- MAIN -------------------------------------------------

case "$1" in
  dev)
    start_env "$DEFAULT_ENV_DEV"
    ;;
  prod)
    start_env "$DEFAULT_ENV_PROD"
    ;;
  down)
    stop_env
    ;;
  logs)
    show_logs
    ;;
  status)
    show_status
    ;;
  *)
    print_help
    ;;
esac
