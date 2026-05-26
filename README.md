# colossusbundi

`colossusbundi` is a real self-hosted infrastructure project built on an old Ryzen laptop running Ubuntu Server.

The core goal was practical: make media requestable remotely, move it through an automated download pipeline, and stream it reliably to a TV-based Jellyfin setup while learning Linux, Docker, networking, and remote access by doing the work end to end.

This repository is intentionally documented like an engineering project, not a template. It captures what was actually built, what broke, what got refactored, and what still needs cleanup before the full sanitized compose/config exports are committed.

## What’s Running

### Media pipeline
- Jellyfin
- Jellyseerr
- Radarr
- Sonarr
- Prowlarr
- qBittorrent

### Access and networking
- Tailscale for remote SSH and private access
- NGINX reverse proxy for local service routing
- WireGuard experimentation for self-managed VPN access
- Cloudflare Tunnel as a planned next step for safer remote publishing

### Monitoring and dashboards
- Homepage
- Glance
- Uptime Kuma

### Local AI
- Ollama with lightweight local models

## Why This Repo Matters

- It is based on a real deployment on constrained consumer hardware, not cloud-only infra.
- It includes operational lessons from Wi-Fi bootstrap pain, CGNAT limitations, reverse proxy debugging, container persistence mistakes, and VPN misconfiguration.
- The system serves actual users and devices, including TV playback through Jellyfin.
- The repo is structured to show engineering judgment: what was automated, what remained manual, what failed, and what was learned.

## Current Architecture

High-level flow:

1. A user requests media in Jellyseerr.
2. Jellyseerr hands off to Radarr or Sonarr.
3. Radarr or Sonarr uses Prowlarr indexers and sends downloads to qBittorrent.
4. Completed downloads are organized into the media library.
5. Jellyfin scans the library and serves playback to clients, including a Fire TV setup.

Supporting layers:

- Docker Compose for service orchestration
- `/opt` for service/application state
- `/mnt` for persistent media data
- Tailscale and SSH for remote administration
- NGINX for local reverse proxying
- Homepage/Glance/Uptime Kuma for visibility

More detail: [docs/architecture/stack-overview.md](/Users/pranay/colossusbundi/docs/architecture/stack-overview.md)

## Repository Status

The repository structure is ready, but the actual compose manifests and configs have not been fully exported into Git yet.

That is deliberate for now:

- secrets and private network details need sanitization
- some production paths and hostnames still need cleanup
- the system was refactored live, so the documented shape is ahead of the committed manifests

Until those sanitized exports are added, this repo focuses on architecture, setup decisions, operational notes, and troubleshooting history grounded in the actual build process.

## Repository Layout

```txt
compose/
  media-stack/      Compose files for Jellyfin/Jellyseerr/Radarr/Sonarr/Prowlarr/qBittorrent
  monitoring/       Compose files for Homepage/Glance/Uptime Kuma
  networking/       Reverse proxy and tunnel-related manifests
  ai-stack/         Ollama and local inference experiments
configs/            Sanitized service configs and reverse proxy snippets
docs/
  architecture/     System layout and service relationships
  setup/            Bootstrap and deployment notes
  timeline/         Build history reconstructed from dated notes
  troubleshooting/  Real incidents, causes, and fixes
  future-plans/     Next improvements with realistic scope
diagrams/           Mermaid and diagram assets
screenshots/        Exported UI or terminal screenshots
scripts/            Utility scripts
assets/             Images and presentation assets
```

## Best Docs To Read First

- [Stack overview](/Users/pranay/colossusbundi/docs/architecture/stack-overview.md)
- [Server bootstrap notes](/Users/pranay/colossusbundi/docs/setup/server-bootstrap.md)
- [Build timeline](/Users/pranay/colossusbundi/docs/timeline/build-log.md)
- [WireGuard and CGNAT notes](/Users/pranay/colossusbundi/docs/troubleshooting/cgnat-wireguard.md)
- [Media pipeline incidents](/Users/pranay/colossusbundi/docs/troubleshooting/media-pipeline.md)

## What Was Learned

- Ubuntu Server on minimal install often needs explicit networking work before it becomes pleasant to operate remotely.
- Compose files are only half the story; mount layout and persistent storage boundaries matter just as much.
- Reverse proxies and private networking are easy to make partially work and harder to make understandable.
- Under constrained hardware, observability and thermal awareness matter even for small local AI experiments.
- Rebuilding from clean state is sometimes faster than debugging corrupted runtime state.

## Next Additions

- Commit sanitized compose manifests for each stack
- Add sanitized NGINX examples and tunnel configs
- Document backup and restore strategy
- Add service dependency diagrams tied directly to real manifests
- Export a small set of screenshots into `screenshots/` for the public repo
