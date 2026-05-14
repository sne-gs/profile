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
        python = pkgs.python3.withPackages (ps: with ps; [ weasyprint pip ]);
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ python fontconfig.out agave ];
          shellHook = ''
            export FONTCONFIG_FILE="${pkgs.fontconfig.out}/etc/fonts/fonts.conf"
            PYTHON='${python.interpreter}'
            VENV=.venv
            if [ ! -d "$VENV" ]; then
              echo "Creating virtual environment..."
              $PYTHON -m venv --system-site-packages "$VENV"
            fi
            source "$VENV/bin/activate"
            if ! python -c "import md2pdf" 2>/dev/null; then
              echo "Installing md2pdf..."
              pip install "md2pdf[cli]" --quiet
            fi
          '';
        };

        packages.default = pkgs.stdenv.mkDerivation {
          name = "resume";
          src = ./.;
          nativeBuildInputs = with pkgs; [ python fontconfig.out agave ];
          buildPhase = ''
            export FONTCONFIG_FILE="${pkgs.fontconfig.out}/etc/fonts/fonts.conf"
            PYTHON='${python.interpreter}'
            $PYTHON -m venv --system-site-packages .venv
            source .venv/bin/activate
            pip install "md2pdf[cli]" --quiet
            md2pdf -i resume.md -o resume.pdf
          '';
          installPhase = ''
            cp resume.pdf $out/
          '';
        };
      });
}
