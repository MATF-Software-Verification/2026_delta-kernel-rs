# delta-kernel-rs software verification analysis

This repository contains a software verification analysis of the [delta-kernel-rs](https://github.com/delta-io/delta-kernel-rs) open-source project for the Software Verification course at the Faculty of Mathematics, University of Belgrade.

## Installation

```
rustup toolchain install 1.90.0 -c clippy -c rustfmt -c llvm-tools-preview
rustup toolchain install nightly -c miri
cargo install cargo-llvm-cov cargo-mutants kani-verifier
cargo kani setup
cargo +nightly miri setup
```

## About Delta Kernel

[Delta Lake](https://delta.io/) is a table format on top of Parquet: a `_delta_log` of JSON/Parquet “actions” records every add, remove, and schema change.

**Delta Kernel** ([delta-kernel-rs](https://github.com/delta-io/delta-kernel-rs)) is a library that implements that protocol so engines (Spark, Flink, a custom Rust app, …) do not each reimplement log replay, snapshots, schema, and scans. The kernel decides *what* to read; it does not talk to disks or the network itself.
Current version is **v0.18.2**, pinned at commit `f105333a003232d7284f1a8f06cca3b6d6b232a9` (`release 0.18.2`). The source code lives in the `delta-kernel-rs/` submodule and is unmodified.

## Tools and reproduction

Run:
- Clippy: `./01-clippy/run.sh`
- rustfmt and clang-format: `./02-rustfmt_clang/run.sh`
- Miri: `./03-miri/run.sh`
- Unit tests and coverage: `./04-unit-tests/run.sh`
- Kani: `./05-kani/run.sh`
- cargo-mutants: `./06-cargo-mutants/run.sh`

Results are saved in each tool's `results/` directory.

## Conclusions

- Default Clippy and rustfmt checks passed; pedantic Clippy was noisy and clang-format proposed changes.
- Miri found no undefined behavior in the tested FFI ownership round trip.
- All 907 kernel tests passed; the added tests characterized schema-nesting and metadata-column errors and slightly increased coverage.
- Kani proved the selected decimal precision properties for every `i128`.
- All 10 selected interval-parser mutants were caught.

## Author

Branko Grbic, 1015/2024