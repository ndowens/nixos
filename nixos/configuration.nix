# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  security.sudo.wheelNeedsPassword = false;
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "radeon.si_support=0" "amdgpu.si_support=1" "radeon.cik_support=0" "amdgpu.cik_support=1" ];
  networking.hostName = "Revan"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  systemd.network.enable = true;
  systemd.network.networks."10-enp" = {
  matchConfig.Name = "enp*";
  networkConfig.DHCP = "ipv4";
  };
  # Set your time zone.
  time.timeZone = "America/Chicago";
  services.ananicy.enable = true;
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  environment.shellAliases = {
  vim = "nvim";
  };
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
#  boot.kernelParams = [ "radeon.si_support=0" "amdgpu.si_support=1" ];
# for Sea Islands (CIK i.e. GCN 2) cards
#  boot.kernelParams = [ "radeon.cik_support=0" "amdgpu.cik_support=1" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics.enable32Bit = true; # For 32 bit applications

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
  	enable = true;
	theme = "catppuccin";
  };
 
  services.desktopManager.plasma6.enable = true;
  zramSwap.enable = true;
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ndowens = {
    isNormalUser = true;
    description = "Nathan";
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Install firefox.
  programs.firefox.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    distrobox
    podman
    neovim
    brave
    fontconfig
    home-manager
    tailscale
    mosh
    vulkan-tools
    vulkan-validation-layers
    mangohud
    gamemode
    git
    kdePackages.discover
    podman-tui # status of containers in the terminal
    docker-compose # start group of containers for dev
    wine-staging
    catppuccin-sddm
    ananicy-cpp
    ananicy-rules-cachyos

  ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  programs.steam.enable = true;
  services.flatpak.enable = true; 
  fonts = {
  enableDefaultPackages = true;
  packages = with pkgs; [ 
	liberation_ttf
	ubuntu_font_family
	];

  fontconfig = {
  	defaultFonts = {
		serif = [ "Liberation Serif" ];
#		sanSerif = [ "Liberation Sans" ];
		monospace = [ "Ubuntu Mono" ];
		};
	};
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  # List services that you want to enable:
  networking.nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];

services.resolved = {
  enable = true;
  dnssec = "true";
  domains = [ "~." ];
  fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
  dnsovertls = "true";
};
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.tailscale.enable = true;
  system.stateVersion = "25.05"; # Did you read the comment?
  networking.firewall.checkReversePath = "loose";

    # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  powerManagement.enable = true;
  nix.gc = {
                automatic = true;
                dates = "weekly";
                options = "--delete-older-than 7d";
        };
}
