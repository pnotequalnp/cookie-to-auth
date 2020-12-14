{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      hs = pkgs.haskellPackages;

      pkg = hs.callCabal2nix "cookieToAuth" ./. {};
      docker = pkgs.dockerTools.buildImage {
        name = "pnotequalnp/cookieToAuth";
        tag = "0.1.0.0";
        contents = [ pkg ];
        config.Cmd = [ "cookieToAuth" ];
      };
    in {
      defaultPackage = pkg;
      packages = { inherit pkgs docker; };
      devShell = pkg.env.overrideAttrs (super: {
        nativeBuildInputs = with pkgs; super.nativeBuildInputs ++ [
          hs.cabal-install
          zlib
        ];
      });
    }
  );
}
