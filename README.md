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