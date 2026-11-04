#!/bin/sh
set -eu

if [ "$(uname -m)" = arm64 ]; then
  export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
fi

if ! command -v swiftlint >/dev/null 2>&1; then
  echo "SwiftLint is missing. Install it with: brew install swiftlint" >&2
  exit 127
fi

PROJECT_ROOT="${SRCROOT:-$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)}"
swiftlint lint --config "$PROJECT_ROOT/.swiftlint.yml" --quiet
