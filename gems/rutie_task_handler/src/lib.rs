#[macro_use]
extern crate rutie;

mod models;

use rutie::{Class, Object};
use rutie_serde::{rutie_serde_methods, ruby_class};
use serde_json::{json};


class!(DummyRutieTaskHandler);

rutie_serde_methods!(
    DummyRutieTaskHandler,
    _rtself,
    ruby_class!(Exception),

    fn pub_handle(step: models::WorkflowStep) -> models::WorkflowStep {
        let mut new_step = step.clone();
        new_step.results = Some(json!({ "dummy": true }));
        new_step
    }
);

#[allow(non_snake_case)]
#[no_mangle]
pub extern "C" fn Init_rutie_task_handler() {
    Class::new("DummyRutieTaskHandler", None).define(|klass| {
        klass.def_self("handle", pub_handle);
    });
}