# Lessons Learned

## Engineering Challenges & Lessons Learned

This repository was shaped by actual operational problems rather than a clean pre-planned deployment. The notes below refine the raw build log from the project timeline into the main challenges, what failed, and what changed afterward.

## 1. Ubuntu Server Networking on a Minimal Install

### Challenge

The server came up without a convenient Wi-Fi management path, which is a common pain point on minimal Ubuntu installations.

### What Happened

- wireless tooling was missing
- the interface was not being managed the way expected
- temporary Android USB tethering was needed just to install the right packages

### Resolution

- installed NetworkManager and related networking tools
- updated Netplan so NetworkManager became the renderer
- disabled conflicting behavior and connected through `nmcli`

### Learning

Headless Linux setup is easier when network ownership is explicit. Mixing tools without understanding which service actually controls the interface wastes time.

## 2. Headless Laptop Behavior

### Challenge

The host was a laptop, not a purpose-built server. Lid-close and display behavior became operational concerns.

### What Happened

- X11-based display commands failed because the machine was operating in a TTY environment
- lid-close suspend would have made remote recovery impossible

### Resolution

- disabled lid-triggered suspend
- used lower-level console and framebuffer-aware behavior instead of assuming a graphical session
- kept the machine running continuously for remote availability

### Learning

Consumer hardware can work well for infrastructure labs, but you inherit its desktop assumptions and need to override them deliberately.

## 3. Storage Expansion and Persistence Design

### Challenge

Available storage did not match what the host physically had, and early container persistence was too casual.

### What Happened

- LVM layout hid usable capacity until it was expanded properly
- earlier container data placement made rebuilds fragile
- deleting and recreating containers risked losing useful state

### Resolution

- expanded the storage layout properly
- migrated service config into `/opt`
- moved durable content and downloads into `/mnt`
- treated Compose YAML plus persistent directories as the rebuild blueprint

### Learning

Persistence is architecture, not cleanup work. Containers are replaceable only when the storage layout is intentional.

## 4. Media Automation Integration

### Challenge

The difficult part was not installing each service. It was making the services cooperate through storage, APIs, and routing.

### What Happened

- some containers were installed but not running
- restart behavior was incomplete after reboot
- imports and service-to-service communication broke across inconsistent paths

### Resolution

- standardized volumes and internal paths
- added restart policies
- validated the request flow one hop at a time

### Learning

System reliability comes from the interfaces between components, not from the number of components running.

## 5. Reverse Proxy Configuration

### Challenge

Friendly hostnames and routed access looked simple at first but required alignment across DNS, service URLs, and proxy behavior.

### What Happened

- internal hostnames worked inconsistently during early setup
- some services behaved differently once placed behind a proxy

### Resolution

- added Nginx Proxy Manager as the central routing layer
- tested hostnames locally before extending access further
- separated internal routing concerns from public exposure concerns

### Learning

Reverse proxies reduce clutter only when naming, upstream ports, and application assumptions all match.

## 6. WireGuard Debugging

### Challenge

WireGuard looked correct on paper but still failed to produce a usable tunnel.

### What Happened

- configuration state kept changing unexpectedly
- peer visibility did not immediately mean a valid handshake
- copied key material created silent failure

### Resolution

- removed `SaveConfig=true` when it interfered with intended config state
- reset the interface runtime state
- regenerated the tunnel and keys cleanly

### Learning

Sometimes rebuilding cleanly is faster than debugging a cursed state. That is not laziness; it is good operational judgment when the system is no longer trustworthy.

## 7. CGNAT and Public Exposure

### Challenge

The network environment did not allow easy inbound access.

### What Happened

- public IPv4 assumptions broke under ISP-level NAT
- direct exposure strategies stopped being worth the effort

### Resolution

- accepted CGNAT as a real design constraint
- used Cloudflare Tunnel for public service exposure
- kept Tailscale for private administration

### Learning

Good infrastructure work includes changing approach when the environment imposes hard limits.

## 8. Monitoring and Alerts

### Challenge

Once services were online, silent failures became the next problem.

### What Happened

- containers or routes could fail after apparently successful changes
- old hardware made thermal visibility important during experiments

### Resolution

- added Homepage, Uptime Kuma, and Glances
- wired lightweight Telegram notifications for faster feedback

### Learning

Monitoring is what turns self-hosting from setup work into operations.
