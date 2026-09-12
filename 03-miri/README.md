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

The test converts a `Vec<bool>` into a raw-pointer-backed slice, reads it through `slice::from_raw_parts`, and frees it through the exported `free_bool_slice` function, which reconstructs the allocation with `Vec::from_raw_parts`. This directly checks the unsafe ownership round trip used at the C/Rust boundary. Log: `results/miri.log`.

## Conclusion

Miri reported no undefined behavior.