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
export PATH=~/.local/bin:$PATH #PTsh path
export TERM="xterm-256color"
export HISTFILE=~/.config/zsh/.zsh_history



# Z Shell Configs
source "$(brew --prefix)/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$(brew --prefix)/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"


# AWS CLI Sourcing
#source "$(brew --prefix)/opt/awscli@2/

# Google Cloud Sourcing
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"



# Powerlevel10k Theme
source "$(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme"

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

### - GO LANG DEV

export GOBIN="$HOME/.local/go/bin"
export GOPATH="$HOME/.local/go"

export PATH="$PATH:$HOME/.local/go/bin"

## PATH SET
if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/Applications" ] ;
  then PATH="$HOME/Applications:$PATH"
fi

