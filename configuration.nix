{ config, pkgs, ... }:

{
  imports = [
    # Absolute local path to the file generated on their machine
    /etc/nixos/hardware-configuration.nix
  ];

  # Bootloader setup (UEFI)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking & Hostname
  networking.hostName = "parents-pc"; # Lithuanian host name
  networking.networkmanager.enable = true;

  # Vilnius Timezone
  time.timeZone = "Europe/Vilnius";

  # System Locale / Language Settings (Lithuanian)
  i18n.defaultLocale = "lt_LT.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "lt_LT.UTF-8";
    LC_IDENTIFICATION = "lt_LT.UTF-8";
    LC_MEASUREMENT = "lt_LT.UTF-8";
    LC_MONETARY = "lt_LT.UTF-8";
    LC_NAME = "lt_LT.UTF-8";
    LC_NUMERIC = "lt_LT.UTF-8";
    LC_PAPER = "lt_LT.UTF-8";
    LC_TELEPHONE = "lt_LT.UTF-8";
    LC_TIME = "lt_LT.UTF-8";
  };

  # Configure Keyboard Layout (Lithuanian + US fallback)
  # Toggle between languages using Alt + Shift
  services.xserver.xkb = {
    layout = "lt,us";
    options = "grp:alt_shift_toggle";
  };

  # Configure TTY (Virtual Console) keymap
  console.keyMap = "lt";

  # Enable Desktop Environment (KDE Plasma 6)
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Sound & Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable Printing & Network Printer Auto-Discovery
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Phone Sync (KDE Connect) Firewall Ports
  programs.kdeconnect.enable = true;

  # User Account Configuration
  users.users.parents = {
    isNormalUser = true;
    description = "Parents";
    extraGroups = [ "networkmanager" "wheel" "lp" "scanner" ];
  };

  # Allow Unfree Packages
  nixpkgs.config.allowUnfree = true;

  # Enable Flakes & Modern Nix Command Line
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Auto-Upgrade System
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = "weekly";
  };

  # System-wide Installed Packages
  environment.systemPackages = with pkgs; [
    # Core Applications
    firefox
    libreoffice-fresh
    kdePackages.kcalc        # Calculator
    kdePackages.kweather     # Weather App
    kdePackages.dolphin      # File Manager

    # Media & Utility
    vlc                      # Video player
    kdePackages.gwenview     # Image viewer
    kdePackages.print-manager # Printer setup tool

    # Lithuanian Spellcheck Dictionary for LibreOffice & Firefox
    hunspell
    hunspellDicts.lt_LT
  ];

  environment.shellAliases = {
    update-system = "sudo nixos-rebuild switch --flake github:maaarsas/nixos-basic-config"
  };

  # Font Packages with Lithuanian Glyph Support
  fonts.packages = with pkgs; [
    noto-fonts
    liberation_ttf
    corefonts
    dejavu_fonts
  ];

  # System Version (Do not alter after initial installation)
  system.stateVersion = "26.05";
}
