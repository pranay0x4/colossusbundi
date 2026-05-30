# Cloudflare Tunnel

## Why It Was Needed

Direct public access ran into the usual home-network problems:

- CGNAT prevented straightforward inbound exposure
- router-level changes alone were not enough
- manually opening ports would still have left a rough operational setup

Cloudflare Tunnel solved the practical problem: expose selected services over HTTPS without depending on public inbound reachability from the ISP.

## Deployment Flow

The working sequence was:

1. register a domain and move nameservers to Cloudflare
2. install `cloudflared` on the Ubuntu host
3. authenticate the tunnel against the Cloudflare account
4. create the tunnel and its local configuration file
5. map public hostnames to internal service destinations
6. run the tunnel as a persistent system service

This made the tunnel part of the host's startup behavior rather than a manual command.

## Role in the Architecture

Cloudflare Tunnel is only the public edge. It does not replace internal routing or private administration.

- Tailscale remains the preferred path for SSH and private maintenance
- Nginx Proxy Manager remains the service router for internal hostname-based access
- Cloudflare Tunnel provides a controlled bridge from public DNS to selected internal services

## Problems Encountered

The tunnel setup was not completely linear. Issues included:

- slow or confusing initial setup flow while switching between local and web-side authorization
- DNS routing mistakes during hostname mapping
- service-specific HTTPS or redirect behavior that did not immediately cooperate behind the tunnel

One useful lesson was to separate tunnel health from application health. A running tunnel only proves connectivity to the edge, not that the upstream service is behaving correctly.

## Security and Tradeoffs

The tunnel reduced exposure by avoiding broad inbound port forwarding, but it also introduced another dependency layer. For a personal platform, that tradeoff was reasonable:

- easier remote publishing
- simpler TLS handling
- less router dependence

The cost is added reliance on an external control plane and a need to document which services should remain private versus which may be published.

## Current Operating Model

- private access: SSH over Tailscale
- public access: Cloudflare Tunnel to selected HTTP services
- local routing: Nginx Proxy Manager

That separation of responsibilities made the overall system easier to reason about than trying to force every access pattern through one networking tool.
