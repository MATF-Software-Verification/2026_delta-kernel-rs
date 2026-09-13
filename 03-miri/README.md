# Miri

Miri interprets Rust code and detects undefined behavior such as invalid memory access, use-after-free, and alignment violations on executed paths.

## Run

Install Miri once:

```
rustup toolchain install nightly -c miri
cargo +nightly miri setup
```

Then, from this directory:

```
./run.sh
```

## What we ran

`./run.sh` runs a small external test harness against Delta Kernel's FFI-owned `KernelBoolSlice`.

## Conclusion

The test converts a `Vec<bool>` into a raw-pointer-backed slice, reads it and frees it. This directly checks the unsafe ownership round trip used at the C/Rust boundary. Log: `results/miri.log`.

Miri reported no undefined behavior.
