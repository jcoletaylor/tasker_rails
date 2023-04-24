# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/redis-client/all/redis-client.rbi
#
# redis-client-0.14.1

class RedisClient
  def blocking_call(timeout, *command, **kwargs); end
  def blocking_call_v(timeout, command); end
  def build_transaction; end
  def call(*command, **kwargs); end
  def call_once(*command, **kwargs); end
  def call_once_v(command); end
  def call_v(command); end
  def close; end
  def connect; end
  def connected?; end
  def ensure_connected(retryable: nil); end
  def hscan(key, *args, **kwargs, &block); end
  def initialize(config, **arg1); end
  def inspect; end
  def multi(watch: nil, &block); end
  def pipelined; end
  def pubsub; end
  def raw_connection; end
  def read_timeout=(timeout); end
  def scan(*args, **kwargs, &block); end
  def scan_list(cursor_index, command, &block); end
  def scan_pairs(cursor_index, command); end
  def self.config(**kwargs); end
  def self.default_driver; end
  def self.default_driver=(name); end
  def self.driver(name); end
  def self.new(arg = nil, **kwargs); end
  def self.register(middleware); end
  def self.register_driver(name, &block); end
  def self.sentinel(**kwargs); end
  def size; end
  def sscan(key, *args, **kwargs, &block); end
  def then(_options = nil); end
  def timeout=(timeout); end
  def with(_options = nil); end
  def write_timeout=(timeout); end
  def zscan(key, *args, **kwargs, &block); end
  include RedisClient::Common
end
module RedisClient::CommandBuilder
  def generate(args, kwargs = nil); end
  extend RedisClient::CommandBuilder
end
class RedisClient::Config
  def host; end
  def initialize(url: nil, host: nil, port: nil, path: nil, **kwargs); end
  def path; end
  def port; end
  include RedisClient::Config::Common
end
module RedisClient::Config::Common
  def build_connection_prelude; end
  def circuit_breaker; end
  def command_builder; end
  def connect_timeout; end
  def connection_prelude; end
  def custom; end
  def db; end
  def driver; end
  def id; end
  def inherit_socket; end
  def initialize(username: nil, password: nil, db: nil, id: nil, timeout: nil, read_timeout: nil, write_timeout: nil, connect_timeout: nil, ssl: nil, custom: nil, ssl_params: nil, driver: nil, protocol: nil, client_implementation: nil, command_builder: nil, inherit_socket: nil, reconnect_attempts: nil, middlewares: nil, circuit_breaker: nil); end
  def middlewares_stack; end
  def new_client(**kwargs); end
  def new_pool(**kwargs); end
  def password; end
  def protocol; end
  def read_timeout; end
  def retry_connecting?(attempt, _error); end
  def sentinel?; end
  def server_url; end
  def ssl; end
  def ssl?; end
  def ssl_context; end
  def ssl_params; end
  def username; end
  def write_timeout; end
end
module RedisClient::PIDCache
  def self.pid; end
end
class RedisClient::SentinelConfig
  def check_role!(role); end
  def config; end
  def each_sentinel; end
  def host; end
  def initialize(name:, sentinels:, role: nil, **client_config); end
  def path; end
  def port; end
  def refresh_sentinels(sentinel_client); end
  def reset; end
  def resolve_master; end
  def resolve_replica; end
  def retry_connecting?(attempt, error); end
  def sentinel?; end
  def sentinel_client(sentinel_config); end
  def sentinels; end
  def sentinels_to_configs(sentinels); end
  include RedisClient::Config::Common
end
class RedisClient::BasicMiddleware
  def call(command, _config); end
  def call_pipelined(command, _config); end
  def client; end
  def connect(_config); end
  def initialize(client); end
