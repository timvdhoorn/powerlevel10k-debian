#!/bin/bash

set -e

echo "🚀 Powerlevel10k + Zsh setup voor Debian-systemen"

# Check OS
if ! grep -qi "debian" /etc/os-release && ! grep -qi "ubuntu" /etc/os-release; then
  echo "❌ Alleen bedoeld voor Debian/Ubuntu systemen"
  exit 1
fi

# Vereisten installeren
echo "📦 Installing dependencies..."
sudo apt update
sudo apt install -y git curl zsh fonts-powerline

# Zsh als default shell
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "🌀 Zsh wordt ingesteld als standaard shell"
  chsh -s "$(which zsh)"
fi

# Oh My Zsh installeren
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "💡 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Powerlevel10k installeren
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "🎨 Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# Plugins installeren
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

# Configs kopiëren
echo "⚙️ Copying config files..."
cp .zshrc "$HOME/.zshrc"
cp .p10k.zsh "$HOME/.p10k.zsh"

echo "✅ Klaar! Start een nieuwe shell of voer 'zsh' uit."