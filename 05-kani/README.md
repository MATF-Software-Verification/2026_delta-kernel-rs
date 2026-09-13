# Kani

Kani is a bounded model checker for Rust. It checks assertions for every value represented by symbolic inputs, rather than running a finite list of examples.

## Run

Install Kani once:

```
cargo install kani-verifier
cargo kani setup
```

Then, from this directory:

```
./run.sh
```

## What we proved

`./run.sh` applies `kani-proofs.patch` and runs `verify_decimal_precision_range` beside `get_decimal_precision`.

Code pointers: [`get_decimal_precision`](../delta-kernel-rs/kernel/src/expressions/scalars.rs), lines 50–55.

The proof uses an arbitrary symbolic `i128` and checks:

1. Decimal precision is never greater than 39 digits.
2. Precision is zero exactly when the input value is zero.

No assumptions are used. The patch is removed after verification so the submodule stays clean.

## Results

All checks succeeded. This proves these two properties for every `i128` value under Kani's model. It does not prove unrelated decimal behavior.
