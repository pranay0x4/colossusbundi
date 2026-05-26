# Roadmap

This is a realistic next-step list, not a wishlist dump.

## Near Term

- commit sanitized compose files for each stack
- commit sanitized NGINX server blocks and upstream examples
- add a backup and restore document for `/opt` and `/mnt`
- export a small public set of screenshots into `screenshots/`
- document exact service dependencies once manifests are committed

## Medium Term

- test Cloudflare Tunnel as a safer answer to CGNAT-limited publishing
- tighten reverse proxy layout and hostname conventions
- improve dashboard usefulness instead of just listing links
- decide whether Immich belongs in the stable stack or in a separate experiment lane

## Not Planned Right Now

- Kubernetes migration
- premature IaC abstraction for a single-node homelab
- pretending this is a multi-region production platform

The point of this repository is practical systems work, not unnecessary complexity theater.
