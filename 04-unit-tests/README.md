# Unit testing

This test reproduces the deeply nested schema problem from [issue #1896](https://github.com/delta-io/delta-kernel-rs/issues/1896), which motivated [PR #2940](https://github.com/delta-io/delta-kernel-rs/pull/2940).

## Run

Install the coverage tool once:

```
rustup component add llvm-tools-preview
cargo install cargo-llvm-cov
```

Then, from this directory:

```
./run.sh
```

## What we ran

`./run.sh` performs:

1. Measure baseline coverage for `delta_kernel` with `default-engine-rustls`.
2. Apply `unit_tests.patch` to `kernel/src/actions/mod.rs`.
3. Run the focused schema-nesting and metadata-column tests.
4. Run `cargo test -p delta_kernel --features default-engine-rustls`.
5. Measure coverage again and restore the submodule.

## Results

The test confirms that a schema nested 41 levels parses successfully, while 42 levels fails because it exceeds `serde_json`'s recursion limit. On v0.18.2 this appears as `Error::MalformedJson`.

A second test covers the previously untested branch where `Metadata::try_new` rejects metadata columns and verifies the exact `Error::Schema` message.

Both focused tests passed. The full test run passed 907 tests, with 26 ignored and no failures.

Total coverage changed as follows:

- Regions: 91.82% to 91.84%.
- Functions: 90.18% to 90.24%.
- Lines: 93.04% to 93.06%.

In `actions/mod.rs`, line coverage increased from 97.00% to 97.22%.
