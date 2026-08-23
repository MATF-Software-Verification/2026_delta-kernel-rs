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

## Author

Branko Grbic, 1015/2024