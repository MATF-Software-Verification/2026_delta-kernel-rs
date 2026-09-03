#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DELTA_KERNEL_RS_DIR="$SCRIPT_DIR/../delta-kernel-rs"
RESULTS_DIR="$SCRIPT_DIR/results"
TEMP_DIR="/tmp/delta-kernel-rs-kani"

mkdir -p "$RESULTS_DIR"
rm -rf "$TEMP_DIR"
cd "$DELTA_KERNEL_RS_DIR"

echo "Applying Kani proof..."
git apply "$SCRIPT_DIR/kani-proofs.patch"

echo "Verifying decimal precision..."
{
  cargo kani --version
  CARGO_TARGET_DIR="$TEMP_DIR" cargo kani -p delta_kernel \
    --harness verify_decimal_precision_range
} &> "$RESULTS_DIR/kani.log"

git restore .
rm -rf "$TEMP_DIR"
