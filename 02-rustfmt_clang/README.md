# rustfmt and clang-format

`rustfmt` and `clang-format` check whether Rust and C source code follows the project's formatting rules.

## Run

From this directory:

```
./run.sh
```

## What we ran

`./run.sh` performs:

1. **Rust** - `cargo fmt --all -- --check`. Log: `results/rustfmt.log`.
2. **C** - `clang-format --dry-run --Werror ffi/examples/read-table/*.c`. Log: `results/clang_format.log`.
3. Apply both formatters, save `results/rustfmt.patch` and `results/clang_format.patch`, then restore the submodule so the tree stays clean.

## Conclusion

- `rustfmt` passes with the default Rust 1.90.0 toolchain.
- `clang-format` reports differences with Apple clang-format 21.0.0. The proposed changes are saved in `results/clang_format.patch`.

Note: Since clang-format can take a lot of time, I focused on one specific directory to speed-up time.
