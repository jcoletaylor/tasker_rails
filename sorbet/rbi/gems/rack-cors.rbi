# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/rack-cors/all/rack-cors.rbi
#
# rack-cors-2.0.1

module Rack
end
class Rack::Cors
  def all_resources; end
  def allow(&block); end
  def call(env); end
  def debug(env, message = nil, &block); end
  def debug?; end
  def evaluate_path(env); end
  def initialize(app, opts = nil, &block); end
  def match_resource(path, env); end
  def process_cors(env, path); end
  def process_preflight(env, path); end
  def resource_for_path(path_info); end
  def select_logger(env); end
end
class Rack::Cors::Resource
  def allow_headers?(request_headers); end
  def compile(path); end
  def credentials; end
  def credentials=(arg0); end
  def ensure_enum(var); end
  def expose; end
  def expose=(arg0); end
  def header_proc; end
  def headers; end
  def headers=(arg0); end
  def if_proc; end
  def if_proc=(arg0); end
  def initialize(public_resource, path, opts = nil); end
  def match?(path, env); end
  def matches_path?(path); end
  def max_age; end
  def max_age=(arg0); end
  def methods; end
  def methods=(arg0); end
  def origin_for_response_header(origin); end
  def path; end
  def path=(arg0); end
  def pattern; end
  def pattern=(arg0); end
  def process_preflight(env, result); end
  def public_resource?; end
  def to_headers(env); end
  def to_preflight_headers(env); end
  def vary_headers; end
  def vary_headers=(arg0); end
end
class Rack::Cors::Resource::CorsMisconfigurationError < StandardError
  def message; end
end
class Rack::Cors::Resources
  def allow_origin?(source, env = nil); end
  def initialize; end
  def match_resource(path, env); end
  def origins(*args, &blk); end
  def public_resources?; end
  def resource(path, opts = nil); end
  def resource_for_path(path); end
  def resources; end
end
class Rack::Cors::Result
  def append_header(headers); end
  def hit; end
  def hit=(arg0); end
  def hit?; end
  def miss(reason); end
  def miss_reason; end
  def miss_reason=(arg0); end
  def preflight; end
  def preflight=(arg0); end
  def preflight?; end
  def self.hit(env); end
  def self.miss(env, reason); end
  def self.preflight(env); end
end
