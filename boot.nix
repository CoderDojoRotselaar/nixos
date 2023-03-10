{
  pkgs,
  boot,
  ...
}: {
  environment.etc."install.sh".source = ./install.sh;
  environment.etc."include.secrets.sh".source = ./include.secrets.sh;
  environment.etc."bashrc.local".text = ''
    sudo bash -eu /etc/install.sh
  '';
  environment.systemPackages = with pkgs; [
    git
    git-crypt
  ];
}
