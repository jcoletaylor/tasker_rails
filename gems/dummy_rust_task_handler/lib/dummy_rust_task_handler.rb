# typed: true
# frozen_string_literal: true

require 'dummy_rust_task_handler/version'
require 'ffi'
require 'json'

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
