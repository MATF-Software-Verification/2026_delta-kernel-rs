# Clippy

Clippy is Rust’s official linter. It flags common mistakes, performance issues, and non-idiomatic code.

## Run

From this directory:

```
./run.sh
```

## What we ran

`./run.sh` analyzes `delta_kernel` package (`--all-targets`, `default-engine-rustls`) with the following steps:

1. **Basic** (`-D warnings`) - same bar as typical CI. Log: `results/clippy_basic.log`.
2. **Pedantic** (`-W clippy::pedantic`) - extra lints. Log: `results/clippy_pedantic.log`.
3. `--fix` - apply auto-fixes, save `results/clippy_fixes.patch`, then restore the submodule so the tree stays clean.

## AI Triage

Since pedantic lints can be noisy, AI could be a great additional tool to triage and filter out important pedantic lints. Example of the triage is saved at `results/pedantic_ai_triage.md`.
