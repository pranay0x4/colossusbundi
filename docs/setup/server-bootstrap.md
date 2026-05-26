# Server Bootstrap Notes

This page documents the early host setup decisions that shaped the rest of the project.

It is based on dated build notes from 14 May through 25 May and intentionally records the rough edges, because those were part of the real work.

## Host Baseline

- Hardware: old Ryzen laptop repurposed as a server
- OS: Ubuntu Server minimal install
- Access model: primarily remote SSH
- Primary deployment model: Docker Compose on a single host

## Bootstrap Sequence

### 1. Get the host online first

The minimal Ubuntu Server install did not come up with a convenient Wi-Fi workflow out of the box. Temporary internet was established through Android USB tethering so the missing networking tools could be installed.

From there, the host was brought into a manageable state by:

- installing `NetworkManager` and related networking utilities
- changing the Netplan renderer
- disabling `systemd-networkd`
- fixing the unmanaged Wi-Fi interface state
- connecting to Wi-Fi through `nmcli`

Why this matters:

- remote infrastructure work starts with boring host bootstrap
- a minimal server image is not the same thing as a remotely operable server

### 2. Make remote access reliable immediately

Tailscale was installed early and quickly became the safest way to keep working from other devices. This reduced dependence on LAN-only access and made SSH usable across devices without needing to solve public inbound access first.

### 3. Fix storage understanding before scaling services

One early lesson was around storage visibility and Linux volume layout. The system initially showed less available space than expected, which turned out to be tied to a standard LVM partitioning layout rather than a missing disk.

This matters because media workloads are storage-shaped. Before adding many containers, it was important to understand what was actually mounted and where persistent data should live.

### 4. Treat the laptop like a headless server

The machine was running in a TTY-only environment, not a graphical X11 session. That meant display-related assumptions failed, including commands depending on `DISPLAY=:0`.

To keep the laptop usable as a remote server:

- the lid-close suspend path was disabled
- framebuffer-level display control was used to blank the panel
- `systemd-logind` and `acpid` behavior were adjusted so the host could stay running headlessly

This is an unusual but very real part of repurposing laptop hardware into infrastructure.

## Service Layout Principles

The project gradually moved toward:

- `/opt` for service config/state
- `/mnt` for persistent data such as media
- Compose files as the reproducible control plane

That layout emerged after mistakes, not before them. Earlier directory choices were workable, but less resilient when containers had to be removed and recreated.

## What Still Needs To Be Added Here

- sanitized host package/bootstrap commands
- sanitized directory tree examples
- exported compose manifests once secrets and private addresses are removed
