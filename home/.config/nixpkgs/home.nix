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
    pkgs.bat
    #pkgs.bash
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
    pkgs.dos2unix
    pkgs.exiftool
    pkgs.findutils
    pkgs.fontconfig
    pkgs.freetype
    pkgs.fswatch
    pkgs.fzf
    pkgs.gawk
    pkgs.getopt
    pkgs.gnugrep
    pkgs.gnused
    pkgs.gnutar
    pkgs.google-cloud-sdk
    pkgs.indent
    pkgs.nix-bash-completions
    pkgs.radarr
    pkgs.rclone
    pkgs.rsync
    #pkgs.slack
    pkgs.sonarr
    pkgs.symlinks
    pkgs.weechat
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

  # Explicitly do not let Home Manager manage bash.
  programs.bash.enable = false;
  #	programs.bash = {
  #   enable = true;
  #   bashrcExtra = ''
  #     . ~/oldbashrc
  #   '';
  # };

  programs.bat.enable = true;
}
