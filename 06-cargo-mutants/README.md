# cargo-mutants

`cargo-mutants` makes small changes to production code and checks whether the existing tests detect them.

## Run

Install the tool once:

```
cargo install cargo-mutants
```

Then, from this directory:

```
./run.sh
```

## What we ran

`./run.sh` lists and tests only mutations of `parse_interval_impl` in `kernel/src/table_properties/deserialize.rs`.

The run uses the `default-engine-rustls` feature and filters Cargo tests to the existing `parse_interval` unit tests. Mutants run one at a time so the result is predictable and easy to reproduce.

Code pointers: [`parse_interval_impl`](../delta-kernel-rs/kernel/src/table_properties/deserialize.rs), lines 178–220.

## Results

cargo-mutants generated 10 mutants:

- Caught: 10
- Missed: 0
- Timeouts: 0
- Unviable: 0

For example, changing the initial `"interval"` check from `!=` to `==` caused both interval tests to fail, so that mutant was caught.

All selected mutants were caught, which shows that these tests are sensitive to the generated changes in this function. It does not prove that every possible defect would be detected.
