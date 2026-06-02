# Lessons Learned / Things I Figured Out

Building this server was definitely not a smooth, perfect setup where everything worked the first time. I broke things, ran into unexpected bugs, and had to search through a ton of old forums to get things working. 

Here are the main challenges I faced, how I solved them, and what I learned.

---

## 1. Getting Wi-Fi to work on Ubuntu Server
- **What broke:** I installed the minimal Ubuntu Server version on the laptop. Since it's meant for server hardware, it didn't come with any wireless tools pre-installed. I couldn't connect to the internet to download the packages I needed to connect to the internet!
- **How I fixed it:** I tethered my Android phone to the laptop via USB, which gave it a temporary wired internet connection. Then I installed `NetworkManager` and wireless packages, configured Netplan to let NetworkManager control the Wi-Fi card, and used `nmcli` to connect to my home network.
- **What I learned:** If you're setting up a headless server over Wi-Fi, make sure you have a backup plan (like phone tethering or an ethernet cable) to get through the initial install.

---

## 2. Dealing with Laptop Sleep Behavior (Headless Setup)
- **What broke:** The server is an old laptop. By default, Ubuntu Server suspends (goes to sleep) when the lid is closed. If it goes to sleep, my remote connection drops and I can't wake it up. Also, I tried to run some display-related scripts but they failed because there was no X11/graphical interface running (just a text TTY console).
- **How I fixed it:** I edited `/etc/systemd/logind.conf` to ignore the lid switch (setting `HandleLidSwitch=ignore`) and restarted the logind service. For any terminal display issues, I switched to using the lower-level framebuffer tools rather than assuming a GUI was running.
- **What I learned:** Using a laptop as a server is cheap and convenient (and acts as a built-in UPS battery backup!), but you have to fight its default "sleep when closed" desktop behaviors first.

---

## 3. Storage Mess & Docker Persistence
- **What broke:** Initially, I didn't realize how my drive partition was structured. I was running out of space quickly, only to find out that the LVM volume group hadn't been expanded to use the whole SSD. On top of that, I was setting up Docker containers without thinking about where they saved their configuration. If I recreated a container, all its setup was wiped out.
- **How I fixed it:** I used `lvextend` and `resize2fs` to expand the logical volume to fill the entire physical disk. Then, I organized my storage properly: all configuration files live under `/opt/services/<app-name>` and actual downloads/media live under `/mnt`.
- **What I learned:** Docker containers are designed to be temporary and easily replaceable, but *only* if you map their config files to persistent directories on the host disk first.

---

## 4. Getting the Media Stack to Talk to Each Other
- **What broke:** I spun up Sonarr, Radarr, and qBittorrent, but they couldn't coordinate. Sonarr would tell qBittorrent to download a file, but when it finished, Sonarr couldn't import it because they were looking at different folder paths inside their respective containers.
- **How I fixed it:** I redesigned the docker-compose setup to use uniform paths. Now, every container maps `/mnt/media` and `/mnt/downloads` exactly the same way. I also set up a shared Docker network so the containers can resolve each other by name (e.g. `http://qbittorrent:8080`) instead of hardcoding IP addresses.
- **What I learned:** Building a pipeline of multiple tools is less about installing them and more about getting their storage paths and API integrations to match up perfectly.

---

## 5. Reverse Proxy Confusions
- **What broke:** I wanted to type `jellyfin.local` instead of remembering `192.168.1.50:8096`. But some services had weird redirect issues or wouldn't load behind a reverse proxy because of header mismatches.
- **How I fixed it:** I installed Nginx Proxy Manager as a web dashboard to manage routing. I set up local DNS overrides and mapped subdomains. I had to learn how websockets work because some services (like Jellyfin's video player) would freeze or fail to load without websocket support enabled in the proxy config.
- **What I learned:** Reverse proxies make URLs look clean, but you have to understand how headers, ports, and protocols match up underneath.

---

## 6. WireGuard Headaches
- **What broke:** I tried to set up a bare WireGuard VPN connection to remote into my server. I kept editing the configuration file, but every time I restarted the interface, my changes got wiped out. The connection would start, but no packets would route.
- **How I fixed it:** It turned out `SaveConfig=true` was enabled in my WireGuard config, which automatically overwrites the configuration file with the active memory state when the interface goes down—wiping my manual edits. I disabled that, regenerated my keys cleanly, and set up the routes again.
- **What I learned:** If a config file keeps changing by itself, check if the service is auto-saving. Sometimes, starting fresh with a clean config file is much faster than trying to debug a broken configuration state.

---

## 7. Bypassing Carrier-Grade NAT (CGNAT)
- **What broke:** I wanted to access my services when I was away from my home network, but my ISP uses CGNAT. This means my home router doesn't get a public IPv4 address, making standard port forwarding completely useless.
- **How I fixed it:** I stopped trying to make port forwarding work and set up a Cloudflare Tunnel instead. The tunnel runs a small client daemon on my server that creates an outbound connection to Cloudflare, letting external traffic reach my web services securely. For full CLI access, I set up Tailscale.
- **What I learned:** You can't control how your ISP routes traffic, but overlay networks (like Tailscale) and tunnels (like Cloudflare) make it easy to bypass those restrictions.

---

## 8. Setting Up Alerts
- **What broke:** In the beginning, if a container crashed or the laptop got too hot, I wouldn't know until I tried to use a service and noticed it was broken.
- **How I fixed it:** Set up Uptime Kuma to ping my services and wired it to a Telegram bot. Now, if a container stops responding, the bot pings my phone. I also wrote a small bash script that checks the laptop's thermal sensors and alerts me if the CPU temperature spikes.
- **What I learned:** If you don't monitor your server, you're just waiting for something to fail silently. Getting a simple alert on your phone makes running a home server feel much more robust.
