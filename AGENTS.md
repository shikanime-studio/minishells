# minishells

Portable Nix/devenv shells for different open source organizations.

**Language:** Nix

**Structure:** `flake.nix` — all shells; `.envrc` — direnv config; shells as flake outputs

**Commit style:** Plain-text capitalized title, no prefix. Body with labels: `Design:`, `Related:`, `Closes #`.

**Stack:** 1 commit == 1 PR via ghstack. Amend + `ghstack` to resubmit. `ghstack land` on head PR to land stack. Never `gh pr merge`. Never force-push.

**Protect `main`:** 1 review, linear history, signed commits, squash+rebase only.

*Apache-2.0. Test with `nix flake check`*
