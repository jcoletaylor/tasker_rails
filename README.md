[![CI](https://github.com/jcoletaylor/tasker_rails/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/jcoletaylor/tasker_rails/actions/workflows/main.yml)

# Tasker: Queable Multi-Step Tasks Made Easy-ish

## *Designed to make developing queuable multi-step tasks easier to reason about*

![Flowchart](flowchart.png "Tasker")

## Why build this?

That's a good question - Tasker is a pretty specialized kind of abstraction that many organizations may never really need. But as event-driven architectures become the norm, and as even smaller organizations find themselves interacting with a significant number of microservices, SaaS platforms, data stores, event queues, and the like, managing this complexity becomes a problem at scale.

## Doesn't Sidekiq already exist? (or insert your favorite queuing broker)

It does! I love [Sidekiq](https://sidekiq.org/) and Tasker is built on top of it. But this solves a little bit of a different problem.

In event-driven architectures, it is not uncommon for the successful completion of any single "task" to actually be dependent on a significant number of "steps" - and these steps often rely on interacting with a number of different external and internal systems, whether an external API, a local datastore, or an in-house microservice. The success of a given task is therefore dependent on the successful completion of each step, and steps can likewise be dependent on other steps.

The task itself may be enqueued for processing more than once, while steps are in a backoff or retry state. There are situations where a task and all of it steps may be able to be processed sequentially and successfully completed. In this case, the first time a task is enqueued, it is processed to completion, and will not be enqueued again. However, there are situations where a step's status is still in a valid state, but not complete, waiting on other steps, waiting on remote backoff requests, waiting on retrying from a remote failure, etc. When working with integrated services, APIs, etc that may fail, having retryability and resiliency around *each step* is crucial. If a step fails, it can be retried up to its retry limit, before we consider it in a final-error state. It is only a task which has one or more steps in a final-error (no retries left) that would mark a task as itself in error and no longer re-enquable. Any task that has still-viable steps that cannot be processed immediately, will simply be re-enqueued. The task and its steps retain the state of inputs, outputs, successes, and failures, so that implementing logic for different workflows do not have to repeat this logic over and over.

## Consider an Example

Consider a common scenario of receiving an e-commerce order in a multi-channel sales scenario, where fulfillment is managed on-site by an organization. Fulfillment systems have different data stores than the e-commerce solution, of course, but changes to an "order" in the abstract may have mutual effects on both the e-commerce representation of an order and the fulfillment order. When a change should be made to one, very frequently that change should, in some manner, propagate to both. Or, similarly, when an order is shipped, perhaps final taxes need to be calculated and reported to a tax SaaS platform, have the response data stored, and finally in total synced to a data warehouse for financial consistency. The purpose of Tasker is to make it more straightforward to enable event-driven architectures to handle multi-step tasks in a consistent and predictable way, with exposure to visibility in terms of results, status of steps, retryability, timeouts and backoffs, etc.

## Technology Choices

I used Ruby on Rails for this project, because it makes creating these kind of systems relatively straightforward. Because the handler processes happen as Sidekiq workers, and the API exposed is not especially expensive from a computational perspective, ease of developing Task Handler logic and integrations was the priority, rather than building a blisteringly fast API layer.

However, because performance of the workers matters, especially as frontends or clients poll for results (ActionCable could let us push but this implementation has not gone in that direction yet), I felt it would be a good opportunity to build a demonstration of using Rust and [Ruby-FFI](https://github.com/ffi/ffi) as a worker process.

I'll be honest that I *love* [Rust](https://www.rust-lang.org/) 🦀 - I have built a number of microservices in it over the last few years. I did not feel for this project that the ergonomics of the language would be the most straightforward for building handler logic if it were the primary source system, though I do really, really like [Tide](https://github.com/http-rs/tide) and [SQLx](https://github.com/launchbadge/sqlx), and have started an early prototype of this same system at [tasker-rust](https://github.com/jcoletaylor/tasker).

So, when it came to working on this project, I wanted to find a way to at least make it possible to use Rust for building worker logic, but expose it to the Rails' Task Handler that interacts with Sidekiq. I had originally wanted to [Use Helix](https://usehelix.com/) but sadly the project has been deprecated. So, having some familiarity with Ruby-FFI from other work, I decided I would make my own local gem and wrap up the Rust library. [This post](https://dev.to/kojix2/making-rubygem-with-rust-2ji6) is actually one of the best and most straightforward examples of how to do this, so I won't duplicate the information here.

*UPDATE* I also took the opportunity to try out [Rutie](https://github.com/danielpclark/rutie) and [Rutie Serde](https://github.com/deliveroo/rutie-serde), and this has proven to be a fairly exciting - it is possible to build Rust structs that conform to the attributes of Ruby objects, which makes the ergonomics of using Rust methods in a Ruby application really beautiful. Take a look below for the differences in approach.

## How to use Tasker

It would probably be good at some point for me to just turn Tasker into a gem itself and let it be included in other Rails apps. But, for now, for anyone who wants to make use of the project, it is easy enough to just clone and start with it as a template.

Building a TaskHandler looks something like this:

```ruby
# loaded only in test, our very cool Rust library made available via Ruby FFI
require 'dummy_rust_task_handler'

# loaded only in test, our very cool Rust library made available via Rutie and Rutie Serde
require 'rutie_task_handler'

class DummyTask
  # including this is the most important piece
  include TaskHandlers::HandlerCommon
  
  # these are just for ease of use, they could just be strings below
  DUMMY_SYSTEM = 'dummy-system'
  STEP_ONE = 'step-one'
  STEP_TWO = 'step-two'
  STEP_THREE = 'step-three'
  STEP_FOUR = 'step-four'
  ANNOTATION_TYPE = 'dummy-annotation'
  TASK_REGISTRY_NAME = 'dummy_task'

  # regular ruby handler class, could be any class that implements
  # a `handle` function with the method signature as below
  class Handler
    def handle(_task, _sequence, step)
      step.results = { dummy: true }
    end
  end

  # a class to abstract handling inputs to a dylib/so library built in rust
  # inputs can come from the step or the task - any structure
  # that is serializable to JSON
  class RustyHandler
    def handle(_task, _sequence, step)
      rusty_results = DummyRustTaskHandler::Handler.handle(step.inputs)
      step.results = rusty_results
    end
  end

  # a class to abstract handling inputs to a dylib/so library built in rust / rutie
  # the handle input is the WorkflowStep, and an output is a ruby hash with the same structure
  # as the attributes of a WorkflowStep
  class RutieHandler
    def handle(_task, _sequence, step)
      rutie_step = DummyRutieTaskHandler.handle(step)
      step.results = rutie_step[:results].symbolize_keys
    end
  end

  def schema
    @schema ||= { type: :object, required: [:dummy], properties: { dummy: { type: 'boolean' } } }
  end

  def update_annotations(task, _sequence, steps)
    annotatable_steps = steps.filter { |step| step.status == Constants::WorkflowStepStatuses::COMPLETE }
    annotation_type = AnnotationType.find_or_create_by!(name: ANNOTATION_TYPE)
    annotatable_steps.each do |step|
      TaskAnnotation.create(
        task: task,
        task_id: task.task_id,
        annotation_type_id: annotation_type.annotation_type_id,
        annotation_type: annotation_type,
        annotation: {
          dummy_annotation: 'something that might be important',
          step_name: step.name
        }
      )
    end
  end

  # note below how different steps can have a depends_on_step
  def register_step_templates
    self.step_templates = [
      StepTemplate.new(
        dependent_system: DUMMY_SYSTEM,
        name: STEP_ONE,
        description: 'Independent Step One',
        default_retryable: true,
        default_retry_limit: 3,
        skippable: false,
        handler_class: DummyTask::Handler
      ),
      StepTemplate.new(
        dependent_system: DUMMY_SYSTEM,
        name: STEP_TWO,
        description: 'Independent Step Two',
        default_retryable: true,
        default_retry_limit: 3,
        skippable: false,
        handler_class: DummyTask::Handler
      ),
      StepTemplate.new(
        dependent_system: DUMMY_SYSTEM,
        name: STEP_THREE,
        depends_on_step: STEP_TWO,
        description: 'Step Three Dependent on Step Two using a Gem wrapping a Rutie handler',
        default_retryable: true,
        default_retry_limit: 3,
        skippable: false,
        handler_class: DummyTask::RutieHandler
      ),
      StepTemplate.new(
        dependent_system: DUMMY_SYSTEM,
        name: STEP_FOUR,
        depends_on_step: STEP_THREE,
        description: 'Step Four Dependent on Step Three using a Gem wrapping a Rust FFI',
        default_retryable: true,
        default_retry_limit: 3,
        skippable: false,
        handler_class: DummyTask::RustyHandler
      )
    ]
  end
end

TaskHandlers::HandlerFactory.instance.register(DummyTask::TASK_REGISTRY_NAME, DummyTask)

```

How to build out an FFI-wrapped task handler passing JSON back and forth

```ruby
require 'ffi'
require 'json'

# Our very cool Rust library made available via Ruby FFI
module DummyRustTaskHandler
  module Wrapped
    extend FFI::Library
    lib_name = "dummy_rust_task_handler/libdummy_rust_task_handler.#{::FFI::Platform::LIBSUFFIX}"
    ffi_lib File.expand_path(lib_name, __dir__)
    attach_function :handle, [:string], :string
  end

  class Handler
    def self.handle(inputs)
      input_string = JSON.generate(inputs).force_encoding('ISO-8859-1').encode('UTF-8')
      results_string = Wrapped.handle(input_string)
      JSON.parse(results_string) if results_string&.length&.positive?
    end
  end
end
```

The Rust implementation has to expose an `extern "C"` function publicly. It is a little uncomfortable for me to have an `unsafe` piece of Rust code here, but when building dynamic libraries to be shared across a `C` style boundary, that is the only way. One "gotcha" that took me a little time to figure out was the final piece of the CString needing to be called with `into_raw()` instead of `as_ptr()` - both are technically correct, but `as_ptr()` puts the memory in the scope of the function and based on Rust's ownership model, it gets reclaimed when the function exits, which makes the FFI-boundary on the Ruby side call a segment of memory that is no longer allocated to the process, leading to garbage. The `into_raw()` call leaves that memory available to the calling side and assumes it will be deallocated by the calling process (in Ruby's case, it will be garbage collected).

```rust
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
```

The code for Rutie is similar, but is worth seeing as an example of how much simpler it is to read and use.

```ruby
require 'rutie'

module RutieTaskHandler
  class Error < StandardError; end

  Rutie.new(:rutie_task_handler, { lib_path: File.join(__dir__, '../lib/rutie_task_handler') }).init 'Init_rutie_task_handler', __dir__
end
```

You can see how many fewer lines this is, and how much boilerplate is removed. Now for the Rust code:

```rust
#[macro_use]
extern crate rutie;

use rutie::{Class, Object};
use rutie_serde::{rutie_serde_methods, ruby_class};
use serde_json::{json};
use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use serde_json::Value as JsonValue;


#[derive(Clone, Serialize, Deserialize, Debug)]
pub struct WorkflowStep {
    pub workflow_step_id: i64,
    pub task_id: i64,
    pub named_step_id: i32,
    pub depends_on_step_id: Option<i64>,
    pub status: String,
    pub retryable: bool,
    pub retry_limit: Option<i32>,
    pub in_process: bool,
    pub processed: bool,
    pub processed_at: Option<DateTime<Utc>>,
    pub attempts: Option<i32>,
    pub last_attempted_at: Option<DateTime<Utc>>,
    pub backoff_request_seconds: Option<i32>,
    pub inputs: Option<JsonValue>,
    pub results: Option<JsonValue>,
}

class!(DummyRutieTaskHandler);

rutie_serde_methods!(
    DummyRutieTaskHandler,
    _rtself,
    ruby_class!(Exception),

    fn pub_handle(step: WorkflowStep) -> WorkflowStep {
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
```

We are able to receive and return Rust Structs (Ruby gets the response Struct back as a Hash). So long as the Ruby side sends an object that conforms to the shape of the Rust Struct, we can pass objects back and forth and it looks native. The magic here of course is the combination of `rutie` and `rutie_serde`, where `rutie_serde` removes a lot of boilerplate for us in terms of creating the correct objects to and from Rust by relying on `rutie_serde` to serialize and deserialize these objects. While passing JSON as we did in the Ruby-FFI example is in some ways very similar, the ergonomics of using the Rutie / Rutie Serde version in the Ruby calling code are superior and feels far more intuitive.

## Dependencies

* Ruby version - 2.7

* System dependencies - Postgres, Redis, and Sidekiq

* Database - `bundle exec rake db:schema:load`

* How to run the test suite - `bundle exec rspec spec`

* Lint: `bundle exec rake lint`

* Typecheck with Sorbet: `bundle exec srb tc`

## Rust and Ruby-FFI

A sample TaskHandler for a WorkflowStep has been implemented in Rust using Ruby-FFI.

Check out the [gem](./gems/dummy_rust_task_handler). To rebuild the gem for test on your own system, do this:

`cd gems/dummy_rust_task_handler; rake clean && rake build`

Of course this assumes you have [Rust installed](https://www.rust-lang.org/tools/install).

To target a linux `.so` file from Mac OS if you are planning to just store the `.so` or `.dylib` without a rebuild, you can use the work by [SergioBenitez](https://github.com/SergioBenitez/homebrew-osxct). For Ruby-FFI there was no difficulty in just doing the following:

```bash
brew tap SergioBenitez/osxct
brew install x86_64-unknown-linux-gnu
cargo build --release --target x86_64-unknown-linux-gnu
```

## Rust and Rutie

A sample TaskHandler for a WorkflowStep has *also* been implemented in Rust using Rutie and Rutie Serde.

Check out the [gem](./gems/rutie_task_handler). To rebuild the gem for test on your own system, do this:

`cd gems/rutie_task_handler; rake clean && rake build`

Again this assumes you have [Rust installed](https://www.rust-lang.org/tools/install).

A note with Rutie - for Ruby-FFI above just targeting the `x86_64-unknown-linux-gnu` toolchain worked fine. With Rutie that did not work for me, because the linker could not find the ruby2.7 libraries in the `x86_64-unknown-linux-gnu` space. This problem is addressed [in Rutie's README](https://github.com/danielpclark/rutie#dynamic-vs-static-builds) but even following the documentation I couldn't get it to work.

Rather than fighting with it too much, I just built a [Dockerfile](./gems/rutie_task_handler/helper/Dockerfile) that has Ruby, Rust, and the necessary build tools and libraries already present. Then it's just a matter of running the container interactively with the Rust source tree mapped to a volume mount path in the running container, and then running, as previously, `cargo build --release --target x86_64-unknown-linux-gnu`. See the [build.sh](./gems/rutie_task_handler/helper/build.sh) helper, though it's not really meant to be run direclty, just a set of reminders. You can then just copy the output `.so` file from the release target into the gem's [load path](./gems/rutie_task_handler/lib/rutie_task_handler).

## Gratitude

Flowchart PNG by [xnimrodx](https://www.flaticon.com/authors/xnimrodx) from [Flaticon](https://www.flaticon.com/) 
