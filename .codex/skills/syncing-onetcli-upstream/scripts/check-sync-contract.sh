#!/usr/bin/env bash
set -euo pipefail

readonly UPSTREAM_URL="git@github.com:feigeCode/onetcli.git"
readonly RELEASE_DOCS=".github/workflows/release-docs.yml"
readonly TEST_DOCS=".github/workflows/test-docs.yml"

fail() {
  printf 'sync contract failed: %b\n' "$*" >&2
  exit 1
}

require_tooling() {
  command -v rtk >/dev/null || fail "rtk is required"
  rtk git rev-parse --is-inside-work-tree >/dev/null 2>&1 || fail "run inside a git worktree"
}

select_diff() {
  if ! rtk git diff --cached --quiet; then
    DIFF_ARGS=(--cached)
    DIFF_LABEL="staged merge"
  elif test "$(rtk git rev-list --parents -n 1 HEAD | rtk wc -w)" -eq 3; then
    DIFF_ARGS=(HEAD^1 HEAD)
    DIFF_LABEL="current merge commit"
  elif test "$#" -eq 1; then
    DIFF_ARGS=("$1" HEAD)
    DIFF_LABEL="$1..HEAD"
  else
    fail "no staged merge; pass the Navop base ref or run on a merge commit"
  fi
}

check_remote() {
  local actual
  actual="$(rtk git remote get-url onetcli-upstream 2>/dev/null)" || fail "missing onetcli-upstream remote"
  test "$actual" = "$UPSTREAM_URL" || fail "onetcli-upstream is $actual"
}

check_excluded_paths() {
  local changed
  changed="$(rtk git diff "${DIFF_ARGS[@]}" --name-only)"
  if rtk rg -q '^docs/' <<<"$changed"; then
    fail "docs changes are present"
  fi
  test ! -e "$RELEASE_DOCS" || fail "$RELEASE_DOCS exists"
  test ! -e "$TEST_DOCS" || fail "$TEST_DOCS exists"
}

added_lines() {
  rtk git diff "${DIFF_ARGS[@]}" -U0 \
    | rtk sed -n '/^+++ /d; /^+/s/^+//p'
}

check_public_brand() {
  local added forbidden candidates
  added="$(added_lines)"
  forbidden="$(rtk rg -n 'feigeCode/onetcli' <<<"$added" || true)"
  test -z "$forbidden" || fail "old public repository URL added:\n$forbidden"
  candidates="$(rtk rg -n 'Onet([[:space:]]+CLI|[[:space:]]*Cli|cli)|ONET[[:space:]]+CLI' <<<"$added" \
    | rtk rg -v 'OnetCliApp|ProviderType::OnetCli|::OnetCli|^[^:]+:[[:space:]]*(//|///|/\*|\*)' || true)"
  test -z "$candidates" || fail "review newly added old-brand text:\n$candidates"
}

require_contract_markers() {
  rtk rg -q 'Navop\.app' main script resources README.md README_CN.md || fail "Navop.app marker missing"
  rtk rg -q 'Navop\.icns' script resources || fail "Navop.icns marker missing"
  test -f NAVOP_LICENSE || fail "NAVOP_LICENSE missing"
  test -f resources/navop-icon.png || fail "Navop icon missing"
  rtk rg -q 'ProviderType::OnetCli' crates main || fail "provider compatibility missing"
  rtk rg -q 'onetcli\.app_info' crates main || fail "MCP compatibility missing"
  rtk rg -q 'com\.onetcli\.app' resources main || fail "bundle identifier compatibility missing"
  rtk rg -q 'OnetCli\.app' main || fail "legacy updater compatibility missing"
}

main() {
  require_tooling
  select_diff "$@"
  check_remote
  check_excluded_paths
  check_public_brand
  require_contract_markers
  rtk git diff "${DIFF_ARGS[@]}" --check
  echo "sync contract passed ($DIFF_LABEL)"
}

main "$@"
