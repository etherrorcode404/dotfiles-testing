if status is-interactive
    set fish_greeting
    export PATH="$HOME/.cargo/bin:$PATH"
    alias ls='exa --long --color auto --icons --sort=type'
    alias la='exa -a --long --color auto --icons --sort=type'
end
