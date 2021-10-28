[ -z "$TMUX"  ] && { tmux attach || tmux new-session }

export ZSH=~/.zsh

# Data directory
[[ -d $ZSH/data ]] || mkdir $ZSH/data

typeset -a DOTFILES
DOTFILES=(
    options
    exports
    completion
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
