# minishells

This repo is where I park the Nix/devenv shells I actually use for the
different open source organisations I work with. Instead of reinventing a dev
environment every time, I plug in system config once and spin up a shell per
project.

## Requirements

- Nix with flakes enabled
- Optional: direnv + nix-direnv

## Usage

Enter the default shell:

```bash
nix develop
```

Enter a specific shell:

```bash
nix develop .#cloud-pi-native
```

List available shells:

```bash
nix flake show
```

## Direnv

This repo ships an `.envrc` that loads the default shell:

```bash
direnv allow
```

To automatically load a specific shell, point direnv at the shell attribute:

```bash
use flake .#cloud-pi-native --accept-flake-config --no-pure-eval
```

## Template

If you want to consume these shells from another checkout (or without a local
clone), you can init a tiny direnv setup:

```bash
nix flake init -t github:shikanime-studio/minishells#default
```

Then edit `.envrc` to target the shell you want:

```bash
use flake github:shikanime-studio/minishells#cloud-pi-native \
  --accept-flake-config --no-pure-eval
```

## Adding A Shell

Shells live under `devenv.shells` in \[flake.nix\](file:///Users/shikanimedeva/Source/Repos/github.com/shikanime-studio/minishells/flake.nix).
Most shells import `base` for common packages and settings, then layer extra
languages, packages, env vars, and hooks:

```nix
devenv.shells.my-shell = {
  imports = [ base ];

  languages.go.enable = true;

  packages = with pkgs; [
    gnumake
  ];
};
```

This flake also imports [devlib](https://github.com/shikanime-studio/devlib),
so shells can reuse `devlib.devenvModules.<name>` profiles for consistent
formatters, hooks, and generators.
