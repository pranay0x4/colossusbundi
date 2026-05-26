# Ollama CPU Overload

## Problem

Ollama was installed in Docker and a lightweight model, `gemma2:2b`, was started on the laptop-based server. The workload ran, but thermals rose sharply.

## What Was Observed

- inference worked
- temperature jumped from roughly the high-50s Celsius to around 100 C during the test
- the workload had to be stopped to avoid abusing the machine

## Interpretation

This was not a functional failure. It was a capacity and thermal-limit failure on consumer hardware being used as a multipurpose server.

That distinction matters:

- the software stack worked
- the hardware budget for sustained inference was the real bottleneck

## Resolution

- stopped the workload
- treated local inference as an experiment rather than an always-on service

## Takeaway

Running local models on repurposed hardware is feasible, but it needs thermal awareness and workload discipline. On this host, lightweight experiments are realistic; unattended sustained inference is probably not.
