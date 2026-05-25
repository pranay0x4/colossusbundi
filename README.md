# colossusbundi

Self-hosted homelab infrastructure project focused on:

- Media automation
- Remote networking
- Container orchestration
- Linux systems
- Reverse proxying
- Monitoring and observability
- Local AI inference

Built during a 2-week obsession sprint from a small town in Rajasthan.

---

## Core Stack

### Media & Automation
- Jellyfin
- Jellyseerr
- Radarr
- Sonarr
- Prowlarr
- qBittorrent

### Infrastructure
- Docker Compose
- NGINX
- Tailscale
- WireGuard experimentation
- Cloudflare Tunnel (planned)

### Monitoring & Dashboards
- Glance
- Homepage
- Uptime Kuma

### AI
- Ollama local inference

---

## Highlights

- Remote media request → automated download → TV playback workflow
- Cross-device remote SSH access using Tailscale
- Structured Linux filesystem organization using `/opt` and `/mnt`
- Containerized service management with Docker Compose
- Reverse proxy and networking experimentation
- Monitoring and observability setup
- Local LLM experimentation on constrained hardware

---

## Repository Structure

```txt
compose/        → Docker Compose stacks
configs/        → Service configurations
docs/           → Architecture, setup, troubleshooting
diagrams/       → Infrastructure diagrams
screenshots/    → UI and deployment screenshots
scripts/        → Utility scripts
```

---

## Current Focus

- Cloudflare Tunnel setup
- HTTPS exposure
- Backup strategy
- Home automation experimentation
- Infrastructure documentation