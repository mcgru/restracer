---
name: debhelper-compat-single-source
description: debhelper compat level must be declared in exactly one place — either debian/compat or Build-Depends, not both
source: auto-skill
extracted_at: '2026-06-16T05:29:28.381Z'
---

# Debhelper compat must be declared once, not twice

## The error

```
dh: warning: Please specify the debhelper compat level exactly once.
dh: warning:  * debian/compat requests compat 13.
dh: warning:  * debian/control requests compat 13 via "debhelper-compat (= 13)"
dh: error: debhelper compat level specified both in debian/compat and via build-dependency on debhelper-compat
```

## Cause

The compat level is declared in **two** places:
1. `debian/compat` file containing `13`
2. `debian/control` with `Build-Depends: debhelper-compat (= 13)`

`dh` sees both and refuses to guess which one to use.

## Fix

**Remove `debian/compat`** — the modern approach is via Build-Depends:

```control
Build-Depends: debhelper-compat (= 13), make, g++, ...
```

Delete the file:
```bash
rm debian/compat
```

## Why this happens

Older packaging guides recommend a `debian/compat` file. Newer guides recommend `debhelper-compat (= N)` in Build-Depends. Debhelper itself warns about duplicate declarations starting from compat level 10+. The project had both because they were added from different sources during initial packaging.
