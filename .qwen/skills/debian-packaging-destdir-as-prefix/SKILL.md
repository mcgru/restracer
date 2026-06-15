---
name: debian-packaging-destdir-as-prefix
description: Creating debian/ packaging when the upstream Makefile uses DESTDIR as the install prefix (not as staging root)
source: auto-skill
extracted_at: '2026-06-15T10:04:33.454Z'
---

# Debian packaging when Makefile DESTDIR is the prefix

## The problem

Standard build systems (autotools, cmake) treat `DESTDIR` as a **staging root** prepended to the full prefix:

```
DESTDIR=/tmp/staging make install  →  /tmp/staging/usr/bin/foo
```

But some hand-rolled Makefiles use `DESTDIR` as the **prefix itself**:

```
DESTDIR=/tmp/staging make install  →  /tmp/staging/bin/foo   ← wrong for Debian!
```

## How to detect

Read the Makefile's `install` target. If it does:

```makefile
DESTDIR?=/usr/local
install:
    mkdir -p $(DESTDIR)/bin
    cp ... $(DESTDIR)/bin
```

— then `DESTDIR` is the prefix, not a staging root. The giveaway: `$(DESTDIR)/bin` instead of `$(DESTDIR)$(PREFIX)/bin`.

## Fix in debian/rules

Map it to the Debian-expected path by adding `/usr`:

```makefile
export DESTDIR=$(CURDIR)/debian/restracer/usr

%:
	dh $@

override_dh_auto_build:
	make release -j$(shell nproc)

override_dh_auto_install:
	make install
```

This produces `debian/restracer/usr/bin/...` → packaged as `/usr/bin/...`. Without the extra `/usr`, files land in `debian/restracer/bin/` and `dpkg-deb` rejects or misplaces them.
