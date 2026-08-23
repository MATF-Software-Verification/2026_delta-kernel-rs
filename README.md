# delta-kernel-rs software verification analysis

This repository contains a software verification analysis of the [delta-kernel-rs](https://github.com/delta-io/delta-kernel-rs) open-source project for the Software Verification course at the Faculty of Mathematics, University of Belgrade.

## Installation

```
rustup toolchain install 1.90.0 --component clippy --component rustfmt
```

## About Delta Kernel

[Delta Lake](https://delta.io/) is a table format on top of Parquet: a `_delta_log` of JSON/Parquet “actions” records every add, remove, and schema change.

**Delta Kernel** ([delta-kernel-rs](https://github.com/delta-io/delta-kernel-rs)) is a library that implements that protocol so engines (Spark, Flink, a custom Rust app, …) do not each reimplement log replay, snapshots, schema, and scans. The kernel decides *what* to read; it does not talk to disks or the network itself.
Current version is **v0.18.2**, pinned at commit `f105333a003232d7284f1a8f06cca3b6d6b232a9` (`release 0.18.2`). The source code lives in the `delta-kernel-rs/` submodule and is unmodified.

## Tools

| # | Tool or technique | Purpose | Directory |
|---|-------------------|---------|-----------|
| 1 | Clippy | Static analysis of Rust code | [01-clippy/](01-clippy/) |
| 2 | rustfmt and clang-format | Rust and C formatting checks | [02-rustfmt_clang/](02-rustfmt_clang/) |
| 3 | Valgrind Memcheck | Dynamic memory analysis of the FFI example | 03-valgrind/ |
| 4 | Unit testing | Testing individual functions and edge cases | 04-unit-tests/ |
| 5 | Integration and black-box testing | Testing public APIs and component interaction | 05-integration-tests/ |
| 6 | cargo-fuzz and libFuzzer | Generating inputs for parsing functions | 06-fuzzing/ |
| 7 | Kani | Bounded model checking of selected properties | 07-kani/ |
| 8 | cargo-mutants | Evaluating the effectiveness of tests | 08-mutation-testing/ |

## Author

Branko Grbic, 1015/2024