#!/usr/bin/env bash
# 各 works-* リポジトリの main を取得して dist/<サイト名>/ に配置する。
# 一覧ページは dist/_top/ に置く（dist 直下にファイルを置かないため。理由は README を参照）。
set -euo pipefail

OWNER="ibuki314"
ROOT="$(cd "$(dirname "$0")" && pwd)"
DIST="$ROOT/dist"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

rm -rf "$DIST"
mkdir -p "$DIST/_top"
cp -R "$ROOT/top/." "$DIST/_top/"

grep -vE '^\s*(#|$)' "$ROOT/sites.txt" | while IFS='|' read -r name subdir _label; do
  echo "→ works-$name"
  mkdir -p "$TMP/$name"
  curl -fsSL "https://codeload.github.com/$OWNER/works-$name/tar.gz/refs/heads/main" \
    | tar -xz -C "$TMP/$name" --strip-components 1
  mkdir -p "$DIST/$name"
  cp -R "$TMP/$name/$subdir/." "$DIST/$name/"
done

echo "done: $(find "$DIST" -type f | wc -l | tr -d ' ') files"
