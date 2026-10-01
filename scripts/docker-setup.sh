#!/bin/bash

# CodeMesh Docker Development Environment Setup Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_header() {
  echo -e "${BLUE}=== $1 ===${NC}"
}

print_success() {
  echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
  echo -e "${RED}✗ $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠ $1${NC}"
}

# Check prerequisites
check_prerequisites() {
  print_header "Checking Prerequisites"

  if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed"
    exit 1
  fi
  print_success "Docker is installed"

  if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed"
    exit 1
  fi
  print_success "Docker Compose is installed"

  if ! command -v curl &> /dev/null; then
    print_error "curl is not installed"
    exit 1
  fi
  print_success "curl is installed"
}

# Setup environment
setup_env() {
  print_header "Setting up Environment"

  if [ ! -f .env.local ]; then
    print_warning "Creating .env.local from .env.docker"
    cp .env.docker .env.local
  fi

  print_success "Environment configuration ready"
}

# Start services
start_services() {
  print_header "Starting Services"

  docker-compose up -d

  print_success "Services started"
}

# Wait for services
wait_for_services() {
  print_header "Waiting for Services to be Healthy"

  services=("postgres" "redis" "minio" "api" "web")
  max_attempts=30
  attempt=0

  for service in "${services[@]}"; do
    print_warning "Waiting for $service..."
    attempt=0
    while [ $attempt -lt $max_attempts ]; do
      if docker-compose exec -T "$service" true 2>/dev/null; then
        print_success "$service is ready"
        break
      fi
      sleep 1
      ((attempt++))
    done

    if [ $attempt -eq $max_attempts ]; then
      print_error "$service did not become ready in time"
      exit 1
    fi
  done
}

# Verify connectivity
verify_connectivity() {
  print_header "Verifying Service Connectivity"

  # PostgreSQL
  print_warning "Testing PostgreSQL..."
  if docker-compose exec -T postgres pg_isready -U codemesh -d codemesh_dev &> /dev/null; then
    print_success "PostgreSQL is accessible"
  else
    print_error "PostgreSQL is not accessible"
    exit 1
  fi

  # Redis
  print_warning "Testing Redis..."
  if docker-compose exec -T redis redis-cli -a redis_password ping &> /dev/null; then
    print_success "Redis is accessible"
  else
    print_error "Redis is not accessible"
    exit 1
  fi

  # MinIO
  print_warning "Testing MinIO..."
  if curl -s http://localhost:9000/minio/health/live > /dev/null 2>&1; then
    print_success "MinIO is accessible"
  else
    print_error "MinIO is not accessible"
    exit 1
  fi

  # API
  print_warning "Testing API..."
  if curl -s http://localhost:3001/health > /dev/null 2>&1; then
    print_success "API is accessible"
  else
    print_error "API is not accessible"
    exit 1
  fi

  # Web
  print_warning "Testing Web..."
  if curl -s http://localhost:3000/ > /dev/null 2>&1; then
    print_success "Web is accessible"
  else
    print_error "Web is not accessible"
    exit 1
  fi
}

# Show service URLs
show_urls() {
  print_header "Service URLs"

  echo -e "${GREEN}PostgreSQL:${NC} postgresql://codemesh:codemesh_password@localhost:5432/codemesh_dev"
  echo -e "${GREEN}Redis:${NC} redis://:redis_password@localhost:6379"
  echo -e "${GREEN}MinIO:${NC} http://localhost:9000 (Console: http://localhost:9001)"
  echo -e "${GREEN}API:${NC} http://localhost:3001"
  echo -e "${GREEN}Web:${NC} http://localhost:3000"
  echo ""
  echo -e "${YELLOW}MinIO Credentials:${NC} minioadmin / minioadmin_password"
}

# Main execution
main() {
  print_header "CodeMesh Development Environment Setup"

  check_prerequisites
  setup_env
  start_services
  wait_for_services
  verify_connectivity
  show_urls

  print_success "CodeMesh development environment is ready!"
}

# Run main
main
