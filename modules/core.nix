{ pkgs, ... } @ inputs: {

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;

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

  services.xserver.displayManager.sddm = {
    enable = true;
  };
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
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" "ubridge" ];
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
      inputs.pkgsUnstable.hyprlock
      inputs.pkgsUnstable.hypridle
      protonmail-bridge
    ];
  };

  fonts.packages = with pkgs; [
    fira-code
    fira-code-nerdfont
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "23.11";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
