#!/bin/bash

cat << 'EOF'
      |\      _,,,---,,_
ZZZzz /,`.-'`'    -.  ;-;;,_
     |,4-  ) )-,_. ,\ (  `'-'
    '---''(_/--'  `-'\_)  - HOLA! -
EOF


# --- Configuration Variables ---
ZSHRC_SOURCE="$HOME/.dotfiles/zsh/zshrc.j2"
TMUXCONF_SOURCE="$HOME/.dotfiles/tmux/tmux.j2"

OHMYZSH_DIR="$HOME/.oh-my-zsh"
PLUGINS_CUSTOM_PATH="$OHMYZSH_DIR/custom/plugins"
THEMES_CUSTOM_PATH="$OHMYZSH_DIR/custom/themes"


# Function to handle script errors and exit cleanly
cleanup_and_exit() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        echo "--------------------------------------------------"
        echo "FAILURE: Script failed at step: $1"
        echo "Error Code: $exit_code"
        echo "Please check the error messages above."
    fi
}

# Trap function to call cleanup on any non-zero exit
trap 'cleanup_and_exit "$BASH_COMMAND"' ERR

echo "=============================================="
echo "Starting Development Environment Setup"
echo "=============================================="

# 1. Remove previous conf (ansible.builtin.file: state: absent)
echo -e "\n[STEP 1/7] Cleaning up existing configuration files..."
rm -f "$HOME/.zshrc"
rm -f "$HOME/.tmux.conf"
echo "   SUCCESS: Removed ~/.zshrc and ~/.tmux.conf (if they existed)."

# 2. Install zsh configuration (ansible.builtin.file: state: link)
echo -e "\n[STEP 2/7] Setting up Zsh configuration link..."
if [ ! -f "$ZSHRC_SOURCE" ]; then
    echo "  ERROR: Source Zsh file not found at $ZSHRC_SOURCE. Skipping."
else
    # Ensure the destination directory exists before linking
    mkdir -p "$(dirname ~/.zshrc)"
    ln -s "$ZSHRC_SOURCE" "$HOME/.zshrc"
    echo "   SUCCESS: Linked $ZSHRC_SOURCE to ~/.zshrc"
fi

# 3. Setup tmux configuration (ansible.builtin.file: state: link)
echo -e "\n[STEP 3/7] Setting up Tmux configuration link..."
if [ ! -f "$TMUXCONF_SOURCE" ]; then
    echo "  ERROR: Source Tmux file not found at $TMUXCONF_SOURCE. Skipping."
else
    mkdir -p "$(dirname ~/.tmux.conf)"
    ln -s "$TMUXCONF_SOURCE" "$HOME/.tmux.conf"
    echo "   SUCCESS: Linked $TMUXCONF_SOURCE to ~/.tmux.conf"
fi

# 4. Clone Oh My Zsh (ansible.builtin.git)
echo -e "\n[STEP 4/7] Cloning Oh My Zsh..."
if [ -d "$OHMYZSH_DIR/.git" ]; then
    echo "   WARNING: $OHMYZSH_DIR already exists. Attempting to re-clone/pull."
else
    mkdir -p "$HOME"
fi

# Use git clone, checking if the directory needs cleaning first for idempotency
if [ -d "$OHMYZSH_DIR" ]; then
    rm -rf "$OHMYZSH_DIR"
fi
git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
echo "   SUCCESS: Oh My Zsh cloned successfully."


# 5. Clone zsh-autosuggestions plugin (ansible.builtin.git)
PLUGIN_AUTO_SUG="$PLUGINS_CUSTOM_PATH/zsh-autosuggestions"
echo -e "\n[STEP 5/7] Cloning zsh-autosuggestions plugin..."
if [ ! -d "$PLUGINS_CUSTOM_PATH" ]; then
    mkdir -p "$PLUGINS_CUSTOM_PATH"
fi

# Check if the repo already exists and handle it gracefully
if [ -d "$PLUGIN_AUTO_SUG/.git" ]; then
    echo "   WARNING: autosuggestions plugin already cloned. Pulling updates instead."
    (cd "$PLUGIN_AUTO_SUG" && git pull) || echo "     Could not pull updates for auto-suggestions."
else
    git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGIN_AUTO_SUG"
fi

# 6. Clone zsh-syntax-highlighting plugin (ansible.builtin.git)
PLUGIN_SYNTAX="$PLUGINS_CUSTOM_PATH/zsh-syntax-highlighting"
echo -e "\n[STEP 6/7] Cloning zsh-syntax-highlighting plugin..."
if [ ! -d "$PLUGIN_SYNTAX/.git" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGIN_SYNTAX"
else
    echo "   WARNING: syntax-highlighting plugin already cloned. Pulling updates instead."
    (cd "$PLUGIN_SYNTAX" && git pull) || echo "     Could not pull updates for syntax-highlighting."
fi

# 7. Clone zsh theme (ansible.builtin.git)
THEME_A_PHRODITE="$THEMES_CUSTOM_PATH/aphrodite"
echo -e "\n[STEP 7/7] Cloning Zsh theme 'aphrodite'..."
if [ ! -d "$THEMES_CUSTOM_PATH" ]; then
    mkdir -p "$THEMES_CUSTOM_PATH"
fi

if [ -d "$THEME_A_PHRODITE/.git" ]; then
     echo "   WARNING: aphrodite theme already cloned. Pulling updates instead."
     (cd "$THEME_A_PHRODITE" && git pull) || echo "     Could not pull updates for aphrodite."
else
    git clone https://github.com/win0err/aphrodite-terminal-theme "$THEME_A_PHRODITE"
fi


echo -e "\n=============================================="
echo "Setup Complete!"
echo "Remember to restart your terminal or run 'source ~/.zshrc' to apply changes."
echo "=============================================="