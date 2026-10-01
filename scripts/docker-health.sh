#!/bin/bash

# CodeMesh Docker Health Check Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
  local service=$1
  local status=$2
  local message=$3

  if [ "$status" = "healthy" ]; then
    echo -e "${GREEN}✓ $service${NC}: $message"
  else
    echo -e "${RED}✗ $service${NC}: $message"
  fi
}

# Check PostgreSQL
check_postgres() {
  if docker-compose exec -T postgres pg_isready -U codemesh -d codemesh_dev &> /dev/null; then
    print_status "PostgreSQL" "healthy" "Connected and ready"
  else
    print_status "PostgreSQL" "unhealthy" "Connection failed"
    return 1
  fi
}

# Check Redis
check_redis() {
  if docker-compose exec -T redis redis-cli -a redis_password ping &> /dev/null; then
    print_status "Redis" "healthy" "Connected and ready"
  else
    print_status "Redis" "unhealthy" "Connection failed"
    return 1
  fi
}

# Check MinIO
check_minio() {
  if curl -s http://localhost:9000/minio/health/live > /dev/null 2>&1; then
    print_status "MinIO" "healthy" "Connected and ready"
  else
    print_status "MinIO" "unhealthy" "Connection failed"
    return 1
  fi
}

# Check API
check_api() {
  response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3001/health)
  if [ "$response" = "200" ]; then
    print_status "API" "healthy" "Connected and ready"
  else
    print_status "API" "unhealthy" "HTTP $response"
    return 1
  fi
}

# Check Web
check_web() {
  response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/)
  if [ "$response" = "200" ]; then
    print_status "Web" "healthy" "Connected and ready"
  else
    print_status "Web" "unhealthy" "HTTP $response"
    return 1
  fi
}

# Main
echo -e "${BLUE}=== CodeMesh Health Check ===${NC}\n"

all_healthy=true

check_postgres || all_healthy=false
check_redis || all_healthy=false
check_minio || all_healthy=false
check_api || all_healthy=false
check_web || all_healthy=false

echo ""

if [ "$all_healthy" = true ]; then
  echo -e "${GREEN}All services are healthy!${NC}"
  exit 0
else
  echo -e "${RED}Some services are unhealthy.${NC}"
  exit 1
fi
