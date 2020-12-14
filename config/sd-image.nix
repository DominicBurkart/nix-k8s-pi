{ lib, ... }: { # , pkgs ...
  imports = [
    ## Uncomment at most one of the following to select the target system:
    # ./generic-aarch64 # (note: this is the same as 'rpi3')
    ./rpi4
    # ./rpi3

    # ./microk8s_in_lxd
  ];

  # generate a new user
  users.extraUsers.nixos.openssh.authorizedKeys.keys = [ "INSERT_SSH_KEY" ];

  # = {
  #  INSERT_USER_NAME = {
  #    extraGroups = [ "wheel" "docker" ];
  #    isNormalUser = true;
  #    shell = pkgs.zsh;
  #    openssh.authorizedKeys.keys = [ "INSERT_SSH_KEY" ];
  #  }
  #};

  # bzip2 compression takes loads of time with emulation, skip it. Enable this if you're low
  # on space.
  sdImage.compressImage = false;

  # OpenSSH is forced to have an empty `wantedBy` on the installer system[1], this won't allow it
  # to be automatically started. Override it with the normal value.
  # [1] https://github.com/NixOS/nixpkgs/blob/9e5aa25/nixos/modules/profiles/installation-device.nix#L76
  systemd.services.sshd.wantedBy = lib.mkOverride 40 [ "multi-user.target" ];

  # Enable OpenSSH out of the box.
  services.sshd.enable = true;

  # Wireless networking (1). You might want to enable this if your Pi is not attached via Ethernet.
  #networking.wireless = {
  #  enable = true;
  #  interfaces = [ "wlan0" ];
  #  networks = {
  #    "SSID" = {
  #      psk = "password";
  #    };
  #  };
  #};

  # set local ip address (comment out if you don't need this)
  networking.interfaces.eth0.ipv4.addresses = [ {
    address = "INSERT_LOCAL_IPV4";
    prefixLength = 24;
  } ];

  # Wireless networking (2). Enables `wpa_supplicant` on boot.
  #systemd.services.wpa_supplicant.wantedBy = lib.mkOverride 10 [ "default.target" ];

  # NTP time sync.
  #services.timesyncd.enable = true;

  # enable lxd
  virtualisation.docker.enable = true;

  # add system packages
  # environment.systemPackages = [
  #   wget
  #   nano
  # ];
}
