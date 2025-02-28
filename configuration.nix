# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./cachix.nix
      <home-manager/nixos>
    ];
  # Binary Cache for Haskell.nix
  nix.settings.trusted-public-keys = [
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  ];
  nix.settings.substituters = [
    "https://cache.iog.io"
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "maquiavelika-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Guayaquil";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "mauricio" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.xkbOptions = "ctrl:swapcaps";
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia.open = true;
  hardware.nvidia.prime = {
    offload.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
  };

  services.lorri.enable = true;
  services.redis.enable = true;

  services.postgresql = {
    enable = false;
    package = pkgs.postgresql_13;
    ensureUsers = [
      { name = "mauricio";
        ensurePermissions = {
          "ALL TABLES in SCHEMA public" = "ALL PRIVILEGES";
        };
      }
    ];
  };
  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  # Disable suspend on closing lid
  # services.logind.lidSwitchExternalPower = "ignore";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users =
    (import ./users.nix { inherit pkgs; });

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    monaspace
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.variables.EDITOR = "nvim";
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    cachix
    nvidia-offload
    nix-prefetch-git
    firefox
    silver-searcher
    chromium
    tor-browser-bundle-bin
    htop
    curl
    gnome.gnome-tweaks
    gnome.gnome-keyring
    # displaylink
    vlc
    xclip
    xsel
    xorg.xprop
    libreoffice
    tldr
    lsof
    wireguard-tools
    hexchat # until upgrading home-manager to support 22.11
    ngrok
    discord
    # ghc-js
    emscripten
    nodejs
    android-studio
    # Doom Emacs
    fd
    ripgrep
    gparted
    ghostty
  ];
  services.gnome.gnome-keyring.enable  = true;
  programs.steam.enable = true;
  programs.zsh.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.users =
    (import ./home.nix { inherit pkgs; });

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];

  # Wireguard
  # networking.firewall.allowedUDPPorts = [ 51820 ];

  # networking.wireguard.interfaces = {
  #   wg0 = {
  #     ips = [ "10.6.0.3/24" ];
  #     listenPort = 51820;
  #     privateKeyFile = "/home/mauricio/wireguard-keys/private";
  #     peers = [
  #       {
  #         publicKey = "LZvfSlgc7iPftmi7k2KrRrzroigc3ooU6wuGz4xdMDg=";
  #         allowedIPs = [ "0.0.0.0/0" ];
  #         endpoint = "";
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}

