#NoteBook FanControl
{ config, pkgs, ... }:

# Uncomment lines only if you don't use flakes to get nbfc-linux.
#
# flake vs fetchFromGitHub:
#
# - for disadvantages, + for advantages:
#
# - fetchFromGitHub: updates: have to manually change config file (revision, hash)
# + flake: updates: `nix profile upgrade` command
#
# flake install: `git clone https://github.com/nbfc-linux/nbfc-linux && cd nbfc-linux && nix --experimental-features 'nix-command flakes' profile install`
# Then the nbfc.nix only needs the `systemd.services` stuff, nothing else.

let
  myUser = "viswas"; #adjust this to your username
  command = "bin/nbfc_service --config-file '/home/viswas/.config/nbfc.json'";

# If you don't use flakes:
#  nbfc = pkgs.stdenv.mkDerivation {
#  name = "nbfc-linux";
#  version = "0.1.7";

#  src  = pkgs.fetchFromGitHub {
#    owner  = "nbfc-linux";
#    repo   = "nbfc-linux";
#    rev    = "4c2b75e4a875459e86a9892319889ff945e9cadf";
#    sha256 = "UxaL4V8FkA+eONCj7vTHAlRSJxoXqRB2aW7A/KJyvlY=";
#  };

#  buildFlags = [ "PREFIX=$(out)" "confdir=/etc" ];

#  installPhase =
#    let
#      installFlags = [ "PREFIX=$out" ];
#    in
#    ''
#      make ${builtins.concatStringsSep " " installFlags}\
#           install-core \
#           install-client-c\
#           install-configs\
#           install-docs\
#           install-completion
#    '';
# };
in
{

# If you don't use flakes:
#environment.systemPackages = with pkgs; [
#  nix-prefetch-github
#  nbfc
#];

# Needed for both flakes and fetchFromGitHub:
systemd.services.nbfc_service = {
  enable = true;
  description = "NoteBook FanControl service";
  serviceConfig.Type = "simple"; #related upstream config: https://github.com/nbfc-linux/nbfc-linux/blob/main/etc/systemd/system/nbfc_service.service.in
  path = [ pkgs.kmod ];
  # script = let package = nbfc.packages.${pkgs.system}.nbfc; in "${package}/${command}"; #for fetchFromGitHub
  script = "/home/viswas/.nix-profile/bin/nbfc_service"; #for flake
  wantedBy = [ "multi-user.target" ];
};

}
