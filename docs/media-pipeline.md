# Media Pipeline

## Why I Built It

Instead of manually downloading movies, renaming them, and moving them to folders, I wanted to automate the entire process. The cool part of this setup wasn't just installing the apps—it was getting them all to talk to each other, restart automatically if the laptop reboots, and share the right folders without getting permission errors.

---

## How It Works (The Workflow)

Here's the path a request takes:

`Me (or a friend) -> Jellyseerr -> Prowlarr -> Sonarr/Radarr -> qBittorrent -> Jellyfin -> My TV/Phone`

Here's what each app does:
- **Jellyseerr:** The request page. I or my friends can search for a movie/show and click "Request".
- **Prowlarr:** Manages the search indexers. Sonarr and Radarr talk to Prowlarr to find where the files are hosted.
- **Sonarr & Radarr:** Sonarr is for TV shows, Radarr is for movies. They look for the requested files, send them to the download client, and rename/organize them once they're done.
- **qBittorrent:** Downloads the files and tells Sonarr/Radarr when they are finished.
- **Jellyfin:** My personal streaming app (like self-hosted Netflix). It scans the folders and streams the video to my devices.

---

## Storage & Network Setup

To make sure these containers can communicate and share files, I did two things:
1. **Docker Network:** I put all these containers on a custom Docker network. This lets them resolve each other by container name (e.g., Radarr can just connect to `http://prowlarr:9696`) instead of hardcoding IP addresses.
2. **Standard Folder Structures:** Docker path mapping is tricky. If qBittorrent downloads a file to `/downloads` but Sonarr expects to find it in `/mnt/downloads`, the import will fail. I mapped the exact same paths on the host and inside the containers:
   - Configs: `/opt/services/<app-name>`
   - Downloads: `/mnt/downloads`
   - Media Library: `/mnt/media`

---

## What Broke & How I Debugged It

- **Mismatched Paths:** Initially, Sonarr couldn't import downloaded files because it had a different filesystem mount mapping than qBittorrent. Once I standardized the mounts under `/mnt` across all containers, this was fixed.
- **Silent Crashes:** Sometimes a container would crash or fail to start after a reboot because I didn't set a restart policy. I added `restart: unless-stopped` to every service in my compose file.
- **API Wiring Problems:** I had to generate API keys for each service and copy them between the apps. A single typo in an API key or port number would break the whole automation chain. I had to test each connection step-by-step to get it working.

---

## How I Backup & Recover

By separating my files, the recovery plan is simple:
- The `docker-compose.yml` file has the layout configuration.
- `/opt` holds all the database and configuration files for my apps.
- `/mnt` holds all my downloaded media.

If I ever need to move this setup to a new server, I just need to copy `/opt` and `/mnt`, run `docker compose up -d`, and everything should start up exactly where it left off.
