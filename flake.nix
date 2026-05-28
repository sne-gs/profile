{
  description = "Resume PDF builder";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            python3Packages.weasyprint
            fontconfig.out
          ];
          shellHook = ''
            export FONTCONFIG_FILE="${pkgs.fontconfig.out}/etc/fonts/fonts.conf"
            echo "Ready. Convert HTML to PDF with: weasyprint resume.html resume.pdf"
          '';
        };

        packages.default = pkgs.stdenv.mkDerivation {
          name = "resume";
          src = ./.;
          nativeBuildInputs = with pkgs; [
            python3Packages.weasyprint
            fontconfig.out
          ];
          buildPhase = ''
            export FONTCONFIG_FILE="${pkgs.fontconfig.out}/etc/fonts/fonts.conf"
            weasyprint resume.html resume.pdf
          '';
          installPhase = ''
            mkdir -p $out
            cp resume.pdf $out/
          '';
        };
      });
}