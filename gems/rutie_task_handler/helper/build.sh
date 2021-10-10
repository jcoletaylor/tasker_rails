#!/bin/bash

# these are just reminders, don't really run this script, your paths aren't likely to be mine
docker build -t rutie-linux-builder .
docker run -t -i -v ~/projects/tasker/tasker_rails/gems/rutie_task_handler:/source rutie-linux-builder /bin/bash

# reminder: then run this
cargo build --release --target x86_64-unknown-linux-gnu
cp target/x86_64-unknown-linux-gnu/release/librutie_task_handler.so /source/lib/rutie_task_handler/