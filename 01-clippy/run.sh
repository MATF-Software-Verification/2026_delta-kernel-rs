#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DELTA_KERNEL_RS_DIR="$SCRIPT_DIR/../delta-kernel-rs"
RESULTS_DIR="$SCRIPT_DIR/results"

mkdir -p "$RESULTS_DIR"
cd "$DELTA_KERNEL_RS_DIR"

# Run clippy on the delta_kernel crate
echo "Running basic Clippy..."
cargo clippy -p delta_kernel --all-targets --features default-engine-rustls -- -D warnings > "$RESULTS_DIR/clippy_basic.log" 2>&1

# Run clippy with the pedantic level
echo "Running pedantic Clippy..."
cargo clippy -p delta_kernel --all-targets --features default-engine-rustls -- -W clippy::pedantic > "$RESULTS_DIR/clippy_pedantic.log" 2>&1

# Apply fixes using cargo clippy --fix into a patch file and discard the changes in the submodule
echo "Applying fixes..."
cargo clippy --fix -p delta_kernel --all-targets --features default-engine-rustls -- -W clippy::pedantic
git diff --binary > "$RESULTS_DIR/clippy_fixes.patch"
git restore .
