#!/bin/bash

# CodeMesh Docker Log Management Script

set -e

# Colors for output
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display usage
usage() {
  echo "CodeMesh Docker Log Management"
  echo ""
  echo "Usage: $0 [COMMAND] [OPTIONS]"
  echo ""
  echo "Commands:"
  echo "  view      View logs from services"
  echo "  follow    Follow logs in real-time"
  echo "  clear     Clear logs"
  echo ""
  echo "Options:"
  echo "  SERVICE   postgres|redis|minio|api|web|all (default: all)"
  echo ""
  echo "Examples:"
  echo "  $0 view api"
  echo "  $0 follow postgres"
  echo "  $0 clear all"
}

command=${1:-view}
service=${2:-all}

case $command in
  view)
    echo -e "${BLUE}=== Viewing logs for $service ===${NC}"
    docker-compose logs --tail=100 $service
    ;;
  follow)
    echo -e "${BLUE}=== Following logs for $service ===${NC}"
    docker-compose logs -f $service
    ;;
  clear)
    echo -e "${YELLOW}Clearing logs for $service...${NC}"
    docker-compose logs --tail=0 $service
    echo -e "${GREEN}Logs cleared${NC}"
    ;;
  help)
    usage
    ;;
  *)
    echo "Unknown command: $command"
    usage
    exit 1
    ;;
esac
