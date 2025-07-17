# Instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG

Perfect — dan voeg ik font-installatie toe aan het script. We gebruiken **MesloLGS NF**, de aanbevolen Nerd Font voor Powerlevel10k.

---

## ✅ Wat het script nu extra doet

- Downloadt 4 MesloLGS NF `.ttf`-fonts
- Installeert ze in `~/.local/share/fonts`
- Update de font-cache (alleen nodig op Linux)

---

## 📦 **Volledig script met fonts: `install.sh`**

```bash
#!/bin/bash

set -e

echo "🚀 Powerlevel10k + Zsh setup voor Debian/Ubuntu"

# Check OS
if ! grep -qi "debian" /etc/os-release && ! grep -qi "ubuntu" /etc/os-release; then
  echo "❌ Alleen bedoeld voor Debian/Ubuntu systemen"
  exit 1
fi

# ----------- Stap 1: Basis installatie -----------

echo "📦 Installing dependencies..."
sudo apt update
sudo apt install -y git curl zsh unzip fontconfig

# Zsh als standaard shell
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "🌀 Zsh wordt ingesteld als standaard shell"
  chsh -s "$(which zsh)"
fi

# ----------- Stap 2: Oh My Zsh + Powerlevel10k -----------

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "💡 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "🎨 Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# ----------- Stap 3: Plugins -----------

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

# ----------- Stap 4: Fonts installeren (MesloLGS NF) -----------

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

echo "✅ Fonts geïnstalleerd. Vergeet niet de terminal-font in te stellen op 'MesloLGS NF'!"

# ----------- Stap 5: Configs kopiëren -----------

echo "⚙️ Copying config files..."
cp .zshrc "$HOME/.zshrc"
cp .p10k.zsh "$HOME/.p10k.zsh"

echo "✅ Klaar! Start een nieuwe shell of voer 'zsh' uit."