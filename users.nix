{pkgs, ...}: {
  mauricio = {
    isNormalUser = true;
    home = "/home/mauricio";
    description = "Mauricio Fierro";
    extraGroups = [ "wheel" "network-manager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };
}
