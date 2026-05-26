# BBForge

<p align="center">
 <img height=400px weight=400px src=".assets/KaliForge.png" >
</p>

## Introduction

BBForge is a powerful automation project designed to streamline the customization and provisioning of a fresh Ubuntu installation for bug bounty hunting. Using Ansible playbooks, BBForge installs and configures a comprehensive set of bug bounty tools **plus automated workflow scripts** that orchestrate these tools for real engagements.

**What's New in v2.0:**
- 🔥 **Automated Workflows** - One-command reconnaissance and vulnerability scanning
- 🔥 **Clean Command Aliases** - Use `hunt`, `bb-recon`, `bb-scan` instead of remembering script names
- 🔥 **Authentication Support** - Test authenticated endpoints easily
- 🔥 **12 Specialized Scanners** - Secrets, cloud, 403 bypass, takeover, and more

---

## Quick Installation

On your fresh Ubuntu installation:

```bash
# Install Ansible
sudo apt update
sudo apt install ansible-core

# Clone and run BBForge
git clone https://github.com/v4resk/BBForge
cd BBForge
ansible-playbook main.yml -K

# Restart your shell
source ~/.bashrc  # or source ~/.zshrc
```

**Optional for Synack LP:** Download Go 1.23.5 tarball from a non-LP machine:
```bash
# On non-LP machine:
curl -O https://go.dev/dl/go1.23.5.linux-amd64.tar.gz

# Transfer to BBForge directory:
# Place in: BBForge/roles/install-tools/files/go1.23.5.linux-amd64.tar.gz
```

