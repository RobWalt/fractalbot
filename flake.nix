{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-crate2nix = {
      url = "github:kolloch/crate2nix";
      flake = false;
    };
  };

  outputs = inputs @ {
    flake-parts,
    rust-overlay,
    rust-crate2nix,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      imports = [
        ./nix/overlays.nix
        ./nix/julia.nix
      ];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        devShells.default = pkgs.mkShell {
          inputsFrom = [self'.packages.julia];
        };
      };
    };
}
