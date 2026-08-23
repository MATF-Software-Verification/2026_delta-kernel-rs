
## Goal 

Software verification analysis of the [delta-kernel-rs](https://github.com/delta-io/delta-kernel-rs) open-source project for the Software Verification course at the Faculty of Mathematics, University of Belgrade.

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
