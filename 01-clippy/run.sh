#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DELTA_KERNEL_RS_DIR="$SCRIPT_DIR/../delta-kernel-rs"
RESULTS_DIR="$SCRIPT_DIR/results"

mkdir -p "$RESULTS_DIR"
cd "$DELTA_KERNEL_RS_DIR"

# Run clippy on the delta_kernel crate
echo "Running basic Clippy..."
{
  cargo clippy --version
  cargo clippy -p delta_kernel --all-targets --features default-engine-rustls -- -D warnings
} &> "$RESULTS_DIR/clippy_basic.log"

# Run clippy with the pedantic level
echo "Running pedantic Clippy..."
{
  cargo clippy --version
  cargo clippy -p delta_kernel --all-targets --features default-engine-rustls -- -W clippy::pedantic
} &> "$RESULTS_DIR/clippy_pedantic.log"

# Apply pedantic clippy fixes using cargo clippy --fix into a patch file and discard the changes in the submodule
echo "Applying pedantic clippy fixes..."
cargo clippy --fix -p delta_kernel --all-targets --features default-engine-rustls -- -W clippy::pedantic &> /dev/null
git diff --binary > "$RESULTS_DIR/clippy_pedantic_fixes.patch"
git restore .
