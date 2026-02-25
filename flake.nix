{
  inputs = {
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devlib = {
      url = "github:shikanime-studio/devlib";
      inputs = {
        devenv.follows = "devenv";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://cachix.cachix.org"
      "https://devenv.cachix.org"
      "https://shikanime.cachix.org"
      "https://shikanime-studio.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "shikanime.cachix.org-1:OrpjVTH6RzYf2R97IqcTWdLRejF6+XbpFNNZJxKG8Ts="
      "shikanime-studio.cachix.org-1:KxV6aDFU81wzoR9u6pF1uq0dQbUuKbodOSP8/EJHXO0="
    ];
  };

  outputs =
    inputs@{
      devenv,
      devlib,
      flake-parts,
      git-hooks,
      treefmt-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        devenv.flakeModule
        devlib.flakeModule
        git-hooks.flakeModule
        treefmt-nix.flakeModule
      ];

      perSystem =
        { lib, pkgs, ... }:
        with lib;
        {
          devenv.shells = rec {
            default.imports = [
              devlib.devenvModules.git
              devlib.devenvModules.nix
              devlib.devenvModules.shell
              devlib.devenvModules.shikanime
            ];

            base = {
              containers = mkForce { };

              packages = with pkgs; [
                gh
                sapling
              ];
            };

            cloud-pi-native = {
              imports = [ base ];

              packages = with pkgs; [
                kubectl
                kubernetes-helm
                teleport
              ];
            };

            "cloud-pi-native/console" = {
              imports = [ cloud-pi-native ];

              env = {
                PRISMA_FMT_BINARY = "${pkgs.prisma-engines_6}/bin/prisma-fmt";
                PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines_6}/bin/query-engine";
                PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines_6}/lib/libquery_engine.node";
                PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines_6}/bin/schema-engine";
              };

              languages.javascript = {
                enable = true;
                pnpm.enable = true;
              };

              packages =
                with pkgs;
                [
                  docker
                  firefox
                ]
                ++ optional (lib.meta.availableOn stdenv.hostPlatform chromium) chromium;
            };

            "cloud-pi-native/socle" = {
              imports = [ cloud-pi-native ];

              languages = {
                python = {
                  enable = true;
                  uv.enable = true;
                };
                ruby.enable = true;
              };

              packages = with pkgs; [
                ansible
                gnutar
                yq
              ];
            };

            codegouvfr = {
              containers = mkForce { };

              languages.javascript = {
                enable = true;
                yarn.enable = true;
              };
            };

            jj-vcs = {
              imports = [ base ];

              languages.rust.enable = true;

              packages = with pkgs; [
                libiconv
              ];
            };

            facebook.imports = [ base ];

            "facebook/sapling" = {
              imports = [ facebook ];

              languages = {
                javascript = {
                  enable = true;
                  yarn.enable = true;
                };
                rust.enable = true;
                python.enable = true;
              };

              packages = with pkgs; [
                gnumake
                libiconv
                mercurial
              ];
            };

            torvalds.imports = [ base ];

            "torvalds/linux" = {
              imports = [ torvalds ];

              languages.c.enable = true;

              packages =
                with pkgs;
                [
                  bc
                  bison
                  flex
                  gcc
                  gnumake
                  ncurses
                  openssl
                  pkg-config
                  python3
                  zlib
                ]
                ++ optional (lib.meta.availableOn stdenv.hostPlatform elfutils) elfutils
                ++ optional (lib.meta.availableOn stdenv.hostPlatform pahole) pahole;
            };

            longhorn = {
              imports = [ base ];

              git-hooks.hooks = {
                golangci-lint.enable = true;
                gotest.enable = true;
              };

              languages.go.enable = true;

              packages = with pkgs; [
                docker
                gnumake
                kubectl
                kustomize
              ];
            };

            nixos = {
              imports = [ base ];

              languages.nix.enable = true;

              packages = with pkgs; [
                nixpkgs-review
              ];
            };

            shikanime-studio = {
              imports = [ base ];

              languages.nix.enable = true;

              packages = with pkgs; [
                ghstack
              ];
            };
          };
        };

      flake.templates.default = {
        path = ./templates/default;
        description = "A devenv template with default settings.";
      };

      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    };
}
