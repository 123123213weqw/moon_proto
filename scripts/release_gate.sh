#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# The MoonBit installer places the CLI here on both local macOS and Linux CI.
# Keep this script usable from non-login shells as well.
if [ -x "$HOME/.moon/bin/moon" ]; then
  export PATH="$HOME/.moon/bin:$PATH"
fi

run() {
  printf '\n==> %s\n' "$*"
  "$@"
}

expect_fail() {
  local description="$1"
  shift
  printf '\n==> expected failure: %s\n' "$description"
  set +e
  "$@"
  local status=$?
  set -e
  if [ "$status" -eq 0 ]; then
    echo "expected command to fail but it passed: $*" >&2
    return 1
  fi
  echo "expected failure observed: $description"
}

if ! command -v moon >/dev/null 2>&1; then
  echo "moon command not found. Install MoonBit or run this script on the configured Linux server." >&2
  exit 127
fi

run moon version

# Cross-language fixture oracles are part of the verification story.  They are
# skipped only when explicitly requested by release infrastructure.
if [ "${MOON_PROTO_SKIP_ORACLES:-0}" != "1" ]; then
  run python3 tests/oracle/python_protobuf_oracle.py
  if command -v go >/dev/null 2>&1; then
    run bash -lc 'cd tests/oracle && go run .'
  else
    echo "go command not found; skipping Go oracle. Set up Go to run the full gate." >&2
  fi
fi

run moon fmt --check
run moon info
run git diff --exit-code -- pkg.generated.mbti cmd/main/pkg.generated.mbti
run moon package
run moon check
run moon build
run moon test
run moon test --target all
run moon run cmd/main -- gen --example
run tests/codegen/compile_generated.sh

# Reviewer-facing AI verification smoke cases.
run python3 scripts/moon_proto_lab.py verify \
  examples/ai/good_order.proto \
  --report generated/ai_good_order_verify_report.md \
  --junit-out generated/ai_good_order_verify_report.xml
run python3 scripts/moon_proto_lab.py compat \
  examples/ai/good_order.proto \
  examples/ai/good_order_v2.proto \
  --report generated/ai_good_order_compat_report.md \
  --junit-out generated/ai_good_order_compat_report.xml
expect_fail "Schema Doctor rejects deliberately broken AI schema" \
  python3 scripts/moon_proto_lab.py doctor examples/ai/bad_order.proto

printf '\nMoon Proto Lab release gate: PASS\n'
