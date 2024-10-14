{ pkgs, ... } @ inputs: {

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  console.keyMap = "fr";

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.zsh.enable = true;

  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;

  services.xserver.desktopManager.plasma5.enable = true;

  programs.hyprland.enable = true;

  programs.gnupg = {
    agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  virtualisation.docker.enable = true;

  services.gnome.gnome-keyring.enable = true;

  users.users.baptiste = {
    isNormalUser = true;
    description = "baptiste";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" "ubridge" "wireshark"];
    packages = with pkgs; [
      firefox
      vim
      xterm
      alacritty
      discord
      kitty
      pavucontrol
      hyprpaper
      pinentry-curses
      hyprlock
      hypridle
      protonmail-bridge
      teams-for-linux
      chromium
      grim
      xdg-desktop-portal-hyprland
      wl-clipboard
      wireshark
      stern
      apache-directory-studio
      vesktop
      wireshark
    ];
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  fonts.packages = with pkgs; [
    fira-code
    fira-code-nerdfont
    _0xproto
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "23.11";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.steam.enable = true;
}
