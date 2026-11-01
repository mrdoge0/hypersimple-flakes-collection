{
  description = "Hyper Simple Flakes Collection";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux = {
      legacy-launcher = let
        pkgs = import nixpkgs { system = "x86_64-linux"; };
      in pkgs.stdenv.mkDerivation rec {
        name = "legacy-launcher";
        version = "1.0";

        # Replace these with your actual JAR URL and hash
        jarUrl = "https://dl.llaun.ch/legacy/bootstrap";
        jarSha256 = "sha256-0kkc9cxjn7lrcr6r3np0ba1lfllhp0qf4vcszy00gcx9r0bpbfh9";

        src = pkgs.fetchurl {
          url = jarUrl;
          sha256 = jarSha256;
        };

        nativeBuildInputs = [ pkgs.makeWrapper ];

        phases = "installPhase";

        installPhase = ''
          mkdir -p $out/share/applications $out/share/legacylauncher-bootstrap

          # Install the JAR
          cp ${src} $out/share/legacylauncher-bootstrap/bootstrap.jar

          # Create desktop file
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
