# Targets

Singer targets live here under `target-<slug>/`.

Targets are write-side components. Treat them with more caution than taps:

- Document destination write semantics before implementation: create/update/upsert/delete.
- Make retries idempotent where the destination API supports it.
- Keep production/customer writes approval-gated.
- Add fake/example config only; never commit real tokens or customer payloads.

Expected layout:

```text
targets/target-<slug>/
  target_<slug_with_underscores>/
    __init__.py
    target.py
  config.json.example
  pyproject.toml
  README.md
  tests/
```

No production-ready targets are currently checked into this repo.
