#!/usr/bin/env bash

# Check to make sure Xcode is installed via this prompt

echo 'Have you installed the Xcode '
echo 'If not exit using CMD+C, and install with:'
echo 'xcode-select --install'

read answer

# Installs Homebrew and some of the common dependencies needed/desired for software development

# Ask for the administrator password upfront
sudo -v

# Check for Homebrew and install it if missing
if test ! $(which brew)
then
  echo "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed
# Install Bash 4.
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`.
brew install zsh
brew install zsh-autosuggestions
brew install zsh-completions
brew install zsh-syntax-highlighting


# Install some more Lanaguages - probably need to add in Ruby, Elixr, and a couple of other languages
brew install go
brew install python
brew install typescript

brew install protobuf

# Install `wget` with IRI support.
brew install wget

# Install GnuPG to enable PGP-signing commits.
brew install gnupg

# Install more recent versions of some macOS tools.
brew install exa
brew install fastfetch
brew install fzf
brew install grep
brew install htop
brew install neovim
brew install openssh
brew install pandoc
brew install tmux

# Install some CTF tools; see https://github.com/ctfs/write-ups.
brew install aircrack-ng
brew install bfg
brew install binutils
brew install binwalk
brew install cifer
brew install dex2jar
brew install dns2tcp
brew install fcrackzip
brew install foremost
brew install hashpump
brew install hydra
brew install john
brew install knock
brew install netpbm
brew install nmap
brew install pngcheck
brew install socat
brew install sqlmap
brew install tcpflow
brew install tcpreplay
brew install tcptrace
brew install ucspi-tcp
brew install xpdf
brew install xz
brew install ack
brew install git
brew install git-lfs
brew install graphviz
brew install imagemagick --with-webp
brew install lua
brew install lynx
brew install p7zip
brew install pigz
brew install pv
brew install rename
brew install rlwrap
brew install ssh-copy-id
brew install tree
brew install vbindiff
brew install zopfli
brew install tokei

# Install Caskroom
brew tap homebrew/cask
brew install brew-cask
brew tap homebrew/cask-fonts
brew tap homebrew/versions

# Install AWS cli
brew install awscli

# Install Azure CLI
brew install azure-cli

# install Gcloud CLI
brew install --cask gcloud-cli

brew install romkatv/powerlevel10k/powerlevel10k

# Install Applications
brew install --cask 1password
brew install --cask nikitabobko/tap/aerospace
brew install --cask alfred
brew install --cask bartender
brew install --cask bruno
brew install --cask google-chrome
brew install --cask dash
brew install --cask ghostty
brew install --cask gimp
brew install --cask lm-studio
brew install --cask leapp
brew install --cask macdown
brew install --cask microsoft-word
brew install --cask microsoft-excel
brew install --cask microsoft-powerpoint
brew install --cask microsoft-teams
brew install --cask shottr
brew install --cask tableplus
brew install --cask transmit
brew install --cask visual-studio-code
brew install --cask vlc
brew install --cask zed
brew install --cask zen


brew install --cask font-fira-code-nerd-font
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-roboto-mono-nerd-font
brew install --cask font-source-code-pro-nerd-font
brew install --cask font-ubuntu-nerd-font
brew install --cask font-ubuntu-mono-nerd-font


brew update
brew upgrade

#Installing Vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo 'Run ":PlugInstall" to install Vim Plugins, and then exit' >> ~/vimPlug
vim ~/vimPlug #Opening Vim
rm ~/vimPlug #Removing vimPlug

#<----------------Changing MacOS Specific Preferences-------------------->
defaults write com.knollsoft.Rectangle gapSize -float 10
defaults write com.knollsoft.Rectangle almostMaximizeHeight -float .98
defaults write com.knollsoft.Rectangle almostMaximizeWidth -float .98

defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES #Show a path bar in the finder that shows the exact location
defaults write com.apple.finder ShowPathbar -bool true #Adds the path bar to the bottom of the finder
defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false #Stop the automatic save to iCloud thing
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false #Remove the Warning Before Changing a File Extension in OSX
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv" #Changes Default Finder View to List
defaults write com.apple.finder WarnOnEmptyTrash -bool false #Removes Warning Before Emptying Trash
defaults write com.apple.finder DisableAllAnimations -bool true #Disable Finder Animations
defaults write com.apple.finder NewWindowTargetPath -string "file:///Users/$uname/" #Changes default finder location to ~
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false #Removes External Drives on Desktop
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false #Removes Internal Drives on Desktop
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false #Removes Mounted Servers on Desktop
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false #Removes Removable Media on Desktop
defaults write com.apple.finder _FXSortFoldersFirst -bool true #Moves Folders to top When Sorting Alphabetically in Finder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf" #Changes Default Finder Search to Current Folder Only
defaults write com.apple.finder FXICloudDriveDesktop -bool NO #Doesn't Sync Desktop to iCloud
defaults write com.apple.finder SidebarShowingiCloudDesktop -bool NO #Removes iCloud Desktop from Finder Sidebar
defaults write com.apple.finder ShowStatusBar -bool YES #Shows Status Bar in Finder
defaults write com.apple.finder SidebariCloudDriveSectionDisclosedState -bool NO #Makes Sure iCloud Drive is Showing in Finder Sidebar
defaults write com.apple.finder FXArrangeGroupViewBy -string "Name" #Arranges Finder by Name By Default

defaults write com.apple.dock autohide-time-modifier -int 0 #Sets Dock Autohide Time to O Seconds
defaults write com.apple.dock autohide -bool true #Turns Dock Autohide ON
defaults write com.apple.dock magnification -bool  NO #Turns of Dock Magnification
defaults write com.apple.dock orientation -string  left #Moving the Dock to the left Side of the Screen
defaults write com.apple.dock minimize-to-application -bool YES #Minimizing Applications to Their Respective Application Icon
defaults write com.apple.dock showhidden -string  YES #Shows Hidden Applications in Dock
defaults write com.apple.dock expose-animation-duration -string 0 #Setting Expose Animation to 0 Seconds
defaults write com.apple.dock tilesize -int 36 #Setting Icon Size to 36 Pixels
defaults write com.apple.dock mineffect -string "genie" #Changes Minimize to Dock Animation to "Genie" (Seems to be the fastest by my eye)
defaults write com.apple.dock launchanim -bool false #Setting Launch Animation to False

defaults write com.apple.NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool FALSE #Remove Save to iCloud Functionality
defaults write com.apple.NSGlobalDomain AppleHighlightColor -string "1.000000 0.733333 0.721569 Red" #Setting Highlight Color to Red
defaults write com.apple.NSGlobalDomain AppleShowAllExtensions -bool YES #Shows All File Extensions Always
defaults write com.apple.NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool NO #Disables Double Space Bar- to Period
defaults write com.apple.NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool NO #Disables Miniaturize on Double Click
defaults write com.apple.NSGlobalDomain AppleActionOnDoubleClick -string "Minimize" #Setting Double Click Action to Minimize
defaults write com.apple.NSGlobalDomain AppleAccentColor -int 0 #Setting Apple Accent Color to Red
defaults write com.apple.NSGlobalDomain NSUseAnimatedFocusRing -bool NO #Disabling Animated Focus Ring (The Blue Halo Around Input Fields & Stuff)
defaults write com.apple.NSGlobalDomain AppleShowScrollBars -string "WhenScrolling" #Showing Scroll Bars Only When Scrolling
defaults write com.apple.NSGlobalDomain NSTableViewDefaultSizeMode -int 1 #Sets Default Finder View Size to 1
defaults write com.apple.NSGlobalDomain NSAutomaticCapitalizationEnabled -bool NO #Disabling Automatic Capitalization
defaults write com.apple.NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true #Automatically Expanding Printer Dialog Box & NSNav Panel
defaults write com.apple.NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write com.apple.NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write com.apple.NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
defaults write com.apple.NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false #Disabling Automatic Dash & Quote Substitution, Spell Correct
defaults write com.apple.NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write com.apple.NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write com.apple.NSGlobalDomain NSWindowResizeTime -float 0.001 #Sets Windows Resize Time to the Minimize Possible
defaults write com.apple.NSGlobalDomain com.apple.springing.enabled -bool false #Disabling App Springing Animation
defaults write com.apple.NSGlobalDomain com.apple.springing.delay -float 0

defaults write com.apple.appstore WebKitDeveloperExtras -bool true #Enabling Developer Stuff in App Store
defaults write com.apple.appstore ShowDebugMenu -bool true
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true #Fixing Automatic Software Updates
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1
defaults write com.apple.commerce AutoUpdate -bool true
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true
defaults write com.apple.PowerChime ChimeOnAllHardware -bool true; open /System/Library/CoreServices/PowerChime.app #Enabling powerchime
defaults write com.apple.Preview NSQuitAlwaysKeepsWindows -bool FALSE #Delete Preview Window History On Close
defaults write com.apple.mail DisableReplyAnimations -bool true #Disables Mail Reply & Send Animation
defaults write com.apple.mail DisableSendAnimations -bool true
defaults write com.apple.screencapture disable-shadow -bool TRUE #Disable Screen Capture Shadow
defaults write com.apple.screencapture type JPG #Change Screenshot File Format to JPG
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true #Closes Print Dialog Box After Printing is Complete
sudo nvram SystemAudioVolume=" " #Removes Startup Sound
defaults write com.apple.TextEdit RichText -int 0 #Sets Texedit to Automatically Open in Plain Text
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4
defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true #Automatically Play Movies When Opened in QuickTime

killall dock
killall Finder
killall SystemUIServer
killall Mail
killall TextEdit
killall QuickTimePlayerX
killall Photos

echo 'Installation Complete'
echo 'Now you can make an SSH key:'
echo "Press CONTROL+C, if you don't want to"

ssh-keygen -t  ecdsa -b 521
