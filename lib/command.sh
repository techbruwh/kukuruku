#!/usr/bin/env bash
# Kukuruku - Command Implementations

# Help command
cmd_help() {
  cat << 'EOF'
🐦 Kukuruku - Your Kubernetes CLI Companion

Usage: ku <command> [options]

Commands:
  help            Show this help message
  version         Show kukuruku version
  ctx             Show current context and namespace
  cctx            Choose context using fuzzy search
  kconfig         Manage KUBECONFIG file
  exec            Execute command in a pod (interactive)

Examples:
  ku ctx                    # Show current cluster and namespace
  ku cctx                   # Switch contexts interactively
  ku kconfig                # Manage kubeconfig
  ku exec                   # Interactive pod exec

Prerequisites:
  - kubectl
  - fzf (fuzzy finder)
  - oh-my-zsh (for status bar)

Configuration:
  Status bar is automatically added to your shell prompt.
  Current context and namespace appear as: ☸ cluster [namespace]

Learn more: https://github.com/YOUR_USERNAME/kukuruku
EOF
}

# Show current context
cmd_ctx() {
  check_prereqs || return 1
  
  local context=$(get_current_context)
  local namespace=$(get_current_namespace)
  
  echo "🐦 Current Kubernetes Configuration"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Context:   $context"
  echo "Namespace: $namespace"
  echo ""
  
  # Show cluster info if connected
  if kubectl cluster-info &>/dev/null; then
    print_success "Connected to cluster"
    kubectl cluster-info | grep -E "(master|control plane)" | head -1
  else
    print_error "Not connected to cluster"
  fi
}

# Choose context interactively
cmd_cctx() {
  check_prereqs || return 1
  
  print_info "Select a context using fzf (type to filter, Enter to select)"
  echo ""
  
  local contexts=$(kubectl config get-contexts -o name 2>/dev/null)
  
  if [ -z "$contexts" ]; then
    print_error "No contexts found in kubeconfig"
    return 1
  fi
  
  local selected=$(echo "$contexts" | fzf --prompt="🐦 Select context: " --height=40% --border --preview="kubectl config view -o jsonpath='{.contexts[?(@.name==\"{}\")]}' 2>/dev/null | grep -v '^$' || echo 'No details available'")
  
  if [ -z "$selected" ]; then
    print_warning "No context selected"
    return 0
  fi
  
  kubectl config use-context "$selected"
  print_success "Switched to: $selected"
  
  # Show namespace
  local ns=$(get_current_namespace)
  print_info "Namespace: $ns"
}

# Manage KUBECONFIG
cmd_kconfig() {
  print_info "Current KUBECONFIG: ${KUBECONFIG:-$HOME/.kube/config}"
  echo ""
  
  # Scan ~/.kube directory
  local kube_dir="$HOME/.kube"
  
  if [ ! -d "$kube_dir" ]; then
    print_error "~/.kube directory not found"
    return 1
  fi
  
  echo "📁 Available kubeconfig files in ~/.kube:"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  
  local configs=()
  while IFS= read -r file; do
    local filename=$(basename "$file")
    configs+=("$filename")
    
    # Count contexts in file
    local count=$(KUBECONFIG="$file" kubectl config get-contexts -o name 2>/dev/null | wc -l | tr -d ' ')
    
    echo "  - $filename ($count contexts)"
  done < <(find "$kube_dir" -maxdepth 1 -type f ! -name "*.lock" ! -name "cache" ! -name "http-cache")
  
  echo ""
  
  if [ ${#configs[@]} -eq 0 ]; then
    print_error "No kubeconfig files found"
    return 1
  fi
  
  # Ask if user wants to change KUBECONFIG
  read -p "❓ Do you want to set a different KUBECONFIG? (y/n): " -n 1 -r
  echo ""
  
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "Keeping current KUBECONFIG"
    return 0
  fi
  
  # Let user select with fzf
  local selected=$(printf "%s\n" "${configs[@]}" | fzf --prompt="🐦 Select kubeconfig: " --height=40% --border)
  
  if [ -z "$selected" ]; then
    print_warning "No file selected"
    return 0
  fi
  
  local selected_path="$kube_dir/$selected"
  
  # Show export command
  echo ""
  print_success "Selected: $selected"
  echo ""
  echo "Add this to your ~/.zshrc:"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "export KUBECONFIG=$selected_path"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  read -p "❓ Apply for current session? (y/n): " -n 1 -r
  echo ""
  
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    export KUBECONFIG="$selected_path"
    print_success "KUBECONFIG set to: $selected_path"
    
    # Show contexts in selected config
    echo ""
    print_info "Available contexts:"
    kubectl config get-contexts -o name
  fi
}

# Interactive pod exec
cmd_exec() {
  check_prereqs || return 1
  
  echo "🐦 Kukuruku Interactive Pod Exec"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  # Current namespace
  local current_ns=$(get_current_namespace)
  print_info "Current namespace: $current_ns"
  
  # Ask for namespace
  read -p "📦 Namespace (press Enter for '$current_ns'): " namespace
  namespace="${namespace:-$current_ns}"
  
  # Ask for pod name
  echo ""
  print_info "Fetching pods in namespace '$namespace'..."
  
  local pods=$(kubectl get pods -n "$namespace" -o name 2>/dev/null | sed 's|pod/||')
  
  if [ -z "$pods" ]; then
    print_error "No pods found in namespace '$namespace'"
    return 1
  fi
  
  local pod=$(echo "$pods" | fzf --prompt="🐦 Select pod: " --height=40% --border --preview="kubectl get pod {} -n $namespace -o wide 2>/dev/null")
  
  if [ -z "$pod" ]; then
    print_warning "No pod selected"
    return 0
  fi
  
  # Ask for --as flag (optional)
  echo ""
  read -p "👤 Run as user (optional, e.g., 'namespace-admin'): " as_user
  
  # Ask for command
  echo ""
  read -p "💻 Command to run (default: /bin/bash): " command
  command="${command:-/bin/bash}"
  
  # Build kubectl command
  local kubectl_cmd="kubectl exec -n $namespace -it $pod"
  
  if [ -n "$as_user" ]; then
    kubectl_cmd="$kubectl_cmd --as=$as_user"
  fi
  
  kubectl_cmd="$kubectl_cmd -- $command"
  
  # Show command and confirm
  echo ""
  echo "📝 Command to execute:"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "$kubectl_cmd"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  read -p "❓ Execute? (y/n): " -n 1 -r
  echo ""
  
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Cancelled"
    return 0
  fi
  
  # Execute
  echo ""
  eval "$kubectl_cmd"
}