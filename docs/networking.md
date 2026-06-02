# Networking & Remote Access

## Fixing Wi-Fi on a Minimal Install

I installed the minimal version of Ubuntu Server on an old laptop, but it didn't come with any wireless tools. Since I didn't have an ethernet cable handy, I had to plug in my Android phone and use USB tethering to share my phone's internet with the laptop. 

Once I got online, I followed these steps to get Wi-Fi working permanently:
1. Installed `NetworkManager` and wireless utilities.
2. Edited my Netplan configuration (`/etc/netplan/`) to make NetworkManager the renderer instead of systemd-networkd.
3. Disabled the conflicting systemd-networkd services.
4. Used `nmcli` in the terminal to connect to my home Wi-Fi network.

This fixed the "unmanaged interface" error and let me place the laptop in a closet out of sight.

---

## Headless Laptop Struggles

Since this is an old laptop running as a server, it doesn't have a desktop graphical interface (GUI)—it's just a text TTY console. I ran into two big issues here:
- **Sleep on lid close:** By default, laptops go to sleep when you close them. I had to configure systemd's `logind.conf` to ignore lid-close switches, otherwise my remote connection would die as soon as I closed the laptop.
- **X11 commands failing:** I tried running some utility scripts that assumed a GUI was running (checking for things like `DISPLAY=:0`). I had to modify them to use lower-level terminal and framebuffer commands instead.

---

## My Remote Access Setup

To manage the server when I'm away from home, I set up a couple of tools:
- **SSH:** For basic terminal access.
- **Tailscale:** A zero-config VPN. It gives my server a static, private IP address that I can connect to from my phone or main laptop from anywhere, even when I'm on public Wi-Fi or cellular data. It saved me from having to configure port forwarding or dynamic DNS for admin tasks.

---

## Testing WireGuard (VPN Learning Experience)

Just to learn how VPNs work at a lower level, I set up a raw WireGuard connection manually. It was a headache to debug, but I learned a few useful patterns:
- **Interface vs. Peer state:** Just because the interface says it's "up" doesn't mean you have a handshake with your peer.
- **Watch out for `SaveConfig=true`:** This setting in WireGuard automatically overwrites your configuration file with whatever is currently in memory when the interface shuts down. If you make a manual edit to the file and restart the VPN, it gets wiped out! Removing this line made debugging much easier.
- **Key mismatches:** A tiny copy-paste error with the public or private keys will cause silent failures. Sometimes it's just faster to delete the config files and generate new keys from scratch than to squint at key strings.

---

## Dealing with Carrier-Grade NAT (CGNAT)

I wanted to host a few public web pages, but my home ISP uses CGNAT. This means my home router doesn't get a public IP address—instead, it shares a public IP with other houses. Because of this, traditional router port forwarding is completely blocked.

Rather than trying to buy a static public IP from my ISP, I bypassed it by using **Cloudflare Tunnel** for public access, and **Tailscale** for private access. Both tools work by making outbound connections from the server, which completely bypasses the CGNAT barrier.

---

## DNS & Subdomains

To make my local services easy to access, I did some experiments:
- **Nginx Proxy Manager:** Acts as my internal router. It takes incoming HTTP traffic and forwards it to the correct Docker container ports.
- **Cloudflare DNS:** Manages my domain and routes public traffic through the Cloudflare Tunnel to the proxy.
- **Tailscale MagicDNS:** Automatically resolves my server's hostname when I'm connected to the VPN.

---

## What I Learned
- Getting a server online under messy conditions (like USB tethering over a phone) is a useful skill.
- Understand the limits of your hardware and ISP before you start configuring things.
- Choose access methods that are secure and bypass network restrictions (like tunnels and overlay VPNs) rather than opening random ports on your home router.
