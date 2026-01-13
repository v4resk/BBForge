#!/bin/bash

# Docker-based testing script for BBForge
# This script builds and runs the playbook in a Docker container

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$SCRIPT_DIR"

echo "=========================================="
echo "BBForge Docker Test"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed or not in PATH"
    exit 1
fi

echo "Building Docker image..."
docker-compose build

echo ""
echo "=========================================="
echo "Docker container ready!"
echo "=========================================="
echo ""
echo -e "${YELLOW}You are now entering the Docker container.${NC}"
echo ""
echo "Inside the container, you can run:"
echo ""
echo "1. Syntax check:"
echo "   ansible-playbook main.yml --syntax-check"
echo ""
echo "2. Check mode (dry-run):"
echo "   ansible-playbook main.yml --check --diff"
echo ""
echo "3. Run full playbook (WARNING: will make actual changes):"
echo "   ansible-playbook main.yml"
echo "   (No password needed - running as root)"
echo ""
echo -e "${GREEN}Type 'exit' to leave the container${NC}"
echo ""

docker-compose run --rm ansible-test /bin/bash

