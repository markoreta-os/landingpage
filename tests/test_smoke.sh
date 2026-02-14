#!/usr/bin/env bash
# Smoke tests for oretasolutions.com static placeholder page
# Run from project root: bash tests/test_smoke.sh

set -uo pipefail

PASS=0
FAIL=0
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

pass() { echo "  PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL + 1)); }

echo "Running smoke tests for oretasolutions..."
echo ""

# --- Test 1: index.html exists and has valid HTML5 structure ---
echo "Test 1: HTML file exists and is valid"
if [[ -f "$ROOT/index.html" ]]; then
    pass "index.html exists"
else
    fail "index.html not found"
fi

if grep -q '<!DOCTYPE html>' "$ROOT/index.html" 2>/dev/null; then
    pass "Contains DOCTYPE"
else
    fail "Missing <!DOCTYPE html>"
fi

if grep -q '<meta name="viewport"' "$ROOT/index.html" 2>/dev/null; then
    pass "Contains viewport meta tag"
else
    fail "Missing viewport meta tag"
fi

echo ""

# --- Test 2: Hero image is referenced and exists ---
echo "Test 2: Hero image is referenced"
IMG_REF=$(grep -oE '(src|url\()=?["'"'"']*[^"'"'"'\)]+\.(jpg|jpeg|png|webp|avif)' "$ROOT/index.html" 2>/dev/null | head -1 || true)

if [[ -n "$IMG_REF" ]]; then
    pass "Image referenced in HTML"
else
    fail "No image reference found in index.html"
fi

# Extract just the filename/path from the match
IMG_PATH=$(echo "$IMG_REF" | grep -oE '[^"'"'"'(]+\.(jpg|jpeg|png|webp|avif)' | head -1 || true)
if [[ -n "$IMG_PATH" && -f "$ROOT/$IMG_PATH" ]]; then
    pass "Referenced image file exists: $IMG_PATH"
else
    fail "Referenced image file not found: ${IMG_PATH:-unknown}"
fi

echo ""

# --- Test 3: CSS ensures full viewport coverage ---
echo "Test 3: Image fills viewport (CSS)"
# Check for full viewport styles (inline or in a CSS file)
ALL_CONTENT=$(cat "$ROOT/index.html" "$ROOT"/*.css 2>/dev/null || true)

if echo "$ALL_CONTENT" | grep -qE '(100vh|100%)'; then
    pass "Full height style found"
else
    fail "Missing 100vh or 100% height"
fi

if echo "$ALL_CONTENT" | grep -qE '(object-fit:[[:space:]]*cover|background-size:[[:space:]]*cover)'; then
    pass "Cover style found (object-fit or background-size)"
else
    fail "Missing object-fit: cover or background-size: cover"
fi

if echo "$ALL_CONTENT" | grep -qE 'margin:[[:space:]]*0'; then
    pass "Body margin reset found"
else
    fail "Missing margin: 0 on body"
fi

echo ""

# --- Test 4: CNAME file for custom domain ---
echo "Test 4: CNAME file exists"
if [[ -f "$ROOT/CNAME" ]]; then
    pass "CNAME file exists"
else
    fail "CNAME file not found"
fi

if grep -q 'oretasolutions.com' "$ROOT/CNAME" 2>/dev/null; then
    pass "CNAME contains oretasolutions.com"
else
    fail "CNAME does not contain oretasolutions.com"
fi

echo ""

# --- Test 5: No unnecessary files ---
echo "Test 5: Repo hygiene"
if [[ -f "$ROOT/.gitignore" ]]; then
    pass ".gitignore exists"
else
    fail ".gitignore not found"
fi

if [[ ! -d "$ROOT/node_modules" ]]; then
    pass "No node_modules directory"
else
    fail "node_modules directory found — should not be committed"
fi

echo ""

# --- Summary ---
echo "========================="
echo "Results: $PASS passed, $FAIL failed"
echo "========================="

if [[ $FAIL -gt 0 ]]; then
    exit 1
fi
