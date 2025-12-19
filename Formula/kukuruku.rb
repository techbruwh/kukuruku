class Kukuruku < Formula
    desc "🐦 Kubernetes CLI helper - Your k8s companion"
    homepage "https://github.com/YOUR_USERNAME/kukuruku"
    url "https://github.com/YOUR_USERNAME/kukuruku/archive/v1.0.0.tar.gz"
    sha256 "YOUR_SHA256_HERE"
    license "MIT"
  
    depends_on "kubectl"
    depends_on "fzf"
  
    def install
      # Install main script
      bin.install "bin/kukuruku"
      
      # Create ku symlink
      bin.install_symlink bin/"kukuruku" => "ku"
      
      # Install libraries
      libexec.install "lib"
      
      # Install zsh completions
      zsh_completion.install "completions/_kukuruku"
      
      # Create home directory structure
      (prefix/"lib").install Dir["lib/*"]
    end
  
    def caveats
      <<~EOS
        🐦 Kukuruku installed successfully!
        
        To enable the status bar in your shell:
        
        Add this to your ~/.zshrc:
          source #{opt_prefix}/lib/prompt.zsh
        
        Then reload your shell:
          source ~/.zshrc
        
        Usage:
          ku help       # Show all commands
          ku ctx        # Show current context
          ku cctx       # Choose context
          ku exec       # Interactive pod exec
        
        Prerequisites:
          - oh-my-zsh (for status bar)
          - kubectl (already installed)
          - fzf (already installed)
      EOS
    end
  
    test do
      system "#{bin}/kukuruku", "version"
    end
  end