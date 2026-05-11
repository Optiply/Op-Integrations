# Shared integration helpers

Shared code belongs here only when multiple connectors need it.

Default rule: start helper code inside the connector folder (`etl/<slug>/utils/`, `taps/tap-<slug>/...`, or `targets/target-<slug>/...`). Move it to `shared/` after there is a real second user. That keeps one-off connector quirks from becoming fake platform abstractions.

Never put credentials, tenant payloads, or generated sync output here.
