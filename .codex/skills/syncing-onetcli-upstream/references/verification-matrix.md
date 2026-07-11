# Synchronization Verification Matrix

Run checks proportionally to the changed crates, but never omit the contract check, diff review, or whitespace check.

## Required checks

1. `rtk .codex/skills/syncing-onetcli-upstream/scripts/check-sync-contract.sh`
2. `rtk git diff --cached --stat` before committing, or `rtk git show --stat --summary HEAD` after committing
3. Apply the `git diff --check` whitespace gate: run `rtk git diff --cached --check` before committing, or `rtk git diff HEAD^1 HEAD --check` for the merge commit.
4. Confirm no changed path starts with `docs/`.
5. Confirm both docs workflow files are absent.
6. Review all additions containing `OnetCli`, `Onet CLI`, `Onetcli`, or `feigeCode/onetcli` and classify each as forbidden public branding or allowed compatibility.
7. Run tests for every changed crate and its direct integration surface.
8. Run `rtk cargo check -p main` when application code, workspace dependencies, or shared crates change.
9. Run packaging tests when release scripts, resources, updater code, or artifact naming changes.
10. Use `superpowers:requesting-code-review` before integration and `superpowers:verification-before-completion` before any completion claim.

## Known baseline

Full-workspace formatting may report pre-existing differences in:

- `crates/db_view/src/sql_editor.rs`
- `crates/db_view/src/table_data/results_delegate.rs`

Do not edit unrelated baseline files during an upstream sync. Report the baseline separately from synchronization regressions.

## Handoff report

Report the upstream commit, Navop base commit, synchronization branch, included/excluded file counts, conflict decisions, old-brand classifications, commands run with results, remaining baselines, and pushed branch. Never state that Navop `dev` was updated unless it was explicitly authorized and actually performed.
