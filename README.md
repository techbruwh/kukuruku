# 🐦 Kukuruku

> Simplifies Kubernetes workflow

Kukuruku (pronounced "koo-koo-roo-koo") is a lightweight CLI tool that makes managing multiple Kubernetes clusters effortless with interactive prompts and a persistent status bar.

## Features

**Smart Status Bar** - Always see your current cluster and namespace  
**Interactive Context Switching** - Choose clusters with fuzzy search  
**Pod Exec Made Easy** - Interactive prompts for pod execution  
**KUBECONFIG Manager** - Easily switch between kubeconfig files  
**Zero Configuration** - Works out of the box  

## Installation

### Prerequisites

```bash
# Install Oh My Zsh (for status bar)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install prerequisites via Homebrew
brew install fzf kubectl
```

### Install Kukuruku
```bash
# Add tap (first time only)
brew tap techbruwh/kukuruku

# Install
brew install kukuruku
```

### Upgrade Kukuruku
```bash
brew update
brew upgrade kukuruku
ku version
```

## Usage
All commands are available via `ku`:

Show current context
```bash
ku ctx

# Output:
# 🐦 Current Kubernetes Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Context:   production-cluster
# Namespace: default
# ✅ Connected to cluster
```

Switch Context
```bash
ku cctx
# Opens interactive fuzzy finder to select context
```

Manage KUBECONFIG
```bash
ku kconfig
# Shows available kubeconfig files in ~/.kube
# Lets you select and export KUBECONFIG
```

Execute in Pod
```bash
ku exec
# Interactive prompts for:
# - Namespace (with fuzzy search)
# - Pod name (with fuzzy search)
# - User (optional --as flag)
# - Command (default: /bin/bash)
```

Help
```bash
ku help
# Shows all available commands
```

Status Bar
After installation, prompt will show
```bash
➜  ~ ☸ my-cluster [my-namespace]
```
This updates automatically when you switch contexts!

## Configuration

Custom KUBECONFIG Location
```bash
# Add to ~/.zshrc
export KUBECONFIG=~/.kube/custom-config
```

Multiple Kubeconfigs
Kukuruku scans ~/.kube/ and lets you interactively choose:
```bash
ku kconfig
```

### Development
```bash
# Clone repository
git clone https://github.com/techbruwh/kukuruku.git
cd kukuruku

# Test locally
export KUKURUKU_HOME=$(pwd)
./bin/kukuruku help

# Create alias
alias ku="./bin/kukuruku"
```

### Uninstall
```bash
brew uninstall kukuruku

# Remove from ~/.zshrc
# Delete the line: source $(brew --prefix)/opt/kukuruku/lib/prompt.zsh
```

## License
MIT

## Contributing
Contributions welcome! Please feel free to submit a Pull Request.
