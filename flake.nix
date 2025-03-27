{
  description = "zig_curricula";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    nix-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    nix-unstable,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = false;
          overlays = [
            (final: prev: {
              unstable = import nix-unstable {
                inherit system;
                config.allowUnfree = false;
              };
            })
          ];
        };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.alejandra
            pkgs.unstable.zig_0_13
          ];

          shellHook = ''
            # Custom Prompt
            export PS1="\n\[\e[1;32m\][devshell](zig) \w\n❯ \[\e[0m\]"
          '';
        };
      }
    );
}
