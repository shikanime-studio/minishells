# Minishells

Portable Nix/devenv shells for different open source organizations. Instead of
reinventing a dev environment every time, plug in system config once and spin up
a shell per project.

**Language:** Nix

## Structure

- `flake.nix` — Main flake exposing all shells
- `.envrc` — Direnv configuration for automatic shell loading
- Individual shell definitions as flake outputs

## Usage

Each shell provides a self-contained development environment for a specific
project or organization. Load via `direnv` or `nix develop`.

## Commit Style

- Plain-text capitalized title, no conventional-commit prefix
- Body with labels: `Design:`, `Related:`, `Closes #`
- Keep Markdown lines wrapped at 80 columns and run `nix fmt` before shipping

## Stack

- 1 commit == 1 PR via ghstack (1 commit is 1 logical atomic change)
- Split work into stacked PRs to keep each PR small and reviewable
- To update a PR: edit files, then `jj squash` (or `git commit --amend`) into the
  **target commit** of the stack — the one that PR represents
- Resubmit with `ghstack` after squashing
- `ghstack land` on the head PR to land the entire stack
- Never `gh pr merge` (creates poisoned commits)
- Never force-push ghstack branches

## Protect `main`

- Require 1 approving review
- Require linear history (no merge commits)
- Require signed commits
- Squash+rebase merge only

*Licensed under Apache-2.0. Shells should be self-contained. Test with
`nix flake check` before submitting. Always use worktrees when making changes.*
