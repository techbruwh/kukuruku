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
  
  # Smart abbreviation: extract key parts
  # Example: "arn:aws:eks:us-west-2:123456:cluster/production-cluster" -> "production-cluster"
  local short_context="$context"
  if [[ "$context" == *"/"* ]]; then
    short_context="${context##*/}"  # Get everything after last /
  elif [[ "$context" == *":"* ]]; then
    short_context="${context##*:}"  # Get everything after last :
  fi
  
  echo " ☸ $short_context [$namespace]"
}

# Add to right prompt
RPROMPT='%{$fg[cyan]%}$(_kukuruku_prompt)%{$reset_color%}'