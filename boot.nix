{boot, ...}: {
  environment.etc."nixos/configuration.nix".source = ./configuration.nix;
  environment.etc."bashrc.local".text = ''
    echo "Trying to install!"
    echo "Press enter to continue..."
    read

    curl -sSLf --connect-timeout 5 \
      --max-time 10 \
      --retry 5 \
      --retry-delay 0 \
      --retry-max-time 40 \
      https://raw.githubusercontent.com/CoderDojoRotselaar/nixos/master/install.sh | sudo bash -xe
  '';
}
