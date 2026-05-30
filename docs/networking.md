# Networking

## Baseline Setup

The platform began on a minimal Ubuntu Server install on an old laptop. Networking was not ready out of the box. Wi-Fi tools were missing, and the first usable connection came from Android USB tethering just to get package access and fix the host properly.

The eventual approach was:

1. install `NetworkManager` and required wireless utilities
2. change the Netplan renderer so NetworkManager owned the interface
3. disable conflicting `systemd-networkd` behavior where needed
4. use `nmcli` to manage the wireless connection from the terminal

That sequence solved the early `unmanaged` interface issue and established a predictable headless workflow.

## Headless Administration

The laptop ran as a TTY-based server rather than a graphical desktop. That created a few practical constraints:

- `xset` and `DISPLAY=:0` assumptions were invalid because there was no X session
- lid-close suspend had to be disabled to keep the machine reachable remotely
- display blanking had to be handled through lower-level framebuffer or login manager behavior

The key lesson was simple: if a headless machine suspends, remote administration ends immediately. Reliability mattered more than perfect power saving.

## Remote Access Model

Private administration used:

- SSH for shell access
- Tailscale for reliable connectivity across networks

Tailscale was the default operational path because it reduced friction. It avoided router changes, gave a stable private address, and made remote SSH workable from a phone or laptop.

## WireGuard Experimentation

WireGuard was configured separately as a learning exercise and as a fallback remote access method. The process exposed several useful debugging patterns:

- check interface state separately from peer state
- validate key pairs before changing routing assumptions
- distrust copied configs if runtime state does not match disk state
- rebuild from scratch when configuration drift becomes harder to reason about than clean recreation

One specific issue was `SaveConfig=true`, which kept overwriting edited configuration state and made debugging misleading. Removing that, rebuilding the tunnel, and recreating keys cleanly resolved a large part of the confusion. A later handshake issue was traced to bad key material and was fixed by regenerating the peer configuration.

## CGNAT Reality

Direct public exposure was limited by carrier-grade NAT. Even with correct local configuration, inbound connectivity was unreliable because the ISP controlled the actual public edge.

This was an important design constraint, not just a networking annoyance. It forced a shift from "open ports and forward traffic" to "use overlay and tunnel-based access methods."

## DNS and Local Naming

There were small experiments with local naming and host file overrides to make services easier to remember. This helped during reverse proxy bring-up, but it also highlighted the limits of ad hoc local DNS when the network environment is already fragile.

The stable choices ended up being:

- Tailscale for private reachability
- Cloudflare DNS and Tunnel for selected public exposure
- Nginx Proxy Manager for service routing behind those access layers

## Why This Matters

This project demonstrates networking as an operational discipline:

- bring a host online under imperfect conditions
- choose tools that fit consumer network constraints
- debug interfaces, routes, keys, and naming step by step
- prefer maintainable access paths over brittle one-off fixes
