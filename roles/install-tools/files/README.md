# Optional Files for Synack Launchpoint

This directory can contain optional files for installation in restricted network environments like Synack LP.

## Go Tarball (Optional)

**For Synack LP users:** Place Go tarball here to enable Go upgrade.

**Filename:** `go1.23.5.linux-amd64.tar.gz`

**How to get it:**
```bash
# On a machine with unrestricted internet (NOT Synack LP):
curl -O https://go.dev/dl/go1.23.5.linux-amd64.tar.gz

# Transfer to this directory:
# BBForge/roles/install-tools/files/go1.23.5.linux-amd64.tar.gz
```

**What happens:**
- If file exists: Playbook uses it to upgrade to Go 1.23.5
- If file missing: Playbook uses system Go (1.18-1.22) - works fine for all tools

**Note:** The Go tarball is ~70MB and is .gitignored (won't be committed to repo).

---

## Why is this needed?

Synack Launchpoint has a network allowlist. Go downloads redirect through `dl.google.com` which is not on the LP allowlist, so automatic downloads fail.

By placing the tarball here manually, you bypass the network restriction.

---

## System Go is sufficient

If you don't provide the tarball, BBForge will use the system Go version (typically 1.18-1.22 on Ubuntu). This is **perfectly adequate** for all bug bounty tools - Go modules are forward-compatible.

---

## Other Optional Files

- (None currently, but this pattern can be used for other large downloads in restricted networks)
