# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/dummy_rust_task_handler/all/dummy_rust_task_handler.rbi
#
# dummy_rust_task_handler-0.1.0

module DummyRustTaskHandler
end
module DummyRustTaskHandler::Wrapped
  def handle(*arg0); end
  def self.handle(*arg0); end
  extend FFI::Library
end
class DummyRustTaskHandler::Handler
  def self.handle(inputs); end
end