#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DELTA_KERNEL_RS_DIR="$SCRIPT_DIR/../delta-kernel-rs"
RESULTS_DIR="$SCRIPT_DIR/results"
TEMP_LOG="/tmp/delta-kernel-mutants.log"

mkdir -p "$RESULTS_DIR"
rm -rf "$RESULTS_DIR/mutants.out"
rm -f "$TEMP_LOG"
cd "$DELTA_KERNEL_RS_DIR"

echo "Listing interval parser mutants..."
{
  cargo mutants --version
  cargo mutants -p delta_kernel --features default-engine-rustls \
    -f "kernel/src/table_properties/deserialize.rs" -F "parse_interval_impl" --list
} &> "$RESULTS_DIR/mutants_list.log"

echo "Running interval parser mutants..."
cargo mutants -p delta_kernel --features default-engine-rustls \
  -f "kernel/src/table_properties/deserialize.rs" -F "parse_interval_impl" \
  -j 1 --no-shuffle --output "$RESULTS_DIR" -- --lib parse_interval \
  &> "$TEMP_LOG"

mv "$TEMP_LOG" "$RESULTS_DIR/mutants.log"
