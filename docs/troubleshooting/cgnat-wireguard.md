# CGNAT And WireGuard Notes

This incident write-up combines two related realities from the build:

- WireGuard configuration mistakes on the host
- upstream connectivity limits caused by ISP-side CGNAT

## Problem

The goal was to stand up self-managed VPN access in addition to Tailscale. The initial WireGuard setup looked close to correct, but the tunnel would not establish a handshake.

At the same time, there was growing evidence that even a correct VPN setup would still run into ISP-level inbound networking limits.

## What Was Observed

- config edits were made on Ubuntu and a peer was created on macOS
- peers appeared inconsistently
- there was no handshake
- restarting the interface did not behave as expected
- later investigation suggested the server was behind CGNAT, meaning inbound IPv4 exposure was not under full local control

## Root Causes

### 1. `SaveConfig=True` was overwriting intended changes

One of the biggest debugging traps was that WireGuard runtime state kept getting written back to the config, which made it look like manual edits were not sticking. Removing `SaveConfig=True` stopped the file from being reset on each restart.

### 2. Runtime state and saved state had diverged

Bringing the interface down and back up forced WireGuard to load from the saved file rather than continuing with the incomplete runtime state.

### 3. At least one key/peer copy step was wrong

After repeated partial fixes, the eventual resolution was to delete the broken keys and peer setup and recreate them cleanly. That produced the handshake.

### 4. CGNAT constrained the overall remote access design

Even after fixing the local WireGuard issue, ISP-side CGNAT remained a separate constraint. That is an architecture lesson: a locally correct config does not guarantee globally reachable inbound access.

## Resolution

- removed `SaveConfig=True`
- brought the interface down and up cleanly
- recreated keys and peers from scratch
- verified handshake success
- confirmed SSH worked over the VPN address `10.10.0.1`
- accepted that Tailscale remained the lower-friction remote access path under CGNAT conditions

## Why This Matters

This was a useful engineering checkpoint because it separated two classes of problems:

- local misconfiguration
- upstream network topology constraints

Those are easy to conflate when debugging remote access, especially on consumer ISPs.

## Practical Takeaway

If a WireGuard setup becomes hard to reason about:

1. stop and check whether runtime state is overwriting saved state
2. verify keys and peers from scratch instead of trusting copy/paste history
3. validate whether the real blocker is actually upstream CGNAT rather than local config

For this project, the final judgment was clear: self-managed VPN access is educational and useful, but Tailscale is the more reliable operational default for day-to-day administration.
