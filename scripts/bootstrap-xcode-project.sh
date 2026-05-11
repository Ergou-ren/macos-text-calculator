#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "xcodegen is required to generate TextCalcMenuBar.xcodeproj from project.yml" >&2
  exit 1
fi

xcodegen generate
