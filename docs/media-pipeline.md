# Media Pipeline

## Purpose

This stack was built to automate service coordination rather than to maximize content acquisition. The interesting engineering work was in making several independent services communicate reliably, recover after restarts, and operate from consistent storage paths.

## Workflow

The main request path is:

`Remote user -> Jellyseerr -> Prowlarr -> Sonarr/Radarr -> qBittorrent -> Jellyfin -> playback client`

Each component has a narrow role:

- `Jellyseerr` receives user requests and provides the approval interface.
- `Prowlarr` centralizes indexer configuration so Sonarr and Radarr do not each need separate indexer management.
- `Sonarr` and `Radarr` decide what to monitor and when items should be imported.
- `qBittorrent` handles downloads and exposes a stable API target for the automation services.
- `Jellyfin` indexes the resulting library and serves playback to local or remote clients.

## Service Boundaries

Three decisions made the stack easier to manage:

- Use Docker networks so services can reach each other by container name instead of host IPs.
- Keep service configs under `/opt/<service>` and media/data under `/mnt/...`.
- Reuse the same download and library paths inside each container to avoid mismatched import paths.

Example path model:

- configs: `/opt/services/<service>`
- downloads: `/mnt/downloads`
- media library: `/mnt/media`

This path consistency matters because Sonarr and Radarr need to see the same filesystem view that qBittorrent uses, or imports fail even though downloads complete.

## Operational Issues Encountered

The biggest failures were not application bugs. They were coordination issues:

- containers started but could not see the expected library paths
- restarts broke services that lacked proper restart policies
- initial container layouts mixed data and config too casually
- indexers worked in one service but not across the full chain
- service APIs were reachable individually but not wired correctly end to end

The fix was to treat the pipeline as a system instead of a group of isolated apps. That meant standardizing mounts, rebuilding the Compose layout, and testing each hop one by one.

## Recovery Strategy

After the storage refactor, the working assumption became:

- the Compose YAML describes service topology
- `/opt` contains service state and configuration
- `/mnt` contains durable data

With those three pieces preserved, the stack can be recreated without repeating the entire debugging cycle. That change was more valuable than adding new services.

## What This Demonstrates

This part of the project shows:

- multi-service integration
- container networking and persistence design
- restart and recovery planning
- practical debugging across API, storage, and reverse proxy layers
