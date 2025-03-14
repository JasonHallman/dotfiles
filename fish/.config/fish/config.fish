set -gx EDITOR nvim
set -gx VISUAL nvim
# set -gx ZELLIJ_AUTO_ATTACH true

if status is-interactive
    # Commands to run in interactive sessions can go here
    # eval (zellij setup --generate-auto-start fish | string collect)
end

fish_vi_key_bindings

# Make autocompletion work in vi mode
bind -M insert \cE end-of-line     # Bind Ctrl-E to EOL

fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/go/bin"
fish_add_path /usr/local/go/bin
fish_add_path /opt/homebrew/bin

alias kubectl="minikube kubectl --"
alias vi="nvim"
alias gs="git status"
alias gd="git diff"
alias gds="git diff --staged"
alias gl="git log"
alias ga="git add"
alias config="nvim $HOME/.config/fish/config.fish ; source $HOME/.config/fish/config.fish"
alias ls="exa"
alias ll="exa -l"
alias la="exa -la"
alias uvi="uv run nvim"
alias uvr="uv run"

zoxide init fish | source

eval "$(direnv hook fish)"

set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
pyenv init - fish | source
