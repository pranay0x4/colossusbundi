# Build Log

This timeline is reconstructed from dated notes and screenshots captured during the build. It is intentionally concise and only includes events that were explicitly recorded.

## 14 May

- Installed Ubuntu Server from a bootable USB created on macOS.
- Hit missing Wi-Fi tools/packages on the minimal server install.
- Used Android USB tethering to get temporary internet access.
- Installed `NetworkManager` and related utilities.
- Switched the Netplan renderer and disabled `systemd-networkd`.
- Resolved the unmanaged `wlp2s0` issue and connected over Wi-Fi using `nmcli`.
- Installed Tailscale and Docker for remote administration and container work.
- Investigated an apparent storage shortfall and identified standard Linux LVM layout as the cause.
- Learned that the machine was operating in a TTY-only environment, so X11-dependent display commands failed.
- Reworked lid-close and display behavior so the machine could stay running headlessly 24x7.

## 19 May

- Brought up Jellyfin after finding the container was installed but not running.
- Created core media directories for movies, photos, and shows.
- Validated playback workflow on Fire TV.
- Revisited SSH access from a phone-based client workflow.
- After a reboot, noticed Sonarr and Radarr were stopped and corrected container restart policy with `unless-stopped`.
- Finished the first end-to-end version of the media stack: Jellyfin, qBittorrent, Radarr, Sonarr, Jellyseerr, and Prowlarr.
- Debugged issues involving missing installs, broken containers, non-persistent Docker storage, inaccessible media libraries, failed indexers, API integrations, and inter-service communication.
- Identified the need for reverse proxies and potentially SSO because separate service logins were already becoming annoying.
- Found that some indexers failed while others worked, likely due to location/availability constraints.

## 21 May

- Set up local reverse proxies with NGINX.
- Added host mappings on macOS so names like `jellyfin.home` resolved locally.

## 23 May

- Considered Pi-hole and decided not to proceed after recognizing both outage risk and ISP/router DNS limitations.
- Installed Homepage with Docker Compose.
- Fixed a host-related Homepage issue by editing its YAML and setting the host IP explicitly.
- Started thinking more clearly in terms of separate compose domains such as media and supporting stacks.

## 24 May

- Refactored filesystem layout toward `/mnt` and `/opt`.
- Removed old containers and discovered the earlier state layout was not resilient enough, because config and data disappeared with the old setup.
- Rebuilt around the idea that compose plus config plus mounted data should be enough to recreate the server.
- Noted that firewall and permissions still remain part of a full rebuild story.

## 25 May

- Brought Homepage back with connected services, while noting the media pipeline still needed repair after the refactor.
- Installed Glances in `/opt/services` with Compose.
- Installed Ollama in Docker and ran `gemma2:2b`.
- Observed severe thermal increase during local inference and killed the workload.
- Started composing Immich, though the stack was not yet fully completed.
- Continued troubleshooting reverse proxies.
- Worked through a WireGuard setup failure:
  - initial config edits did not produce a handshake
  - `SaveConfig=True` kept overwriting the intended configuration
  - bringing the interface down and back up forced the runtime to reload from the saved file
  - the final working fix was recreating keys and peers cleanly after copy/paste errors
- Confirmed SSH worked over the VPN address `10.10.0.1`.
- Realized ISP CGNAT still blocked the broader goal of straightforward inbound IPv4 exposure.

## Durable Lessons From The Timeline

- Solve access and recoverability early.
- A working prototype is not the same as a recoverable deployment.
- Filesystem layout matters more after the first failure.
- Networking problems often combine host config mistakes with upstream ISP constraints.
- Clean rebuilds are sometimes the fastest debugging move.
