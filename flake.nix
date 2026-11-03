{
  description = "Hyper Simple Flakes Collection";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux = {
      # Legacy launcher
      legacy-launcher = let
        pkgs = import nixpkgs { system = "x86_64-linux"; };
      in pkgs.stdenv.mkDerivation rec {
        name = "legacy-launcher";
        version = "1.0";

        src = pkgs.fetchurl {
          url = "https://dl.llaun.ch/legacy/bootstrap";
          sha256 = "sha256-Cbp1F8ipsweA/5pt4jC4kFJHg1rg2pFNZpkeKztLbE4=";
        };

        nativeBuildInputs = [ pkgs.makeWrapper ];

        phases = "installPhase";

        installPhase = ''
          mkdir -p $out/share/applications $out/share/legacylauncher-bootstrap

          cp ${src} $out/share/legacylauncher-bootstrap/bootstrap.jar

          cat > $out/share/applications/legacy-launcher.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Legacy Launcher
Exec=java -jar $out/share/legacylauncher-bootstrap/bootstrap.jar
Icon=minecraft
Terminal=false
Categories=Game;
EOF
        '';
      };
    };
  };
}
