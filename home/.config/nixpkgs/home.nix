##
# Home Manager via Nix.
#
# See all Configuration Options:
# https://nix-community.github.io/home-manager/options.html
# or using `home-manager option`
# @author Dane MacMillan <work@danemacmillan.com>

{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "danemacmillan";
  home.homeDirectory = "/Users/danemacmillan";

  # Packages that should be installed to the user profile.
  home.packages = [
    pkgs.ack
    pkgs.aspell
    pkgs.atool
    pkgs.autoconf
    pkgs.automake
    pkgs.autoconf
    pkgs.bat
    # https://github.com/NixOS/nixpkgs/issues/27126#issuecomment-313289789
    # Do not use regular bash, as it does not include readline support, which
    # messes with the prompt strings like PS1. Use the interactive package.
    #pkgs.bash
    pkgs.bashInteractive
    pkgs.bash-completion
    #pkgs.bfg-repo-cleaner
    #pkgs.bitlbee
    pkgs.cloud-sql-proxy
    pkgs.cmake
    pkgs.cmatrix
    pkgs.coreutils
    pkgs.cowsay
    pkgs.ctags
    pkgs.curl
    pkgs.diff-so-fancy
    pkgs.direnv
    pkgs.dnsmasq
    pkgs.dos2unix
    pkgs.exiftool
    pkgs.findutils
    pkgs.fontconfig
    pkgs.freetype
    pkgs.fswatch
    pkgs.fzf
    pkgs.gawk
    pkgs.getopt
    pkgs.git
    pkgs.git-extras
    pkgs.glib
    pkgs.gnugrep
    pkgs.gnupg
    pkgs.gnused
    pkgs.gnutar
    pkgs.gnutls
    pkgs.google-cloud-sdk
    pkgs.grc
    pkgs.guile
    pkgs.gzip
    pkgs.highlight
    pkgs.htop
    pkgs.httperf
    pkgs.httpie
    pkgs.icu69
    #pkgs.hub
    pkgs.iftop
    pkgs.indent
    pkgs.ioping
    pkgs.iperf
    #pkgs.pinentry
    pkgs.jmeter
    pkgs.jpegoptim
    pkgs.jq
    pkgs.libmediainfo
    pkgs.lua
    pkgs.lynx
    pkgs.mas
    pkgs.mediainfo
    pkgs.libmhash
    pkgs.lsof
    pkgs.moreutils
    pkgs.most
    pkgs.mycli
    pkgs.ncdu
    pkgs.neofetch
    pkgs.netperf
    pkgs.nix-bash-completions
    pkgs.nmap
    pkgs.openssl
    pkgs.pass
    pkgs.pcre
    pkgs.procps
    pkgs.pv
    #pkgs.python37Full
    #pkgs.ranger
    pkgs.rclone
    pkgs.readline
    pkgs.ripgrep
    pkgs.rlwrap
    pkgs.rsync
    pkgs.siege
    pkgs.sipcalc
    pkgs.stow
    pkgs.symlinks
    pkgs.tealdeer
    pkgs.terminal-notifier
    pkgs.tig
    pkgs.tmux
    pkgs.tree
    pkgs.tsung
    pkgs.unrar
    pkgs.vim
    #pkgs.w3m
    pkgs.weechat
    #pkgs.weighttp
    pkgs.wget
    pkgs.ydiff

    # Development
    #pkgs.mysql57
    #pkgs.nginx
    ##pkgs.nodejs-10_x
    ##pkgs.nodePackages.grunt-cli
    ##pkgs.phantomjs2
    #pkgs.php74
    # Build PHP with custom set of extensions compiled in.
    # https://nixos.org/manual/nixpkgs/unstable/#sec-php
#    (pkgs.php74.withExtensions ({ all, ... }: with all; [
#      bcmath
#      ctype
#      curl
#      dom
#      fileinfo
#      gd
#      #hash
#      iconv
#      intl
#      json
#      #libxml
#      mysqlnd
#      mysqli
#      opcache
#      openssl
#      #pcre
#      pdo_mysql
#      redis
#      simplexml
#      soap
#      sockets
#      sodium
#      xdebug
#      xmlwriter
#      xsl
#      zip
#    ]))
    ## Build package with its own set of dependencies and PHP version.
    ##(pkgs.php74.withExtensions ({ all, ... }: with all; [
    ##  opcache
    ##])).packages.composer
    #pkgs.php74Packages.composer
    #pkgs.php74Packages.psysh
    #pkgs.redis

    # GUIs
    #pkgs.alacritty
    #pkgs.mono5
    #pkgs.radarr
    #pkgs.slack
    #pkgs.sonarr
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Let Home Manager manage these configurations.
  programs.bat = {
    enable = true;
    config = {
      theme = "GitHub";
      italic-text = "always";
    };
  };

  # This does not work, so comment out for now.
  #programs.command-not-found.enable = true;

  # Do not let Home Manager manage these configurations.
  programs.bash.enable = false;
    #	programs.bash = {
    #   enable = true;
    #   bashrcExtra = ''b
    #     . ~/oldbashrc
    #   '';
    # };
  programs.alacritty.enable = false;
  programs.git.enable = false;
  programs.htop.enable = false;
  programs.tmux.enable = false;
  programs.vim.enable = false;

  # MacOS Defaults.
  #
  # This is still experimental, and it is possible that they only execute
  # if the nix-darwon module is installed and Home Manager managed through it.
  # In the meantime, these are just example additions. Home Manager does appear
  # to apply them in its output when running `switch`, but does not seem to
  # take effect in the OS itself. Perhaps a restart is required.
  targets.darwin.defaults = {
    #defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
    com.apple.desktopservices = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };
    #defaults write com.apple.finder ShowPathbar -bool true
    com.apple.finder = {
      ShowPathbar = false;
    };
    #defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
    NSGlobalDomain = {
      com.apple.swipescrolldirection = true;
    };
  };

}