end
class RedisClient::Middlewares < RedisClient::BasicMiddleware
end
class RedisClient::Pooled
  def blocking_call(*args, &block); end
  def blocking_call_v(*args, &block); end
  def call(*args, &block); end
  def call_once(*args, &block); end
  def call_once_v(*args, &block); end
  def call_v(*args, &block); end
  def close; end
  def hscan(*args, &block); end
  def initialize(config, id: nil, connect_timeout: nil, read_timeout: nil, write_timeout: nil, **kwargs); end
  def multi(*args, &block); end
  def new_pool; end
  def pipelined(*args, &block); end
  def pool; end
  def pubsub(*args, &block); end
  def scan(*args, &block); end
  def size; end
  def sscan(*args, &block); end
  def then(options = nil); end
  def with(options = nil); end
  def zscan(*args, &block); end
  include RedisClient::Common
end
class RedisClient::CircuitBreaker
  def error_threshold; end
  def error_threshold_timeout; end
  def error_timeout; end
  def initialize(error_threshold:, error_timeout:, error_threshold_timeout: nil, success_threshold: nil); end
  def protect; end
  def record_error; end
  def record_success; end
  def refresh_state; end
  def success_threshold; end
end
module RedisClient::CircuitBreaker::Middleware
  def call(_command, config); end
  def call_pipelined(_commands, config); end
  def connect(config); end
end
class RedisClient::CircuitBreaker::OpenCircuitError < RedisClient::CannotConnectError
end
module RedisClient::ConnectionMixin
  def call(command, timeout); end
  def call_pipelined(commands, timeouts); end
  def close; end
  def initialize; end
  def reconnect; end
  def revalidate; end
end
class RedisClient::RubyConnection
  def close; end
  def connect; end
  def connected?; end
  def enable_socket_keep_alive(socket); end
  def initialize(config, connect_timeout:, read_timeout:, write_timeout:); end
  def read(timeout = nil); end
  def read_timeout=(timeout); end
  def self.ssl_context(ssl_params); end
  def write(command); end
  def write_multi(commands); end
  def write_timeout=(timeout); end
  include RedisClient::ConnectionMixin
end
class RedisClient::RubyConnection::BufferedIO
  def close; end
  def closed?; end
  def ensure_remaining(bytes); end
  def eof?; end
  def fill_buffer(strict, size = nil); end
  def getbyte; end
  def gets_chomp; end
  def initialize(io, read_timeout:, write_timeout:, chunk_size: nil); end
  def read_chomp(bytes); end
  def read_timeout; end
  def read_timeout=(arg0); end
  def skip(offset); end
  def with_timeout(new_timeout); end
  def write(string); end
  def write_timeout; end
  def write_timeout=(arg0); end
end
module RedisClient::RESP3
  def dump(command, buffer = nil); end
  def dump_any(object, buffer); end
  def dump_array(array, buffer); end
  def dump_hash(hash, buffer); end
  def dump_numeric(numeric, buffer); end
  def dump_set(set, buffer); end
  def dump_string(string, buffer); end
  def dump_symbol(symbol, buffer); end
  def load(io); end
  def new_buffer; end
  def parse(io); end
  def parse_array(io); end
  def parse_blob(io); end
  def parse_boolean(io); end
  def parse_double(io); end
  def parse_error(io); end
  def parse_integer(io); end
  def parse_map(io); end
  def parse_null(io); end
  def parse_push(io); end
  def parse_sequence(io, size); end
  def parse_set(io); end
  def parse_string(io); end
  def parse_verbatim_string(io); end
  def self.dump(command, buffer = nil); end
  def self.dump_any(object, buffer); end
  def self.dump_array(array, buffer); end
  def self.dump_hash(hash, buffer); end
  def self.dump_numeric(numeric, buffer); end
  def self.dump_set(set, buffer); end
  def self.dump_string(string, buffer); end
  def self.dump_symbol(symbol, buffer); end
  def self.load(io); end
  def self.new_buffer; end
  def self.parse(io); end
  def self.parse_array(io); end
  def self.parse_blob(io); end
  def self.parse_boolean(io); end
  def self.parse_double(io); end
  def self.parse_error(io); end
  def self.parse_integer(io); end
  def self.parse_map(io); end
  def self.parse_null(io); end
  def self.parse_push(io); end
  def self.parse_sequence(io, size); end
  def self.parse_set(io); end
  def self.parse_string(io); end
  def self.parse_verbatim_string(io); end
