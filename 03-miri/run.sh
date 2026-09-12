#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DELTA_KERNEL_RS_DIR="$SCRIPT_DIR/../delta-kernel-rs"
RESULTS_DIR="$SCRIPT_DIR/results"
TEMP_DIR="/tmp/delta-kernel-rs-miri"

mkdir -p "$RESULTS_DIR"
rm -rf "$TEMP_DIR"
cd "$DELTA_KERNEL_RS_DIR"

echo "Running Miri on Delta Kernel Rust code..."
{
  cargo +nightly miri --version
  CARGO_TARGET_DIR="$TEMP_DIR" cargo +nightly miri test \
    --manifest-path "$SCRIPT_DIR/miri-harness/Cargo.toml" --locked
} &> "$RESULTS_DIR/miri.log"
STATUS=$?

rm -rf "$TEMP_DIR"
exit "$STATUS"
