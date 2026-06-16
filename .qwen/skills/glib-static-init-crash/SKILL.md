---
name: glib-static-init-crash
description: Statically linked GLib applications crash at startup with g_quark_init assertion — cause and workarounds
source: auto-skill
extracted_at: '2026-06-16T06:13:44.846Z'
---

# Statically linked GLib applications crash with `g_quark_init` assertion

## The symptom

```
Bail out! GLib:ERROR:../glib/gquark.c:60:g_quark_init: assertion failed: (quark_seq_id == 0)
Aborted (core dumped)
```

Also appears with preceding messages:
```
GLib-CRITICAL: g_hash_table_lookup: assertion 'hash_table != NULL' failed
GLib-CRITICAL: g_hash_table_insert_internal: assertion 'hash_table != NULL' failed
```

## Cause

With static linking, GLib constructors can fire multiple times due to the way static initializers are triggered from different `.a` archives that each pull in GLib symbols. The `g_quark_init` function asserts it's called exactly once.

This is a known limitation of GLib + static linking — GLib's type system (`GType`) and quark system rely on one-time initialization that static linking can't guarantee.

## Workarounds

### 1. Skip runtime code generation (this project's approach)

If the GLib-linked binary is used as a **code generator** that only needs to run during build, pre-generate its output or skip that step in the static build. In our case, `artlibgen` generates template source files — we skipped `make -C src/artlibgen/templates` in the container and used host-built `artlibgen` instead.

### 2. Build GLib as both static and shared

```meson
meson setup _build --default-library=both
```

This allows linking the app against the shared GLib (which initializes correctly) while other deps remain static. Less pure but works.

### 3. Strip the assertion (not recommended)

Rebuild GLib with `-DG_DISABLE_ASSERT` or remove the assertion from `gquark.c`. Brittle and masks other issues.

### 4. Use `-Wl,--allow-multiple-definition`

Linker flag that silences multiple-definition errors but doesn't fix initialization order issues.

## Detection

After building a static binary:
```bash
file ./artlibgen
# artlibgen: ELF 64-bit LSB executable, statically linked, ...

./artlibgen  # try running it
# Bail out! GLib:ERROR:...g_quark_init: assertion failed...
```

If the binary is statically linked and uses GLib, this crash is expected on most GLib versions (tested on 2.66.8).
