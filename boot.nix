{
  pkgs,
  boot,
  ...
}: {
  environment.etc."install.sh".source = ./install.sh;
  environment.etc."bashrc.local".text = ''
    sudo bash -xe /etc/install.sh
  '';
  environment.systemPackages = with pkgs; [
    git
  ];
}
