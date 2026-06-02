# Monitoring

## Why Monitor?

I didn't want to build a complex monitoring stack with massive databases and long-term charts. I just wanted to answer three simple questions:
1. Is my server actually turned on?
2. Are my apps running and reachable?
3. Will I get notified if something breaks while I'm away?

---

## What I'm Using

### Homepage (My Dashboard)
This is a simple start page that displays links to all my apps in one place. It also connects to their APIs to show basic status information. It prevents me from having to open a dozen browser tabs just to check if things are okay.

### Glances (Hardware Stats)
Glances runs on the host and monitors CPU, RAM, disk read/write, and temperature. Since my server is just an old laptop, keeping an eye on temperatures is crucial. This was really useful when I was testing Ollama with Gemma 2B—the laptop got super hot, which showed me that I need to be careful with heavy AI tasks on this hardware.

### Uptime Kuma (Uptime Checker)
Uptime Kuma continually pings my services to make sure they are responding. It helped me catch:
- Apps that didn't start up automatically after the server rebooted.
- DNS or reverse proxy config issues.
- Containers that were technically "running" according to Docker, but actually locked up and returning error codes.

### Telegram Alerts
I set up a Telegram bot that pings my phone whenever Uptime Kuma detects a service is down. It's simple, free, and I don't have to check a dashboard manually to know if something is broken.

---

## Common Failures I've Seen

- **Reboot issues:** Containers not starting because I forgot to set a restart policy.
- **Reverse proxy breaks:** Messing up an Nginx config or dynamic DNS update, causing my URLs to point to the wrong port.
- **Storage hiccups:** Changing a path on the host and breaking the mounts inside the containers.

Usually, when I update the server, things look like they are working at first. Uptime Kuma and Telegram alerts are how I find out that something actually broke ten minutes later.

---

## What I Learned
- Having a nice dashboard is cool, but real alerts that ping your phone are what save you.
- When hosting on consumer hardware (especially an old laptop), you *must* monitor temperatures.
- Simple, manual checks don't scale. Setting up automated monitoring early makes self-hosting way less stressful.

---

## Future Ideas
- Set up automated alerts for low disk space.
- Write a script to alert me if my media folders stop updating.
- Keep resource-heavy AI experiments isolated so they don't crash my media server.
