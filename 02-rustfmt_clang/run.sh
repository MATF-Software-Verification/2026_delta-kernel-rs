#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DELTA_KERNEL_RS_DIR="$SCRIPT_DIR/../delta-kernel-rs"
RESULTS_DIR="$SCRIPT_DIR/results"

mkdir -p "$RESULTS_DIR"
cd "$DELTA_KERNEL_RS_DIR"

echo "Running rustfmt check..."
{
  cargo fmt --version
  cargo fmt --all -- --check
} &> "$RESULTS_DIR/rustfmt.log"

# Apply rustfmt, save the diff, and discard the changes in the submodule
echo "Applying rustfmt..."
cargo fmt --all
git diff --binary > "$RESULTS_DIR/rustfmt.patch"
git restore .

echo "Running clang-format check..."
{
  xcrun clang-format --version
  xcrun clang-format --dry-run --Werror ffi/examples/read-table/*.c
} &> "$RESULTS_DIR/clang_format.log"

# Apply clang-format, save the diff, and discard the changes in the submodule
echo "Applying clang-format..."
xcrun clang-format -i ffi/examples/read-table/*.c
git diff --binary > "$RESULTS_DIR/clang_format.patch"
git restore .
