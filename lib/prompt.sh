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
  
  echo " ☸ $context [$namespace]"
}

# Add to right prompt
RPROMPT='%{$fg[cyan]%}$(_kukuruku_prompt)%{$reset_color%}'