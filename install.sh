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

# --- Nerd Font: MesloLGS NF ---
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

echo "🔤 Installing MesloLGS Nerd Fonts..."
MESLO_URL_BASE="https://github.com/romkatv/powerlevel10k-media/raw/master"
fonts=(
  "MesloLGS%20NF%20Regular.ttf"
  "MesloLGS%20NF%20Bold.ttf"
  "MesloLGS%20NF%20Italic.ttf"
  "MesloLGS%20NF%20Bold%20Italic.ttf"
)

for font in "${fonts[@]}"; do
  # URL-decode de bestandsnaam voor lokale opslag
  local_name=$(echo "$font" | sed 's/%20/ /g')
  if [ ! -f "$FONT_DIR/$local_name" ]; then
    echo "Downloading: $local_name"
    curl -fsSL "$MESLO_URL_BASE/$font" -o "$FONT_DIR/$local_name"
  fi
done

fc-cache -f "$FONT_DIR"

echo "✅ Fonts geïnstalleerd. Zet je terminal-font op 'MesloLGS NF'."

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
echo "🎨 Configureer je terminal om 'MesloLGS NF' als font te gebruiken."
echo ""