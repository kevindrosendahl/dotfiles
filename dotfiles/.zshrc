
export ZSH=~/.zsh

# Data directory
[[ -d $ZSH/data ]] || mkdir $ZSH/data

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

# Sanity cleanup of PATH, which otherwise can grow duplicate entries (making
# troubleshooting harder than it needs to be)
typeset -U PATH

export PATH="$HOME/.poetry/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

[ -z "$TMUX"  ] && { tmux attach || tmux new-session }

fpath[1,0]=$HOME/.zsh/completion

# The following lines were added by compinstall
zstyle :compinstall filename '/Users/kevin.rosendahl/.zshrc'

autoload -Uz compinit
compinit 
# End of lines added by compinstall

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

[ -s "/Users/kevin.rosendahl/.jabba/jabba.sh" ] && source "/Users/kevin.rosendahl/.jabba/jabba.sh"
