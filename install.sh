#!/bin/bash

set -e

echo "🚀 Powerlevel10k + Zsh setup voor Debian/Ubuntu"

# --- Systeemcheck ---
if ! grep -qi "debian" /etc/os-release && ! grep -qi "ubuntu" /etc/os-release; then
  echo "❌ Alleen bedoeld voor Debian/Ubuntu systemen"
  exit 1
fi

# --- Vereisten ---
echo "📦 Installing dependencies..."
sudo apt update
sudo apt install -y git curl zsh unzip fontconfig

# --- Zsh als standaard shell ---
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "🌀 Zsh wordt ingesteld als standaard shell"
  chsh -s "$(which zsh)"
fi

# --- Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "💡 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# --- Powerlevel10k ---
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "🎨 Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# --- Plugins ---
declare -A plugins=(
  [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
  [zsh-autocomplete]="https://github.com/marlonrichert/zsh-autocomplete"
  [fast-syntax-highlighting]="https://github.com/zdharma-continuum/fast-syntax-highlighting"
  [zsh-history-substring-search]="https://github.com/zsh-users/zsh-history-substring-search"
)

for name in "${!plugins[@]}"; do
  dest="$ZSH_CUSTOM/plugins/$name"
  if [ ! -d "$dest" ]; then
    echo "🔌 Installing plugin: $name"
    git clone --depth=1 "${plugins[$name]}" "$dest"
  fi
done

# --- Nerd Font: MesloLGS NF ---
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

echo "🔤 Installing MesloLGS Nerd Fonts..."
MESLO_URL_BASE="https://github.com/romkatv/powerlevel10k-media/raw/master"
fonts=(
  "MesloLGS NF Regular.ttf"
  "MesloLGS NF Bold.ttf"
  "MesloLGS NF Italic.ttf"
  "MesloLGS NF Bold Italic.ttf"
)

for font in "${fonts[@]}"; do
  curl -fsSL "$MESLO_URL_BASE/$font" -o "$FONT_DIR/$font"
done

fc-cache -f "$FONT_DIR"

echo "✅ Fonts geïnstalleerd. Zet je terminal-font op 'MesloLGS NF'."

# --- Configs downloaden ---
REPO_URL="https://raw.githubusercontent.com/timvdhoorn/powerlevel10k-debian/main"

echo "⚙️ Downloading .zshrc and .p10k.zsh"
curl -fsSL "$REPO_URL/.zshrc" -o "$HOME/.zshrc"
curl -fsSL "$REPO_URL/.p10k.zsh" -o "$HOME/.p10k.zsh"

echo "✅ Setup voltooid. Start een nieuwe terminal of voer 'zsh' uit."