**Optional:** For VS Code, download the .deb from [here](https://code.visualstudio.com/download) and place it in `roles/install-vscode/files/code.deb`

---

## Automated Workflows

BBForge now includes production-ready automation scripts that orchestrate your bug bounty tools.

### Available Commands

| Command | Description |
|---------|-------------|
| `hunt <target>` | Create organized engagement folder |
| `bb-recon <domain>` | Full recon: subdomains → URLs → JS |
| `bb-scan <dir>` | Vulnerability scanner (XSS, SQLi, SSRF, etc.) |
| `bb-secrets <target>` | Hunt leaked credentials |
| `bb-cloud --keyword <name>` | Cloud asset discovery (S3, Azure, GCP) |
| `bb-403 <url>` | Test 403 bypass techniques |
| `bb-takeover <file>` | Subdomain takeover scanner |
| `bb-params <url>` | Discover hidden parameters |
| `bb-cves <target>` | Scan for known CVEs |
| `bb-arsenal` | Check which tools are installed |
| `bb-help` | Show all commands |

---

## Quick Start Example

```bash
# 1. Create new engagement
hunt acme-corp
cd ~/Targets/acme-corp

# 2. Edit scope.md with program rules
vim scope.md

# 3. Run reconnaissance
bb-recon acme.com
# Output: ~/Targets/acme-corp/recon/acme.com/
# - Subdomains found
# - Live hosts discovered
# - URLs extracted
# - JS files collected

# 4. Run vulnerability scanning
bb-scan recon/acme.com/
# Output: ~/Targets/acme-corp/findings/
# - XSS, SQLi, SSRF, IDOR, etc.
# - CVEs detected
# - Manual review items

# 5. Run specialized scans
bb-secrets --js-bundle recon/acme.com/js/
bb-cloud --keyword acme
bb-takeover recon/acme.com/subdomains/all.txt

# 6. Review findings
ls -lh findings/
```

---

## Common Workflows

### Quick Assessment (10-15 min)
```bash
bb-recon example.com --quick
bb-scan recon/example.com/ --quick
```

### Full Comprehensive Scan (1-2 hours)
```bash
bb-recon example.com
bb-scan recon/example.com/ --full
```

### Authenticated Testing (for Synack targets)
```bash
# Set authentication
export BBHUNT_AUTH_HEADERS="Authorization: Bearer TOKEN"
export BBHUNT_SESSION_ID="session=abc123"

# Run authenticated scans
bb-recon example.com
bb-scan recon/example.com/

# Clear when done
unset BBHUNT_AUTH_HEADERS
unset BBHUNT_SESSION_ID
```

### Focus on High-Value Targets
```bash
# Quick wins
bb-takeover recon/example.com/subdomains/all.txt  # Easy Critical
bb-secrets --js-bundle recon/example.com/js/      # API keys
bb-cves recon/example.com/live/hosts.txt          # Known exploits

# Deep testing
cat recon/example.com/urls/gf-xss.txt | while read url; do
    bb-params "$url"  # Find hidden params
done
```

---

## Engagement Folder Structure

When you run `hunt <target>`, BBForge creates:

```
~/Targets/<target>/
├── CLAUDE.md           # Engagement context
├── scope.md            # Program scope/rules (fill this first!)
├── submissions.txt     # Track submitted findings
├── notes.md            # Scratchpad
├── findings/           # Draft reports
│   ├── xss/
│   ├── sqli/
│   ├── ssrf/
│   ├── idor/
│   ├── takeover/
│   ├── cves/
│   └── ...
├── evidence/           # Screenshots/HARs (gitignored)
└── recon/
    └── <domain>/
        ├── subdomains/all.txt
        ├── live/hosts.txt
        ├── urls/all.txt
        └── js/all.txt
```

---

## What bb-recon Does

**Input:** Domain name (or IP, CIDR, file of domains)

**Process:**
1. **Subdomain Enumeration** - subfinder, amass, assetfinder, chaos, findomain
2. **Live Host Discovery** - httpx, dnsx (filters out dead hosts)
3. **Port Scanning** - naabu (optional, in full mode)
4. **URL Crawling** - katana, waybackurls, gau (archives + active crawl)
5. **JS Extraction** - subjs (finds JavaScript files)
6. **Pattern Classification** - gf patterns (groups by vulnerability type)

**Output:** Organized in `recon/<domain>/` with deduplication and prioritization

**Options:**
- `--quick` - Faster, less coverage (~10 min)
- Default - Full coverage (~30-60 min)

---

## What bb-scan Does

**Input:** Recon output directory

**Process:** Tests for:
- ✅ XSS (Reflected, Stored, DOM) - dalfox integration
- ✅ SQL Injection - with PoC verification
- ✅ SSRF - with Interactsh OOB callbacks
- ✅ SSTI (Jinja2, Freemarker, ERB, etc.)
- ✅ Open Redirects
- ✅ IDOR patterns
- ✅ LFI/RFI
- ✅ JWT weaknesses
- ✅ GraphQL introspection
- ✅ CORS misconfigurations
- ✅ Subdomain takeover
- ✅ Cloud misconfigs (S3 buckets)
- ✅ Race conditions
- ✅ CVEs (nuclei)

**Output:** Findings categorized by vulnerability class in `findings/`

**Options:**
- `--quick` - Fast scan, critical checks only (~15 min)
- `--full` - Comprehensive scan (~1-2 hours)
- `--skip xss,sqli` - Skip specific vulnerability classes

---

## Specialized Scanners

### bb-secrets - Credential Hunting
```bash
# Scan filesystem
bb-secrets --filesystem ~/code/target-repo/

# Scan git repository
bb-secrets --git https://github.com/target/repo

# Scan JS bundles from recon
bb-secrets --js-bundle recon/example.com/js/

# Scan entire GitHub org
bb-secrets --github-org target-org
```

Uses trufflehog (verifies live keys), noseyparker, and gitleaks.

---

### bb-cloud - Cloud Asset Discovery
```bash
# Find public S3/Azure/GCP buckets
bb-cloud --keyword acme

# Bypass CloudFlare to find origin IP
bb-cloud --cf-bypass example.com
```

---

### bb-403 - Bypass Testing
```bash
bb-403 https://example.com/admin
bb-403 -l urls.txt  # Batch mode
```

Tests 20+ bypass techniques:
- Header injection (X-Original-URL, X-Forwarded-For)
- Path encoding (Unicode, double encoding)
- HTTP method swap (GET→POST, etc.)
- Case variations

---

### bb-takeover - Subdomain Takeover
```bash
bb-takeover subdomains.txt
bb-takeover --recon ~/Targets/acme/recon/
```

Detects dangling CNAMEs for 27+ providers (GitHub Pages, Heroku, S3, Azure, etc.)

---

### bb-params - Hidden Parameters
```bash
bb-params https://api.example.com/user
bb-params -l urls.txt
```

Discovers hidden parameters that often lead to IDOR, SSRF, auth bypass.

---

### bb-cves - CVE Scanning
```bash
bb-cves https://example.com --year 2024
bb-cves --recon ~/Targets/acme/recon/
```

Runs nuclei CVE templates, optionally filtered by year.

---

## Tool Management

### Check Tool Status
```bash
bb-arsenal
# Shows which of 80+ tools are installed
```

### Get Install Hints
```bash
bb-arsenal --install-hint nuclei
```

### Re-run Tool Installation
```bash
cd ~/Documents/Projects/BBForge
ansible-playbook main.yml -K --tags "install-tools"
```

---

## Installed Tools

BBForge installs 100+ bug bounty tools:

### Reconnaissance
- Subdomain: subfinder, amass, assetfinder, findomain, chaos
- HTTP Probing: httpx, httprobe
- Crawling: katana, gospider, hakrawler, cariddi
- URL Discovery: gau, waybackurls, waymore
- DNS: dnsx, shuffledns, puredns, massdns

### Vulnerability Scanning
- Scanning: nuclei, jaeles, naabu
- XSS: dalfox, xsstrike, kxss, airixss
- SQLi: sqlmap, ghauri
- Fuzzing: ffuf, feroxbuster
- API Discovery: arjun, x8, paramspider

### Specialized
- JS Analysis: subjs, linkfinder, secretfinder, jsubfinder
- Git Recon: trufflehog, github-subdomains
- Cloud: awscli, cloudenum, s3scanner, cloudfail
- OSINT: shodan, censys, metabigor
- 403 Bypass: byp4xx
- Takeover: dnsreaper, subjack
- JWT: jwt_tool
- SSRF/OOB: interactsh-client
- Utilities: anew, qsreplace, unfurl, gf, uro

### Plus Configuration
- BurpSuite + Firefox certificate
- Obsidian with templates
- Tmux + zsh with custom configs
- VS Code (optional)
- Azerty keyboard layout (optional)

---

## Troubleshooting

### Commands not found
```bash
# Restart shell
source ~/.bashrc

# Or re-run playbook
ansible-playbook main.yml -K
```

### Tools show as "NOT FOUND"
```bash
# Check which are missing
bb-arsenal | grep "NOT FOUND"

# Re-install tools
ansible-playbook main.yml -K --tags "install-tools"

# Manual install example
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
```

### Recon finds nothing
```bash
# Test domain is valid
dig example.com

# Test tools directly
subfinder -d example.com -silent
httpx -u https://example.com -silent
```

### Scan is too slow
```bash
# Use quick mode
bb-scan recon/ --quick

# Skip slow checks
bb-scan recon/ --skip sqli,lfi,ssti

# Reduce target scope
head -n 100 recon/example.com/urls/all.txt > priority.txt
```

### Permission denied
```bash
chmod +x ~/Documents/BBForge-Scripts/*.sh
```

### Synack LP Network Issues

**Problem:** Connection errors during playbook execution

**Common Causes:**
- Download domains not on LP allowlist
- Redirects to blocked CDN domains
- External tool repositories blocked

**Solutions:**
```bash
# Check if system Go is already installed (Synack VMs usually have it)
go version

# If Go is already 1.21+, the playbook will skip upgrade
# If Go upgrade fails, playbook will use system Go automatically

# Most tools install from LP-allowed sources:
# - GitHub (github.com, githubusercontent.com) ✅
# - Go packages (golang.org, proxy.golang.org) ✅
# - PyPI (pypi.org, pythonhosted.org) ✅
# - Rubygems (rubygems.org) ✅

# If a tool fails to install, continue anyway:
ansible-playbook main.yml -K --skip-tags "failing-tag"
```

**Note:** BBForge has been tested and works in Synack LP environments. The Go download URL has been updated to use `golang.org` instead of `go.dev` for LP compatibility.

---

## Tips & Best Practices

### Start with Quick Mode
```bash
bb-recon example.com --quick  # Get initial assessment
bb-scan recon/example.com/ --quick
```

### Prioritize Targets
```bash
# Focus on interesting subdomains
grep -E "(admin|api|dev|test|stage)" recon/example.com/subdomains/all.txt

# Skip CDNs
grep -v "cloudfront\|akamai\|fastly" recon/example.com/live/hosts.txt
```

### Run Long Scans in Background
```bash
nohup bb-scan recon/example.com/ --full > scan.log 2>&1 &
tail -f scan.log
```

### Quick Wins First
```bash
bb-takeover recon/example.com/subdomains/all.txt  # Easy Critical findings
bb-secrets --js-bundle recon/example.com/js/      # API keys = Critical
bb-cves recon/example.com/live/hosts.txt          # Known exploits
```

### Track Your Work
```bash
# Keep notes
echo "Found admin panel at admin.acme.com:8443" >> notes.md

# Track submissions
echo "H1-123456  P2  XSS  Reflected XSS in search" >> submissions.txt

# Document dead ends
echo "WAF blocks all SQLi on /api/*" >> notes.md
```

---

## Quick Reference

```bash
# Navigation
cdtarget              # Go to ~/Targets
cdtarget acme         # Go to specific target

# Core workflow
hunt <target>         # Create engagement
bb-recon <domain>     # Reconnaissance
bb-scan <dir>         # Vulnerability scanning
bb-arsenal            # Check tools

# Specialized
bb-secrets <options>  # Credential hunting
bb-cloud <options>    # Cloud assets
bb-403 <url>          # 403 bypass
bb-takeover <file>    # Subdomain takeover
bb-params <url>       # Parameter discovery
bb-cves <target>      # CVE scanning

# Help
bb-help               # Show all commands
```

---

## File Locations

```
~/Documents/BBForge-Scripts/    # Automation scripts
~/Targets/                      # All engagements
~/.bb-workflows.sh              # Shell configuration (auto-loaded)
```

---

## Advanced Features

### Batch Processing
```bash
# Scan multiple targets in parallel
cat targets.txt | xargs -P 5 -I {} bb-recon {}

# Find all XSS candidates across engagements
find ~/Targets/*/recon/ -name "gf-xss.txt" -exec cat {} \;
```

### Integration with Burp
```bash
# Scripts respect proxy settings
export http_proxy="http://localhost:8080"
export https_proxy="http://localhost:8080"
bb-recon example.com  # Traffic goes through Burp
```

### Custom Wordlists
```bash
export CUSTOM_SUBDOMAIN_WORDLIST="/path/to/wordlist.txt"
bb-recon example.com
```

---

## What Makes BBForge Different

**Traditional Setup:**
- ❌ Manual tool installation
- ❌ Remember 100+ command syntaxes
- ❌ Manual result correlation
- ❌ Inconsistent workflows

**BBForge:**
- ✅ One-command installation
- ✅ Simple aliases (`bb-recon`, `bb-scan`)
- ✅ Automated tool orchestration
- ✅ Organized output structure
- ✅ Authentication-aware testing
- ✅ Graceful fallbacks if tools missing

---

## Technical Details

### Architecture
- **Base:** Ansible playbooks for provisioning
- **Workflows:** Bash scripts with tool orchestration
- **Integration:** Shell aliases via `~/.bb-workflows.sh`
- **Authentication:** Environment variable framework
- **Tool Detection:** Dynamic capability checking

### Requirements
- Ubuntu 20.04+ (fresh installation recommended)
- ~10GB disk space for tools
- Internet connection during installation
- Ansible-core

### Synack Launchpoint Environment
BBForge is designed to work in **Synack LP restricted network environments**:
- ✅ All tool downloads use LP-allowlisted domains
- ⚠️ **Go upgrade via local tarball** - place `go1.23.5.linux-amd64.tar.gz` in `roles/install-tools/files/`
- ✅ Without tarball: System Go version (typically 1.18-1.22) used - **sufficient for all tools**
- ✅ All bug bounty tools install successfully with system Go
- 💡 See "Quick Installation" section above for Go tarball instructions

**Why can't we download Go automatically in LP?**
- `golang.org` redirects to `dl.google.com` (not on LP allowlist)
- Solution: Download tarball outside LP, copy to BBForge, run playbook

**System Go is sufficient:** The Go version on Synack VMs (usually Go 1.18+) is adequate for all bug bounty tools in BBForge. Go modules are forward-compatible.

### What Gets Installed
- Go 1.23.5+ (if tarball provided) OR system Go 1.18+ (Synack LP fallback)
- Python 3.x + pipx
- 100+ bug bounty tools
- 12 workflow automation scripts
- Shell configuration
- Optional: VS Code, BurpSuite, Obsidian

---

## Contributing

Found a bug or want to add a feature?

1. Fork the repo
2. Create your feature branch
3. Test on fresh Ubuntu VM
4. Submit pull request

---

## References & Credits

**Inspired by:** [IppSec's KaliForge](https://github.com/v4resk/KaliForge)

**Workflow Scripts:** Adapted from production bug bounty automation

**Author:** v4resk

**License:** MIT (see LICENSE file)

---

## Support

**Issues:** [GitHub Issues](https://github.com/v4resk/BBForge/issues)

**Documentation Updates:** This README is the single source of truth

---

## Changelog

**v2.0 (2024-05-26)**
- ✨ Added 12 automated workflow scripts
- ✨ Added authentication framework
- ✨ Added 9 missing tool dependencies
- 🔧 Consolidated all documentation into README.md
- 📚 Simplified workflow aliases

**v1.0**
- Initial release with tool installation

---

**Happy Hunting! 🎯**

For questions or issues, open a GitHub issue or check existing discussions.
