# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path configuration
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/bin

# Add snap binaries to path if snap is installed
if [ -d "/snap/bin" ]; then
  export PATH=$PATH:/snap/bin
fi

# Add flatpak binaries to path if flatpak is installed
if [ -d "/var/lib/flatpak/exports/bin" ]; then
  export PATH=$PATH:/var/lib/flatpak/exports/bin
fi

# Color schemes
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Colored less
export LESS_TERMCAP_mb=$'\e[1;32m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;32m'     # begin blink
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_so=$'\e[01;33m'    # begin reverse video
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline
export LESS_TERMCAP_us=$'\e[1;4;31m'   # begin underline

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 7

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  fast-syntax-highlighting
  zsh-autosuggestions
  zsh-autocomplete
  colored-man-pages
  sudo
  extract
  command-not-found
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='nano'
fi

# Set default editor
export VISUAL=nano

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# History configuration
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# Auto-correction settings
setopt CORRECT
setopt CORRECT_ALL

# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run alias.

# Common aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Directory navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias d='dirs -v'  # Show directory stack

# Colored grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Disable correction for specific commands
alias cp='nocorrect cp'
alias mv='nocorrect mv'
alias mkdir='nocorrect mkdir'

# System aliases
alias update='sudo apt update && sudo apt upgrade'
alias install='sudo apt install'
alias search='apt search'
alias remove='sudo apt remove'
alias autoremove='sudo apt autoremove'

# Directory aliases
alias zshconfig="nano ~/.zshrc"
alias ohmyzsh="nano ~/.oh-my-zsh"
alias p10kconfig="nano ~/.p10k.zsh"

# Add VS Code to path if installed via snap
if [ -d "/snap/code/current/usr/share/code" ]; then
  export PATH="$PATH:/snap/code/current/usr/share/code/bin"
fi

# Add VS Code to path if installed via .deb package
if [ -f "/usr/bin/code" ]; then
  export PATH="$PATH:/usr/bin"
fi

# Node Version Manager (if installed)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Bun (JavaScript runtime) - single clean installation
export BUN_INSTALL="$HOME/.bun"
if [ -d "$BUN_INSTALL" ]; then
  export PATH="$BUN_INSTALL/bin:$PATH"
  # Bun completions
  [ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
fi

# Cargo (Rust package manager)
if [ -f "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi

# Python user packages
if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# To customize prompt, run p10k configure or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
