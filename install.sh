#!/bin/bash

set -e

echo "🚀 Powerlevel10k + Zsh setup voor Debian/Ubuntu"

# --- Systeemcheck ---
if ! grep -qiE "(debian|ubuntu)" /etc/os-release; then
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
  echo "⚠️  Log uit en weer in om de shell-wijziging te activeren"
fi

# --- Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "💡 Installing Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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

# --- Nerd Font: JetBrainsMono NF ---
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

echo "🔤 Installing JetBrainsMono Nerd Font..."
JETBRAINS_URL_BASE="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"
FONT_ZIP="JetBrainsMono.zip"

if [ ! -f "$FONT_DIR/JetBrainsMonoNerdFont-Regular.ttf" ]; then
  echo "Downloading JetBrainsMono Nerd Font..."
  curl -fsSL "$JETBRAINS_URL_BASE/$FONT_ZIP" -o "/tmp/$FONT_ZIP"
  unzip -o "/tmp/$FONT_ZIP" -d "$FONT_DIR"
  rm "/tmp/$FONT_ZIP"
fi

fc-cache -f "$FONT_DIR"

echo "✅ Font geïnstalleerd. Zet je terminal-font op 'JetBrainsMono Nerd Font'."

# --- Configs downloaden ---
REPO_URL="https://raw.githubusercontent.com/timvdhoorn/powerlevel10k-debian/main"

echo "⚙️ Downloading .zshrc and .p10k.zsh"

# Backup bestaande .zshrc als deze bestaat
if [ -f "$HOME/.zshrc" ]; then
  cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
  echo "💾 Backup gemaakt van bestaande .zshrc"
fi

# Backup bestaande .p10k.zsh
[ -f "$HOME/.p10k.zsh" ] && cp "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.backup.$(date +%Y%m%d_%H%M%S)"

# Download .zshrc
if curl -fsSL "$REPO_URL/.zshrc" -o "$HOME/.zshrc.tmp"; then
  mv "$HOME/.zshrc.tmp" "$HOME/.zshrc"
  echo "✅ .zshrc gedownload"
else
  echo "❌ Fout bij downloaden van .zshrc"
  exit 1
fi

if curl -fsSL "$REPO_URL/.p10k.zsh" -o "$HOME/.p10k.zsh.tmp"; then
  mv "$HOME/.p10k.zsh.tmp" "$HOME/.p10k.zsh"
  echo "✅ .p10k.zsh gedownload"
else
  echo "❌ Fout bij downloaden van .p10k.zsh"
  exit 1
fi

echo ""
echo "✅ Setup voltooid!"
echo "🔄 Start een nieuwe terminal of voer 'zsh' uit."
echo "🎨 Configureer je terminal om 'JetBrainsMono Nerd Font' als font te gebruiken."
echo ""