#[cfg(test)]
mod tests {
    use delta_kernel_ffi::{free_bool_slice, KernelBoolSlice};

    #[test]
    fn bool_slice_round_trip_and_free() {
        let slice = KernelBoolSlice::from(vec![true, false, true]);

        unsafe {
            assert_eq!(slice.as_ref(), &[true, false, true]);
            free_bool_slice(slice);
        }
    }
}
