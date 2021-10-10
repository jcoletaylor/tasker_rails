# frozen_string_literal: true

require 'ffi'
require 'rutie_task_handler/version'
require 'rutie'

module RutieTaskHandler
  class Error < StandardError; end

  Rutie.new(:rutie_task_handler).init 'Init_rutie_task_handler', __dir__
end
