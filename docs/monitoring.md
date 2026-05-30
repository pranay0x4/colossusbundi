# Monitoring

## Monitoring Goals

The goal was not full observability tooling with metrics pipelines and long retention. The goal was to answer three practical questions quickly:

- Is the host alive?
- Are the important services reachable?
- Will I notice failures when I am away from the machine?

## Components

### Homepage

Homepage acts as the operator dashboard. It provides one page for links, service entrypoints, and basic status visibility. Its value is operational convenience: fewer tabs, faster context switching, and a simpler daily control surface.

### Glances

Glances provides host-level visibility:

- CPU usage
- memory pressure
- process activity
- load averages
- thermal behavior

This became especially useful during local inference experiments with Ollama and Gemma 2B, where temperature spikes made it obvious that experimental workloads needed tighter operational boundaries than the core services.

### Uptime Kuma

Uptime Kuma handles active checks for internal and public endpoints. It helped catch:

- services that failed after reboot
- proxy misroutes
- tunnel or DNS regressions
- containers that were technically running but not serving correctly

### Telegram Alerting

Telegram was used as a lightweight alert destination. It is simple enough to keep and fast enough to matter. A small shell script posts failures or status events to a bot endpoint, avoiding the need for a heavier paging system.

## Failure Modes Observed

The monitored failures were mostly operational:

- containers stopping after reboot because restart behavior was incomplete
- application URLs changing after proxy or DNS edits
- storage refactors breaking expected mount points
- tunnel routing errors returning the wrong response or no response

Monitoring mattered because these problems were often discovered after a change that looked successful at first.

## Operational Lessons

- a dashboard is useful, but checks and alerts are what close the loop
- host metrics are essential when experimenting on old hardware
- restart policies are part of operations, not just convenience
- small systems still need visibility because manual checking does not scale well over time

## Next Improvements

- add disk usage and filesystem saturation alerts
- check media-library update freshness, not only HTTP availability
- separate experimental workloads from always-on services more clearly
