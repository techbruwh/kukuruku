#!/usr/bin/env bash
# Kukuruku - Utility Functions

# Check if command exists
has_command() {
  command -v "$1" &> /dev/null
}

# Check prerequisites
check_prereqs() {
  local missing=()
  
  if ! has_command kubectl; then
    missing+=("kubectl")
  fi
  
  if ! has_command fzf; then
    missing+=("fzf")
  fi
  
  if [ ${#missing[@]} -gt 0 ]; then
    echo "❌ Missing prerequisites: ${missing[*]}"
    echo "Install with: brew install ${missing[*]}"
    return 1
  fi
  
  return 0
}

# Get current context
get_current_context() {
  kubectl config current-context 2>/dev/null || echo "none"
}

# Get current namespace
get_current_namespace() {
  local ns=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
  echo "${ns:-default}"
}

# Print colored output
print_success() {
  echo "✅ $1"
}

print_error() {
  echo "❌ $1"
}

print_info() {
  echo "ℹ️  $1"
}

print_warning() {
  echo "⚠️  $1"
}