# Clippy Pedantic AI Triage

> Analysis performed with GPT-5.6 Sol Extra High.

Scope: semantic warnings only. Documentation, naming, and formatting warnings were excluded.

Deduplication: repeated lint + file + line findings across targets were counted once. The lib-test run reported 1,134 warnings, including 784 duplicates. The basic run passed.

## 1. `cast_possible_truncation` — Correctness

**Location:** `kernel/src/actions/deletion_vector.rs:426`

A `u64` bitmap index is cast to `usize` and then incremented. It can truncate on 32-bit targets or overflow at `usize::MAX`.

**Action:** Fix with checked conversion and checked addition.

```text
warning: casting `u64` to `usize` may truncate the value on targets with 32-bit wide pointers
   --> kernel/src/actions/deletion_vector.rs:426:45
    |
426 |             let mut result = vec![!set_bit; max as usize + 1];
    |                                             ^^^^^^^^^^^^
```

## 2. `cast_possible_truncation` — False positive

**Location:** `kernel/src/actions/deletion_vector_writer.rs:299`

`dv_size` is cast from `usize` to `u32`, but line 286 already limits it to `i32::MAX`, which always fits in `u32`.

**Action:** Keep the code; optionally add a narrow allow with this explanation.

```text
warning: casting `usize` to `u32` may truncate the value on targets with 64-bit wide pointers
   --> kernel/src/actions/deletion_vector_writer.rs:299:26
    |
299 |         let size_bytes = (dv_size as u32).to_be_bytes();
    |                          ^^^^^^^^^^^^^^^^
```

## 3. `cast_possible_wrap` — Correctness

**Location:** `kernel/src/actions/deletion_vector_writer.rs:334`

Cardinality is cast from `u64` to `i64`. Values above `i64::MAX` become negative.

**Action:** Use a checked conversion and return an error when it does not fit.

```text
warning: casting `u64` to `i64` may wrap around the value
   --> kernel/src/actions/deletion_vector_writer.rs:334:26
    |
334 |             cardinality: cardinality as i64,
    |                          ^^^^^^^^^^^^^^^^^^
```

## 4. `maybe_infinite_iter` — False positive

**Location:** `kernel/src/scan/state_info.rs:140`

Clippy cannot prove that the generated column-name search terminates. The schema is finite, so an unused generated name must eventually exist.

**Action:** Keep the code and add a narrow allow explaining the invariant.

```text
warning: possible infinite iteration detected
   --> kernel/src/scan/state_info.rs:140:57
    |
140 |   ...                   let index_column_name = (0..)
    |  _______________________________________________^
141 | | ...                       .map(|i| format!("row_indexes_for_row_id_{}", i))
142 | | ...                       .find(|name| logical_schema.field(name).is_none())
    | |____________________________________________________________________________^
```

## 5. `return_self_not_must_use` — Maintainability

**Location:** `kernel/src/scan/mod.rs:109`

Ignoring the returned `ScanBuilder` silently discards the configured predicate.

**Action:** Add `#[must_use]` to the builder type or method.

```text
warning: missing `#[must_use]` attribute on a method returning `Self`
   --> kernel/src/scan/mod.rs:109:5
    |
109 | /     pub fn with_predicate(mut self, predicate: impl Into<Option<PredicateRef>>) -> Self {
110 | |         self.predicate = predicate.into();
111 | |         self
112 | |     }
    | |_____^
```

## 6. `implicit_hasher` — Maintainability

**Location:** `kernel/src/schema/derive_macro_utils.rs:56`

The schema conversion supports only `HashSet<T>`'s default hasher even though the hasher does not affect the resulting schema.

**Action:** Consider supporting `HashSet<T, S>` where `S` implements `BuildHasher`.

```text
warning: impl for `HashSet` should be generalized over different hashers
  --> kernel/src/schema/derive_macro_utils.rs:56:36
   |
56 | impl<T: ToDataType> ToDataType for HashSet<T> {
   |                                    ^^^^^^^^^^
```

## 7. `format_push_string` — Performance

**Location:** `kernel/src/schema/mod.rs:523`

`format!` creates a temporary `String` for every metadata item before appending.

**Action:** Write directly into `metadata_str` with `write!`.

```text
warning: `format!(..)` appended to existing `String`
   --> kernel/src/schema/mod.rs:523:13
    |
523 |             metadata_str.push_str(&format!("{}: {:?}", k, v));
    |             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

## 8. `cast_possible_truncation` — Correctness

**Location:** `kernel/src/engine/parquet_row_group_skipping.rs:120`

An `i32` Parquet minimum is narrowed to `i16`. Invalid or unexpected statistics could wrap and cause incorrect row-group skipping.

**Action:** Use `i16::try_from(...).ok()?` and do the same for the maximum value.

```text
warning: casting `i32` to `i16` may truncate the value
   --> kernel/src/engine/parquet_row_group_skipping.rs:120:46
    |
120 |             (Short, Statistics::Int32(s)) => (*s.min_opt()? as i16).into(),
    |                                              ^^^^^^^^^^^^^^^^^^^^^^
```

## 9. `cast_possible_wrap` — Intentional

**Location:** `kernel/src/engine/parquet_row_group_skipping.rs:231`

The `u64` null count is cast to `i64`. The nearby invariant says null count cannot exceed row count, which Parquet already represents as `i64`.

**Action:** Keep the cast and add a narrow allow referencing this invariant.

```text
warning: casting `u64` to `i64` may wrap around the value
   --> kernel/src/engine/parquet_row_group_skipping.rs:231:14
    |
231 |         Some(nullcount? as i64)
    |              ^^^^^^^^^^^^^^^^^
```

## 10. `cast_possible_wrap` — Correctness

**Location:** `kernel/src/engine/default/parquet.rs:106`

`num_records` is cast from `usize` to `i64` and could become negative when too large. The adjacent file-size conversion is already checked.

**Action:** Use `try_into()` and propagate a conversion error.

```text
warning: casting `usize` to `i64` may wrap around the value on targets with 64-bit wide pointers
   --> kernel/src/engine/default/parquet.rs:106:49
    |
106 |             vec![Arc::new(Int64Array::from(vec![*num_records as i64]))],
    |                                                 ^^^^^^^^^^^^^^^^^^^
```