end
class RedisClient::RESP3::Error < RedisClient::Error
end
class RedisClient::RESP3::UnknownType < RedisClient::RESP3::Error
end
class RedisClient::RESP3::SyntaxError < RedisClient::RESP3::Error
end
module RedisClient::Common
  def config; end
  def connect_timeout; end
  def connect_timeout=(arg0); end
  def id; end
  def initialize(config, id: nil, connect_timeout: nil, read_timeout: nil, write_timeout: nil); end
  def read_timeout; end
  def read_timeout=(arg0); end
  def timeout=(timeout); end
  def write_timeout; end
  def write_timeout=(arg0); end
end
class RedisClient::Error < StandardError
end
class RedisClient::ProtocolError < RedisClient::Error
end
class RedisClient::UnsupportedServer < RedisClient::Error
end
class RedisClient::ConnectionError < RedisClient::Error
end
class RedisClient::CannotConnectError < RedisClient::ConnectionError
end
class RedisClient::FailoverError < RedisClient::ConnectionError
end
class RedisClient::TimeoutError < RedisClient::ConnectionError
end
class RedisClient::ReadTimeoutError < RedisClient::TimeoutError
end
class RedisClient::WriteTimeoutError < RedisClient::TimeoutError
end
class RedisClient::CheckoutTimeoutError < RedisClient::TimeoutError
end
module RedisClient::HasCommand
  def _set_command(command); end
  def command; end
end
class RedisClient::CommandError < RedisClient::Error
  def self.parse(error_message); end
  include RedisClient::HasCommand
end
class RedisClient::AuthenticationError < RedisClient::CommandError
end
class RedisClient::PermissionError < RedisClient::CommandError
end
class RedisClient::WrongTypeError < RedisClient::CommandError
end
class RedisClient::OutOfMemoryError < RedisClient::CommandError
end
class RedisClient::ReadOnlyError < RedisClient::ConnectionError
  include RedisClient::HasCommand
end
class RedisClient::MasterDownError < RedisClient::ConnectionError
  include RedisClient::HasCommand
end
class RedisClient::PubSub
  def call(*command, **kwargs); end
  def call_v(command); end
  def close; end
  def initialize(raw_connection, command_builder); end
  def next_event(timeout = nil); end
  def raw_connection; end
end
class RedisClient::Multi
  def _blocks; end
  def _coerce!(results); end
  def _commands; end
  def _empty?; end
  def _retryable?; end
  def _size; end
  def _timeouts; end
  def call(*command, **kwargs, &block); end
  def call_once(*command, **kwargs, &block); end
  def call_once_v(command, &block); end
  def call_v(command, &block); end
  def initialize(command_builder); end
end
class RedisClient::Pipeline < RedisClient::Multi
  def _coerce!(results); end
  def _empty?; end
  def _timeouts; end
  def blocking_call(timeout, *command, **kwargs, &block); end
  def blocking_call_v(timeout, command, &block); end
  def initialize(_command_builder); end
end
module RedisClient::Decorator
  def self.create(commands_mixin); end
end
module RedisClient::Decorator::CommandsMixin
  def blocking_call(*args, &block); end
  def blocking_call_v(*args, &block); end
  def call(*args, &block); end
  def call_once(*args, &block); end
  def call_once_v(*args, &block); end
  def call_v(*args, &block); end
  def initialize(client); end
end
class RedisClient::Decorator::Pipeline
  include RedisClient::Decorator::CommandsMixin
end
class RedisClient::Decorator::Client
  def close(*args, &block); end
  def config; end
  def connect_timeout; end
  def connect_timeout=(value); end
  def hscan(*args, &block); end
  def id; end
  def initialize(_client); end
  def multi(**kwargs); end
  def pipelined; end
  def pubsub; end
  def read_timeout; end
  def read_timeout=(value); end
  def scan(*args, &block); end
  def size; end
  def sscan(*args, &block); end
  def timeout=(value); end
  def with(*args); end
  def write_timeout; end
  def write_timeout=(value); end
  def zscan(*args, &block); end
  include RedisClient::Decorator::CommandsMixin
end