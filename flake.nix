{
  description = "Shared Nix devShell configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      systems,
    }:
    {
      lib = {
        mkDevShell =
          {
            pkgs,
            name,
            buildInputs ? [ ],
            shellHook ? "",
            env ? { },
          }:
          pkgs.mkShell (
            {
              inherit name buildInputs;

              NIX_CFLAGS_COMPILE = pkgs.lib.optionalString pkgs.stdenv.isDarwin
                "-I${pkgs.darwin.libiconv}/include";
              NIX_LDFLAGS = pkgs.lib.optionalString pkgs.stdenv.isDarwin
                "-L${pkgs.darwin.libiconv}/lib -liconv";

              shellHook = ''
                export SHELL="${pkgs.zsh}/bin/zsh"
                ${shellHook}
              '';
            }
            // env
          );
      };
    };
}
