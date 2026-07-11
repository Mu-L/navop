---
name: syncing-onetcli-upstream
description: Use when Navop needs to import, merge, or reconcile new changes from the feigeCode/onetcli dev branch without losing Navop branding, release naming, docs exclusions, or legacy OnetCli compatibility contracts.
---

# Syncing OnetCli Upstream

## Overview

Treat upstream synchronization as a guarded merge, not a file copy. Preserve upstream history while protecting Navop's public identity and intentional compatibility identifiers.

Read [references/brand-contract.md](references/brand-contract.md) before resolving conflicts. Read [references/verification-matrix.md](references/verification-matrix.md) before testing or reporting completion.

## Workflow

1. Require a clean worktree. Never stash, discard, or overwrite unrelated user changes.
2. Confirm `onetcli-upstream` points exactly to `git@github.com:feigeCode/onetcli.git`; add it only when absent. Do not synchronize from a local OnetCli checkout.
3. Fetch `origin dev` and `onetcli-upstream dev`.
4. Create `sync/onetcli-YYYYMMDD` from `origin/dev`. Add a short suffix if that branch already exists. Do not merge or push directly to Navop `dev`.
5. Merge with `rtk git merge --no-commit --no-ff onetcli-upstream/dev`.
6. Remove upstream documentation changes with `rtk git restore --source=HEAD --staged --worktree -- docs`. Keep existing Navop docs unchanged.
7. Run `rtk git rm --ignore-unmatch .github/workflows/release-docs.yml .github/workflows/test-docs.yml` so docs workflows cannot return.
8. Resolve remaining conflicts file by file. Never accept all `ours` or all `theirs`. Apply the public-brand and compatibility rules from the brand contract.
9. Run `rtk .codex/skills/syncing-onetcli-upstream/scripts/check-sync-contract.sh`. Inspect every reported old-brand candidate and the complete staged diff.
10. Execute the verification matrix. Separate new failures from documented repository baselines.
11. Commit the merge only after checks and review. Push only the synchronization branch unless the user explicitly authorizes merging Navop `dev`.

## Command Skeleton

```bash
rtk git status --short --branch
rtk git remote get-url onetcli-upstream
rtk git fetch origin dev
rtk git fetch onetcli-upstream dev
rtk git switch -c sync/onetcli-YYYYMMDD origin/dev
rtk git merge --no-commit --no-ff onetcli-upstream/dev
rtk git restore --source=HEAD --staged --worktree -- docs
rtk git rm --ignore-unmatch .github/workflows/release-docs.yml .github/workflows/test-docs.yml
rtk .codex/skills/syncing-onetcli-upstream/scripts/check-sync-contract.sh
```

## Stop Conditions

- Stop for a dirty worktree, unexpected remote URL, unresolved product decision, or destructive action.
- If the merge is already up to date, report that fact without creating an empty commit.
- Do not modify unrelated formatting merely to make full-repository formatting clean.
- Do not claim completion or push until review and fresh verification evidence exist.
