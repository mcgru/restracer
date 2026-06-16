---
name: makefile-deps-per-distro
description: Adding per-distro deps-* targets to a Makefile that install build/runtime dependencies via the native package manager with sudo
source: auto-skill
extracted_at: '2026-06-16T06:13:44.846Z'
---

# Per-distro `deps-*` Makefile targets

## Pattern

Add a group of Makefile targets, one per distro, that install the project's build dependencies via the distro's native package manager using `sudo`. Each target is named `deps-<distro>` and uses `-y`/`--noconfirm` for non-interactive use.

## Template

```makefile
deps-debian:
	sudo apt-get install -y build-essential libxml++2.6-dev dpkg-dev debhelper

deps-redhat:
	sudo dnf install -y make libxml++-devel gcc-c++ findutils diffutils psmisc rpm-build

deps-gentoo:
	sudo emerge dev-cpp/libxmlpp dev-util/pkgconfig

deps-arch:
	sudo pacman -S --noconfirm make gcc libxml++

deps-freebsd:
	sudo pkg install -y libxml++ gmake gsed pkgconf

deps-alt:
	sudo apt-get install -y make gcc-c++ libxml++2-devel
```

## Key details

- **`sudo`** — these install system packages, so root is required
- **`-y` / `--noconfirm`** — essential for non-interactive use in CI or scripts
- **Package names vary by distro** — e.g. `libxml++2.6-dev` (Debian) vs `libxml++-devel` (Fedora) vs `dev-cpp/libxmlpp` (Gentoo)
- **Bundle additional build tools** — e.g. `dpkg-dev debhelper` for `.deb` builds, `rpm-build` for `.rpm`
- **Use `build-essential` on Debian** — it pulls in `gcc`, `g++`, `make`, `libc6-dev`, and satisfies `dpkg-buildpackage`'s implicit dependency on `build-essential:native`

## Companion pattern: `command -v` guard

When a Makefile target depends on a tool installed by `deps-*`, guard with `command -v` for a clear error:

```makefile
deb:
	@command -v dpkg-buildpackage >/dev/null 2>&1 || { echo "dpkg-buildpackage not found. Please run: make deps-debian"; exit 1; }
	dpkg-buildpackage -us -uc -b
```

This produces a readable message instead of `/bin/sh: dpkg-buildpackage: not found`.
