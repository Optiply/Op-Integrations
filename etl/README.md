# ETLs

HotGlue/Optiply ETLs live here under `etl/<slug>/`.

Expected layout:

```text
etl/<slug>/
  etl.ipynb              # canonical notebook when HotGlue uses a notebook
  requirements.txt       # runtime deps if needed
  utils/                 # reusable transform/payload helpers for this ETL
```

## Expectations

- Keep transforms deterministic for the same tap snapshot input.
- Keep source-field to Optiply-field mapping docs in `docs/<slug>/data-mapping.md`.
- Avoid committing sync outputs, snapshots, customer payload dumps, or generated caches.
- Promote helper code to `shared/` only once more than one integration needs it.

Current ETLs:

- `extend`
