# Sync dotfiles using yadm
sync-dotfiles:
    #!/usr/bin/bash
    set -euo pipefail

    DOTFILES_REPO="https://github.com/lbussell/dotfiles"

    # Ensure brew is available
    if ! command -v brew &>/dev/null; then
        echo "Error: Homebrew is not installed. Install it first:"
        echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        exit 1
    fi

    # Install yadm if not present
    if ! command -v yadm &>/dev/null; then
        echo "Installing yadm..."
        brew install yadm
    fi

    # First run: clone and bootstrap; subsequent runs: pull and show status
    if [ ! -d "$HOME/.local/share/yadm/repo.git" ]; then
        echo "Cloning dotfiles from $DOTFILES_REPO..."
        yadm clone "$DOTFILES_REPO"
        echo "Running yadm bootstrap..."
        yadm bootstrap
    else
        echo "Pulling latest dotfiles..."
        yadm pull
        echo ""
        yadm status
    fi
