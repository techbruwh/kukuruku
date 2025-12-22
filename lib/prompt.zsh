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
  
  # Smart abbreviation: extract key parts
  local short_context="$context"
  if [[ "$context" == *"/"* ]]; then
    short_context="${context##*/}"  # Get everything after last /
  elif [[ "$context" == *":"* ]]; then
    short_context="${context##*:}"  # Get everything after last :
  fi
  
  echo " ☸ $short_context"
}

# Add to right prompt (one line with home directory)
RPROMPT='%{$fg[cyan]%}$(_kukuruku_prompt)%{$reset_color%}'