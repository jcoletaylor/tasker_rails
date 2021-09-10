extern crate libc;

use libc::c_char;
use std::ffi::{CStr, CString};
use serde_json::{json, Value as JsonValue, error::Error as JsonError};

fn get_inputs(inputs: *const c_char) -> Result<JsonValue, JsonError> {
    let c_str = unsafe {
        assert!(!inputs.is_null());

        CStr::from_ptr(inputs)
    };

    let r_str = std::str::from_utf8(c_str.to_bytes()).unwrap();
    serde_json::from_str(r_str)
}

#[no_mangle]
pub extern "C" fn handle(inputs: *const c_char) -> *const c_char {
    let _inputs = get_inputs(inputs);
    let results = json!({ "dummy": true });
    let c_results = CString::new(results.to_string().as_str()).unwrap();
    let c_ptr: *const c_char = c_results.into_raw();
    c_ptr
}
