#!/usr/bin/env zsh
# Kukuruku - Prompt Integration

# Function to display k8s context and namespace in prompt
_kukuruku_prompt() {
  if ! command -v kubectl &> /dev/null; then
    return
  fi
  
  local context=$(kubectl config current-context 2>/dev/null)
  if [ -z "$context" ]; then
    return
  fi
  
  local namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
  namespace="${namespace:-default}"
  
  # Color code by namespace type
  local color="cyan"  # default color
  if [[ "$namespace" == *"prod"* ]]; then
    color="red"
  elif [[ "$namespace" == *"stage"* ]] || [[ "$namespace" == *"staging"* ]]; then
    color="yellow"
  elif [[ "$namespace" == *"dev"* ]]; then
    color="green"
  elif [[ "$namespace" == *"alpha"* ]]; then
    color="magenta"
  elif [[ "$namespace" == "default" ]]; then
    color="blue"
  fi
  
  echo "[☸ %{$fg[$color]%}$namespace%{$reset_color%}] "
}

# Add to left prompt (prepend to existing PROMPT)
PROMPT='$(_kukuruku_prompt)'"${PROMPT}"