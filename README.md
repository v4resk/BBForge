# BBForge

<p align="center">
 <img height=400px weight=400px src=".assets/KaliForge.png" >
</p>

## Introduction 

BBForge is a powerful automation project designed to streamline the customization and provisioning process of a fresh Ubuntu installation. This project utilizes Ansible playbooks, allowing users to effortlessly install and configure a comprehensive set of bug bounty tools.

Installing and setting up the box with all the necessary tools traditionally involves numerous manual steps, which can be time-consuming and prone to errors. BBForge aims to simplify this process by automating the installation of essential bug bounty tools and configurations, providing users with a consistent and reliable environment from the start.

## Instructions 

On your fresh Ubuntu installation, install ansible
```bash
sudo apt update
sudo apt install ansible-core
```  

Clone repo
```bash
git clone https://github.com/v4resk/BBForge
cd BBForge
```

**Optional:** If you want to install Visual Studio Code, download the .deb file from [VS Code downloads](https://code.visualstudio.com/download) and place it in `roles/install-vscode/files/code.deb`. If the file is not present, the playbook will skip VS Code installation.

To run it:
```bash
ansible-playbook main.yml -K
```

## Features

| **Status** | **Description** |
|------|------|
|   🗸  | Install Go, pipx, zsh, and BurpSuite     |
|   🗸  | Configure BurpSuite & its certificate in firefox     |
|   🗸  | Configure Obsidian, extensions, vault & templates     |
|   🗸  | Configure Tmux & zsh (auto-install on Ubuntu)    |
|   🗸  | Install Visual-studio-code with some extensions  |
|   🗸  | Install some extensions in firefox     |
|   🗸  | Configure logging with ufw, iptables, rsyslog, auditd    |
|   🗸  | Configure an Azerty Keyboard (Fr keyboard layout)    |
|   🗸  | Install bug bounty tools globally via go/pipx:     |
|   |   - Subdomain tools (subfinder, amass, assetfinder, findomain, chaos)     |
|   |   - HTTP Probing (httpx, httprobe)     |
|   |   - Crawling (katana, gospider, hakrawler, cariddi)     |
|   |   - URL discovery (gau, waybackurls, waymore)     |
|   |   - Scanning (nuclei, jaeles, naabu)     |
|   |   - XSS tools (dalfox, xsstrike, kxss, airixss)     |
|   |   - Utilities (anew, qsreplace, unfurl, gf, uro)     |
|   |   - Fuzzing (ffuf, feroxbuster)     |
|   |   - JS Analysis (subjs, linkfinder, secretfinder, jsubfinder)     |
|   |   - DNS tools (dnsx, shuffledns, puredns, massdns, dnsgen)     |
|   |   - Reverse DNS (hakrevdns, prips)     |
|   |   - Screenshots (gowitness, eyewitness)     |
|   |   - Git Recon (trufflehog, gitrob, github-subdomains)     |
|   |   - SQLi tools (sqlmap, ghauri)     |
|   |   - API Discovery (arjun, x8, paramspider)     |
|   |   - Cloud tools (awscli, cloudenum, s3scanner)     |
|   |   - OSINT tools (shodan, censys, metabigor)     |
|   |   - Scope Management (bbrf)     |
|   🗸  | Create Documents/BBForge-Scripts/ directory for automation scripts  |

## References
BBForge was largely inspired by IppSec's [KaliForge](https://github.com/v4resk/KaliForge) project.
