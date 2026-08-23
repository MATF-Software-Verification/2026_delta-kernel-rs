#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DELTA_KERNEL_RS_DIR="$SCRIPT_DIR/../delta-kernel-rs"
RESULTS_DIR="$SCRIPT_DIR/results"

mkdir -p "$RESULTS_DIR"
cd "$DELTA_KERNEL_RS_DIR"

echo "Running baseline coverage..."
{
  cargo llvm-cov --version
  cargo llvm-cov clean --workspace
  cargo llvm-cov -p delta_kernel --features default-engine-rustls --summary-only
} &> "$RESULTS_DIR/coverage_baseline.log"

echo "Applying unit test..."
git apply "$SCRIPT_DIR/unit_tests.patch"

echo "Running focused unit tests..."
{
  cargo test -p delta_kernel test_parse_schema_nesting_boundary --features default-engine-rustls
  cargo test -p delta_kernel test_metadata_try_new_rejects_metadata_columns --features default-engine-rustls
} &> "$RESULTS_DIR/focused_test.log"

echo "Running all delta_kernel tests..."
cargo test -p delta_kernel --features default-engine-rustls &> "$RESULTS_DIR/all_tests.log"

echo "Running coverage with the unit test..."
{
  cargo llvm-cov --version
  cargo llvm-cov clean --workspace
  cargo llvm-cov -p delta_kernel --features default-engine-rustls --summary-only
} &> "$RESULTS_DIR/coverage_after.log"

git restore .
