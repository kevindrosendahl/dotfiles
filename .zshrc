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
