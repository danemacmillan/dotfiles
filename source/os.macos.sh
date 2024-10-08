# vim: ft=sh

##
# os.macos
#
# See https://github.com/mathiasbynens/dotfiles/blob/master/.macos for many
# more options.

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &



# Faster keyboard repeat rate.
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 10
# Ensure character suggestions for accents are enabled.
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Speed up Mission Control animation. Note that MacOS Sierra seems to ignore this.
defaults write com.apple.dock expose-animation-duration -float 0
# Don’t automatically rearrange Spaces based on most recent use.
defaults write com.apple.dock mru-spaces -bool false

# Speed up Dock reveal and hide.
defaults write com.apple.Dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.50

# Modify Apple's Notes app so it works more like a text editor.
defaults write com.apple.Notes ShouldContinuouslyCheckSpelling -bool false
defaults write com.apple.Notes ShouldCorrectSpellingAutomatically -bool false
defaults write com.apple.Notes ShouldPerformTextReplacement -bool false
defaults write com.apple.Notes ShouldUseDataDetectors -bool false
defaults write com.apple.Notes ShouldUseSmartCopyPaste -bool false
defaults write com.apple.Notes ShouldUseSmartDashes -bool false
defaults write com.apple.Notes ShouldUseSmartQuotes -bool false
defaults write com.apple.Notes alwaysShowLightContent -bool false

# Always show scrollbars
# Possible values: `WhenScrolling`, `Automatic` and `Always`
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Disable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Finder: show hidden files by default
#defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false
# Disable Disk Image Verification: Verifying ...
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Change location of screenshots
if [[ -e "${ICLOUD_DIRECTORY_LONG}/Screenshots" ]]; then
	defaults write com.apple.screencapture location "${ICLOUD_DIRECTORY_LONG}/Screenshots"
	killall SystemUIServer
fi

killall Dock
