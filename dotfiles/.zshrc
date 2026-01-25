
export ZSH="$HOME/.zsh"

# Data directory
[[ -d "$ZSH/data" ]] || mkdir -p "$ZSH/data"
[[ -d "$ZSH/cache" ]] || mkdir -p "$ZSH/cache"

typeset -a DOTFILES
DOTFILES=(
    options
    exports
    completion-local
    aliases
    platform
    history
    prompt
    local
    syntax-highlighting
    fzf
    rust
    golang
)
for file in $DOTFILES; do
    file=$ZSH/$file
    [[ -f $file ]] && source $file
done

export PATH="$HOME/.poetry/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

if [[ -z "${TMUX-}" && -n "${PS1-}" && -t 1 ]]; then
  tmux attach || tmux new-session
fi

fpath[1,0]=$HOME/.zsh/completion

# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

autoload -Uz compinit
compinit 
# End of lines added by compinstall

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

[ -s "$HOME/.jabba/jabba.sh" ] && source "$HOME/.jabba/jabba.sh"

# Sanity cleanup of PATH, which otherwise can grow duplicate entries (making
# troubleshooting harder than it needs to be)
typeset -U PATH
