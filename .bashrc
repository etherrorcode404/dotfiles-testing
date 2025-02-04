# Exit if not an interactive shell
[[ $- != *i* ]] && return

# History settings
HISTCONTROL=ignoreboth
shopt -s histappend

# Resize terminal dynamically
shopt -s checkwinsize

# Enable colored prompt
PS1='\[\033[01;32m\]\u@\h:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Enable color support
if command -v dircolors &>/dev/null; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# Load Rust (Cargo)
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Set PATH (optimized single export)
export PATH="$HOME/.spicetify:$HOME/.npm-global/bin:$HOME/go/bin:$PATH"
