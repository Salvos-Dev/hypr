# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch notify prompt_subst
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/salvos/.zshrc'

autoload -Uz compinit
autoload -Uz vcs_info
precmd() { vcs_info }
compinit
# End of lines added by compinstall

# Terminal improvements
alias ls='exa -alh'
alias grep='rg'

# Coding
alias vi='nvim'
alias py='python'
alias gcc='gcc -Wall'

# Networking
alias mac='sudo macchanger -r wlan0 && rfkill unblock wifi'
alias PdaNet='export HTTPS_PROXY="http://192.168.49.1:8000"'
alias wifi-scan='iwctl station wlan0 scan'
alias wifi-list='iwctl station wlan0 get-networks'
alias wifi-connect='iwctl station wlan0 connect'

# Git
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gs='git status'

# Exports
export SUDO_EDITOR='nvim'
export PATH="$HOME/.local/bin:$PATH"

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

pfetch
eval "$(starship init zsh)"
