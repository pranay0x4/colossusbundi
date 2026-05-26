# Media Pipeline Incidents

This page captures the main issues recorded while bringing up the Jellyfin-based media stack.

## Services Involved

- Jellyfin
- Jellyseerr
- Radarr
- Sonarr
- Prowlarr
- qBittorrent

## Incident 1: Services existed but were not actually running

### What happened

Jellyfin had been installed, but the container was not running when checked later.

### Fix

- started the container
- validated the service through the TV client workflow

### Lesson

Installation is not deployment. Always verify running state and restart policy.

## Incident 2: Containers stopped after reboot

### What happened

After a reboot, Sonarr and Radarr were down.

### Fix

- restarted the containers manually
- enabled Docker restart behavior with `unless-stopped`

### Lesson

Reboot behavior is part of production behavior, even in a homelab.

## Incident 3: Early storage layout was not persistent enough

### What happened

While refactoring, old containers were removed and important config/data from the earlier layout disappeared with them.

### Fix

- reorganized the system around clearer persistent paths
- moved toward `/opt` for service state and `/mnt` for media data
- treated the compose file plus configs plus mounted data as the rebuild baseline

### Lesson

A service stack is only reproducible if state boundaries are explicit.

## Incident 4: Indexers and inter-service connectivity were fragile

### What happened

The full media pipeline required repeated debugging across:

- missing installs
- broken containers
- inaccessible media libraries
- failed indexers
- API integration failures
- multi-service communication issues

Some indexers did not work while others did, which suggested location or availability constraints on top of normal config issues.

### Fix

The build notes do not include every command, but they do confirm the end state:

- Jellyseerr requests reached Radarr/Sonarr
- Radarr/Sonarr used Prowlarr-backed indexers
- qBittorrent handled downloads
- content was organized into the media library
- Jellyfin served the resulting content across devices

### Lesson

Media automation stacks fail at integration boundaries more often than at individual containers. The hard part is the chain, not the icons.
