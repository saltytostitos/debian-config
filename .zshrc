
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
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

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

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
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
#

# MY PERSONAL SHIT

lt() {
  if [[ -n $* ]]; then
    cd $*
  fi
  eza -a1lT -L 1 --git --no-user --no-permissions --no-time --icons=auto --group-directories-first --classify=always
}
alias ls="eza -a1lT -L 1 --git --no-user --no-permissions --no-time --icons=auto --group-directories-first --classify=always"
alias cat="bat"
alias fz="fzf --preview 'batcat {}'"


#PACKAGE MANAGERS
alias taze="pnpx taze@latest --all --force --sort time-desc latest"
alias pi="pnpx node-modules-inspector@latest"


# ZED
alias c="open $1 -a \"Zed\""
alias code="open $1 -a \"Zed\""
alias ws="open $1 -a \"Zed\""
# WINDSURF
alias c="open $1 -a \"Windsurf\""
alias code="open $1 -a \"Windsurf\""
alias ws="open $1 -a \"Windsurf\""

# DEV SHORTCUTS
alias dev="nr dev"
alias build="nr build"
alias deploy="nr deploy"
alias cleanup="nr cleanup"
alias preview="nr preview"
alias dev-tunnel="cloudflared tunnel run dev-server"

multipull() {
  find . -mindepth 1 -maxdepth 1 -type d -print -exec git -C {} pull \;
}
multipush() {
  find . -mindepth 1 -maxdepth 1 -type d -print -exec git -C {} push \;
}
multicheck() {
  find . -mindepth 1 -maxdepth 1 -type d -print0 | while IFS= read -r -d '' dir; do
    if [[ -d "$dir/.git" ]]; then
      echo -e "\033[1;31mRepo: \033[1;34m$(basename "$dir")\033[0m"
      git -C "$dir" status --short
      echo
    fi
  done
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="/var/lib/flatpak:/opt/nvim-linux64/bin:/home/sean/.local/bin/:$PATH"
# source ~/powerlevel10k/powerlevel10k.zsh-theme

#eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Yazi need this
export EDITOR=nvim
# Yazi y shorthand - will open Yazi and cd current directory when closing
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	fm -f -- "$tmp"
}

#NODE
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/node@22/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/node@22/include"
# Added by Windsurf
export PATH="/Users/saltytostitos/.codeium/windsurf/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/saltytostitos/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/Users/saltytostitos/.bun/_bun" ] && source "/Users/saltytostitos/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Added by Windsurf
export PATH="/Users/saltytostitos/.codeium/windsurf/bin:$PATH"
# opencode
export PATH=/Users/saltytostitos/.opencode/bin:$PATH
