# BBForge Testing

This directory contains testing utilities and scripts for the BBForge Ansible playbook.

## Files

- **Dockerfile** - Docker image for testing the playbook in an isolated Ubuntu environment
- **docker-compose.yml** - Docker Compose configuration for easy container management
- **test-playbook.sh** - Local test script that validates syntax and runs check mode
- **docker-test.sh** - Script to build and run Docker-based tests

## Quick Start

### Local Testing (without Docker)

Run the test script directly:

```bash
cd test
chmod +x test-playbook.sh
./test-playbook.sh
```

This will:
- Check Ansible syntax
- Run ansible-lint (if available)
- Run playbook in check mode (dry-run)
- Test individual role syntax

### Docker Testing

For isolated testing in a clean Ubuntu environment:

1. **Build and start interactive shell (recommended):**
   ```bash
   cd test
   chmod +x docker-test.sh
   ./docker-test.sh
   ```
   
   Once inside the container, you can run:
   ```bash
   # Syntax check
   ansible-playbook main.yml --syntax-check
   
   # Check mode (dry-run)
   ansible-playbook main.yml --check --diff
   
   # Full playbook (WARNING: makes actual changes)
   ansible-playbook main.yml
   # Note: No password needed - container runs as root
   ```
   
   Type `exit` to leave the container.

2. **Or use docker-compose directly from host:**
   ```bash
   cd test
   
   # Build image
   docker-compose build
   
   # Run syntax check (from host)
   docker-compose run --rm ansible-test ansible-playbook main.yml --syntax-check
   
   # Run check mode (from host)
   docker-compose run --rm ansible-test ansible-playbook main.yml --check --diff
   
   # Interactive shell (from host)
   docker-compose run --rm ansible-test /bin/bash
   ```
   
   **Note:** When using docker-compose commands, run them from the host (outside the container). Once inside the container, use `ansible-playbook` directly.

## Testing Workflow

1. **Before committing changes:**
   ```bash
   ./test/test-playbook.sh
   ```

2. **For full integration testing:**
   ```bash
   ./test/docker-test.sh
   # Then inside container: ansible-playbook main.yml --check
   ```

3. **To test on actual system (be careful!):**
   ```bash
   ansible-playbook main.yml -K
   ```

## Notes

- The Docker container mounts the project directory, so changes are reflected immediately
- Use `--check` mode to see what would change without making actual modifications
- The test directory is excluded from git (see `.gitignore`)
- Docker testing requires Docker and Docker Compose to be installed

