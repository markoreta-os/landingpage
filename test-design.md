# Test Design

## Overview

Based on: seed.md (Phase 1)
Scope: Small
Type: Static single-page site — no backend, no logic

## Test Strategy

No unit or integration tests needed — there is no application logic. All tests are smoke/validation tests verifying the static page meets acceptance criteria.

**Test approach:** Simple shell-based validation + browser check

## Test Structure

```
tests/
└── test_smoke.sh    # Validates HTML structure, image reference, responsive CSS
```

## Smoke Tests

### 1. `HTML file exists and is valid`

**Verifies:** index.html exists at the root and contains valid HTML5 structure

**Check:**
- `index.html` exists
- Contains `<!DOCTYPE html>`
- Contains `<html`, `<head>`, `<body>` tags
- Contains viewport meta tag for responsiveness

---

### 2. `Hero image is referenced`

**Verifies:** The HTML references an image file that exists in the repo

**Check:**
- `index.html` references an image (img tag or CSS background-image)
- The referenced image file exists in the repo

---

### 3. `Image fills viewport (CSS)`

**Verifies:** CSS ensures the image covers the full viewport with no scrollbars

**Check:**
- CSS includes rules for full viewport coverage (width: 100vw/100%, height: 100vh/100%, object-fit: cover or background-size: cover)
- Body has margin: 0 / padding: 0 (no default whitespace)
- overflow: hidden is set (no scrollbars)

---

### 4. `CNAME file exists for custom domain`

**Verifies:** GitHub Pages custom domain is configured

**Check:**
- `CNAME` file exists
- Contains `oretasolutions.com`

---

### 5. `No unnecessary files`

**Verifies:** Repo is clean — only what's needed for the static page

**Check:**
- No node_modules, .env, or build artifacts
- .gitignore exists

---

## Manual Verification (Phase 8 exit gate)

- [ ] Open index.html in browser — image fills entire viewport
- [ ] Resize browser window — image stays full-screen, no scrollbars
- [ ] Open on mobile viewport (devtools) — image fills screen
- [ ] Check network tab — only 1-2 requests (HTML + image)
- [ ] Image loads in under 3 seconds on typical connection

## Coverage Summary

| Category | Tests | Notes |
|----------|-------|-------|
| Structure validation | 3 | HTML, image ref, CSS |
| Deployment config | 1 | CNAME |
| Hygiene | 1 | No junk files |
| Manual visual | 5 | Browser verification |

Total automated: 5 checks
Total manual: 5 checks
