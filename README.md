# shared-flake-nix

Shared Nix flake that provides a common `mkDevShell` helper. It automatically handles macOS (Darwin) `libiconv` linking and sets `zsh` as the default shell.

## Usage

### 1. Add to your `flake.nix` inputs

```nix
inputs = {
  shared-flake.url = "github:sorafujitani/shared-flake-nix";
  # ...
};
```

### 2. Create a devShell with `mkDevShell`

```nix
outputs = { self, nixpkgs, shared-flake, ... }:
  let
    pkgs = import nixpkgs { system = "aarch64-darwin"; };
  in {
    devShells.aarch64-darwin.default = shared-flake.lib.mkDevShell {
      inherit pkgs;
      name = "my-project";
      buildInputs = with pkgs; [
        nodejs
        pnpm
      ];
      shellHook = ''
        echo "Welcome to my-project!"
      '';
      env = {
        DATABASE_URL = "postgres://localhost/mydb";
      };
    };
  };
```

### `mkDevShell` Parameters

| Parameter | Required | Default | Description |
|---|---|---|---|
| `pkgs` | Yes | - | A nixpkgs package set |
| `name` | Yes | - | Name of the devShell |
| `buildInputs` | No | `[]` | List of additional packages |
| `shellHook` | No | `""` | Script to run on shell entry |
| `env` | No | `{}` | Environment variables (passed directly to `mkShell`) |

### What it does automatically

- **Default shell**: Sets `SHELL` to `zsh`
- **macOS (Darwin)**: Configures `libiconv` compile and link flags
