
## Goal 

Software verification analysis of the [delta-kernel-rs](https://github.com/delta-io/delta-kernel-rs) open-source project for the Software Verification course at the Faculty of Mathematics, University of Belgrade.

## Tools

| # | Tool or technique | Purpose | Directory |
|---|-------------------|---------|-----------|
| 1 | Clippy | Static analysis of Rust code | [01-clippy/](01-clippy/) |
| 2 | rustfmt and clang-format | Rust and C formatting checks | [02-rustfmt_clang/](02-rustfmt_clang/) |
| 3 | Valgrind Memcheck | Dynamic memory analysis of the FFI example | 03-valgrind/ |
| 4 | Unit testing | Testing individual functions and edge cases | [04-unit-tests/](04-unit-tests/) |
| 5 | Kani | Bounded model checking of selected properties | [05-kani/](05-kani/) |
| 6 | cargo-mutants | Evaluating the effectiveness of tests | [06-cargo-mutants/](06-cargo-mutants/) |

## 1. Clippy

### What we ran

`./run.sh` analyzes `delta_kernel` package (`--all-targets`, `default-engine-rustls`) with the following steps:

1. **Basic** (`-D warnings`) - same bar as typical CI. Log: `results/clippy_basic.log`.
2. **Pedantic** (`-W clippy::pedantic`) - extra lints. Log: `results/clippy_pedantic.log`.
3. `--fix` - apply auto-fixes, save `results/clippy_fixes.patch`, then restore the submodule so the tree stays clean.

### Conclusion

The default Clippy analysis of the `delta_kernel` package completed successfully. It reported 0 warnings with warnings treated as errors. 
The additional pedantic analysis contained 1,321 items, but Cargo explicitly reported 784 duplicate warnings. The important distinction is that `clippy::pedantic` is intentionally strict, disabled by default, and can produce occasional false positives. Therefore, pedantic warnings should not be treated as a failed score.

### AI Triage

Since pedantic lints can be noisy, AI could be a great additional tool to triage and filter out important pedantic lints. Example of the triage is saved at `results/pedantic_ai_triage.md`.

## 02. Rustftmt & clang-format

### What we ran

`./run.sh` performs:

1. **Rust** - `cargo fmt --all -- --check`. Log: `results/rustfmt.log`.
2. **C** - `clang-format --dry-run --Werror ffi/examples/read-table/*.c`. Log: `results/clang_format.log`.
3. Apply both formatters, save `results/rustfmt.patch` and `results/clang_format.patch`, then restore the submodule so the tree stays clean.

### Conclusion

- `rustfmt` passes with the default Rust 1.90.0 toolchain.
- `clang-format` reports differences with Apple clang-format 21.0.0. The proposed changes are saved in `results/clang_format.patch`.

Note: Since clang-format can take a lot of time, I focused on one specific directory to speed-up time.

## 04. Unit testing

### What we ran

The added unit test reproduces the deeply nested schema problem from [issue #1896](https://github.com/delta-io/delta-kernel-rs/issues/1896), which motivated [PR #2940](https://github.com/delta-io/delta-kernel-rs/pull/2940).

1. Measured baseline coverage for `delta_kernel` with `default-engine-rustls`.
2. Applied `unit_tests.patch` to `kernel/src/actions/mod.rs`.
3. Ran the focused schema-nesting and metadata-column tests.
4. Ran `cargo test -p delta_kernel --features default-engine-rustls`.
5. Measured coverage again and restored the submodule.

### Conclusion

The test confirms that a schema nested 41 levels parses successfully, while 42 levels fails because it exceeds `serde_json`'s recursion limit. On v0.18.2 this appears as `Error::MalformedJson`.

A second test covers the previously untested branch where `Metadata::try_new` rejects metadata columns and verifies the exact `Error::Schema` message.

Both focused tests passed. The full test run passed 907 tests, with 26 ignored and no failures.

Total coverage changed from 91.82% to 91.84% for regions, 90.18% to 90.24% for functions, and 93.04% to 93.06% for lines. Line coverage in `actions/mod.rs` increased from 97.00% to 97.22%.

## 05. Kani

### What we proved

The `verify_decimal_precision_range` harness uses an arbitrary symbolic `i128` and verifies that `get_decimal_precision` never returns more than 39 and returns zero exactly when the input is zero.

The proof has no assumptions. Kani therefore considers every `i128` value under its model, including `i128::MIN`, zero, and `i128::MAX`.

### Conclusion

All 30 checks succeeded. The model-checking phase completed in approximately 1 second. Note: This proves the selected precision properties, not all behavior of decimal parsing or construction.

## 06. cargo-mutants

### What we ran

`cargo-mutants` generated mutations only for `parse_interval_impl` in `kernel/src/table_properties/deserialize.rs`. It ran the existing `parse_interval` unit tests with the `default-engine-rustls` feature.

The unmodified baseline took 25 seconds to build and 2 seconds to test. cargo-mutants automatically selected a 20-second timeout.

### Conclusion

All 10 generated mutants were caught. There were no missed, timed-out, or unviable mutants.

For example, changing the initial `"interval"` comparison from `!=` to `==` made both selected interval tests fail. This confirms that the tests distinguish the original behavior from that mutation.

The result demonstrates sensitivity to these 10 generated changes in one focused function. It does not prove that the tests detect every possible defect.

