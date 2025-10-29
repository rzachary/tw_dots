#  ______ _      ______
#  | | \ | |    |___  /
#  | |_/ / |       / /    - Rickey Zachary
#  |    /| |      / /     - website: https://rickeyzachary.com
#  | |\ \| |____./ /___   - twitter: zachary_rickey | github: rzachary (https://github.com/rzachary)
#  |_| \_\_____/\_____/
#
#
# A config for Z Shell.


source ~/.config/zsh/.zprofile #.zshenv stuff
export TERM="xterm-256color"

# Optimized History Configuration
export HISTFILE=~/.config/zsh/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
setopt HIST_IGNORE_DUPS     # Don't save duplicate commands
setopt HIST_IGNORE_SPACE    # Don't save commands starting with space
setopt SHARE_HISTORY        # Share history between sessions
setopt HIST_VERIFY          # Show command before executing from history
setopt HIST_EXPIRE_DUPS_FIRST # Remove duplicates first when trimming history

eval "$(/opt/homebrew/bin/brew shellenv)"


# Z Shell Configs with error checking
ZSH_AUTOSUGGESTIONS_PATH="$(brew --prefix)/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_SYNTAX_HIGHLIGHTING_PATH="$(brew --prefix)/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

if [[ -f "$ZSH_AUTOSUGGESTIONS_PATH" ]]; then
    source "$ZSH_AUTOSUGGESTIONS_PATH"
else
    echo "Warning: zsh-autosuggestions not found at $ZSH_AUTOSUGGESTIONS_PATH"
fi

if [[ -f "$ZSH_SYNTAX_HIGHLIGHTING_PATH" ]]; then
    source "$ZSH_SYNTAX_HIGHLIGHTING_PATH"
else
    echo "Warning: zsh-syntax-highlighting not found at $ZSH_SYNTAX_HIGHLIGHTING_PATH"
fi


# AWS CLI Sourcing
#source "$(brew --prefix)/opt/awscli@2/

# Google Cloud Sourcing
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"



# Powerlevel10k Theme
# source "$(brew --prefix)/powerlevel10k/powerlevel10k.zsh-theme"

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

#  - PATH -
# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.config/zsh/.{path,exports,aliases,functions,extra}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

## CUSTOM PATHS
GEM_HOME="$(ruby -e 'puts Gem.user_dir')"

export PATH="$PATH:$GEM_HOME/bin"

### - GO LANG DEV (GOPATH set in .zprofile)
export GOBIN="$HOME/.local/go/bin"

## Consolidated PATH Management
# Add local directories to PATH if they exist
for dir in "$HOME/.local/bin" "$HOME/.bin" "$HOME/Applications" "$HOME/.local/go/bin"; do
    if [ -d "$dir" ]; then
        case ":$PATH:" in
            *":$dir:"*) ;; # Already in PATH
            *) PATH="$dir:$PATH" ;;
        esac
    fi
done

# Source local environment if available
[[ -f "$HOME/.local/share/../bin/env" ]] && . "$HOME/.local/share/../bin/env"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Python and other tool paths
export PATH="$PATH:/Users/rickeyzachary/Library/Python/3.11/bin"
export PATH="$PATH:/opt/homebrew/opt/libpq/bin"
