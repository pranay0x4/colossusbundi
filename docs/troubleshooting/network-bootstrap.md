# Ubuntu Server Network Bootstrap

## Problem

The machine started as a minimal Ubuntu Server install, but the Wi-Fi setup was incomplete enough that normal remote-first administration was not possible on day one.

## What Was Missing

- Wi-Fi tooling was not available in a usable form
- the interface was not managed in the intended way
- the host was not yet easy to operate remotely

## Recovery Path

- used Android USB tethering for temporary internet access
- installed `NetworkManager` and related utilities
- changed the Netplan renderer
- disabled `systemd-networkd`
- fixed the unmanaged `wlp2s0` state
- connected with `nmcli`

## Why This Write-Up Exists

This was one of the highest-leverage fixes in the entire build. Nothing else in the project matters if the host itself is painful to reach or recover.

It also captures an important lesson for portfolio readers: even simple homelab projects often begin with low-level host friction, not with containers.
