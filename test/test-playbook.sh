#!/bin/bash

# BBForge Ansible Playbook Test Script
# This script validates and tests the Ansible playbook

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "=========================================="
echo "BBForge Playbook Test Suite"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
    else
        echo -e "${RED}✗${NC} $2"
    fi
}

# Check if ansible is installed
echo "Checking prerequisites..."
if ! command -v ansible-playbook &> /dev/null; then
    echo -e "${RED}Error: ansible-playbook not found. Please install ansible-core.${NC}"
    exit 1
fi
print_status 0 "Ansible is installed"

echo ""
echo "=========================================="
echo "1. Syntax Check"
echo "=========================================="
if ansible-playbook main.yml --syntax-check; then
    print_status 0 "Syntax check passed"
else
    print_status 1 "Syntax check failed"
    exit 1
fi

echo ""
echo "=========================================="
echo "2. Linting (if ansible-lint is available)"
echo "=========================================="
if command -v ansible-lint &> /dev/null; then
    if ansible-lint main.yml; then
        print_status 0 "Linting passed"
    else
        print_status 1 "Linting failed (non-critical)"
    fi
else
    echo -e "${YELLOW}⚠ ansible-lint not installed (optional)${NC}"
fi

echo ""
echo "=========================================="
echo "3. Check Mode (Dry Run)"
echo "=========================================="
if ansible-playbook main.yml --check --diff; then
    print_status 0 "Check mode passed"
else
    print_status 1 "Check mode failed"
    echo -e "${YELLOW}Note: Some tasks may fail in check mode if they require actual system changes${NC}"
fi

echo ""
echo "=========================================="
echo "4. Individual Role Tests"
echo "=========================================="
ROLES_TESTED=0
ROLES_PASSED=0

for role_dir in roles/*/; do
    role_name=$(basename "$role_dir")
    test_file="${role_dir}tests/test.yml"
    
    if [ -f "$test_file" ]; then
        ROLES_TESTED=$((ROLES_TESTED + 1))
        echo "Testing role: $role_name"
        if ansible-playbook "$test_file" --syntax-check 2>/dev/null; then
            print_status 0 "Role $role_name syntax OK"
            ROLES_PASSED=$((ROLES_PASSED + 1))
        else
            print_status 1 "Role $role_name syntax check failed"
        fi
    fi
done

echo ""
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo "Roles tested: $ROLES_TESTED/$ROLES_PASSED passed"
echo ""
echo -e "${GREEN}All basic checks completed!${NC}"
echo ""
echo "To run the playbook for real, use:"
echo "  ansible-playbook main.yml -K"

