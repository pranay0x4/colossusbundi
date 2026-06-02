# Cloudflare Tunnel

## Why I Needed It

Exposing services from a home network is always a pain. I ran into a few main issues:
- **CGNAT:** My ISP puts my home connection behind carrier-grade NAT, which means I don't get a real public IP address.
- **Port Forwarding:** Even if I could port forward on the home router, it feels sketchy security-wise and is annoying to configure.
- **Dynamic IP:** Home IPs change all the time, which means DNS records would keep breaking.

Cloudflare Tunnel solved all of this. It lets me expose specific local services to the internet over HTTPS without opening any ports on my router.

---

## How I Set It Up

Here's the process I followed to get it running:
1. **Domain Name:** Registered a domain and pointed its nameservers to Cloudflare.
2. **Installation:** Installed the `cloudflared` client on my Ubuntu laptop server.
3. **Authentication:** Logged into my Cloudflare account via the CLI to link the server.
4. **Configuration:** Created a tunnel and wrote a local configuration file to map my domain name to internal services.
5. **Systemd Service:** Enabled `cloudflared` as a system service so the tunnel starts up automatically whenever the laptop boots.

---

## Where It Fits in My Setup

The tunnel only handles public HTTPS traffic. I don't route everything through it:
- **Tailscale** is still my go-to for secure SSH and managing the server. I don't expose any admin consoles publicly.
- **Nginx Proxy Manager** handles internal routing. The tunnel forwards traffic to the proxy, which then routes it to the correct Docker container.
- **Cloudflare Tunnel** acts as a secure entry point for my public-facing services (like letting my friends request movies via Jellyseerr).

---

## Stuff That Broke / Challenges

It wasn't all smooth sailing. A few things tripped me up:
- **Setup Confusion:** Got confused between managing the tunnel configuration locally in a YAML file versus doing it through the Cloudflare Zero Trust web UI. I ended up sticking to local config files because it felt more like "real" infrastructure-as-code.
- **DNS Mapping Errors:** Messed up a few DNS records at first, which took a while to debug because of caching.
- **App-Specific Redirects:** Some services tried to redirect to `http` or custom subpaths, which threw 502/504 errors behind the tunnel until I fixed the headers in Nginx Proxy Manager.

The biggest thing I learned: **A running tunnel only means Cloudflare can talk to your server, not that your app is actually working.** I had to learn to debug the app logs and tunnel logs separately.

---

## Trade-offs

Using a tunnel is great because it makes TLS (SSL certificates) super simple and keeps my home network hidden. But the downside is that I'm fully dependent on Cloudflare. If their service goes down, or if they change their free tier, I'll have to find another solution. For a personal project, though, this trade-off is 100% worth it.
