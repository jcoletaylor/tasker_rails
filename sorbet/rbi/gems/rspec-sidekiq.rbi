# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/rspec-sidekiq/all/rspec-sidekiq.rbi
#
# rspec-sidekiq-3.1.0

module RSpec
end
module RSpec::Sidekiq
  def self.configuration; end
  def self.configure(&block); end
end
class RSpec::Sidekiq::Configuration
  def clear_all_enqueued_jobs; end
  def clear_all_enqueued_jobs=(arg0); end
  def enable_terminal_colours; end
  def enable_terminal_colours=(arg0); end
  def initialize; end
  def warn_when_jobs_not_processed_by_sidekiq; end
  def warn_when_jobs_not_processed_by_sidekiq=(arg0); end
end
module Sidekiq
end
module Sidekiq::Worker
end
module Sidekiq::Worker::ClassMethods
  def default_retries_exhausted_exception; end
  def default_retries_exhausted_message; end
  def within_sidekiq_retries_exhausted_block(user_msg = nil, exception = nil, &block); end
end
module RSpec::Sidekiq::Matchers
  def be_delayed(*expected_arguments); end
  def be_expired_in(expected_argument); end
  def be_processed_in(expected_queue); end
  def be_retryable(expected_retry); end
  def be_unique; end
  def have_enqueued_job(*expected_arguments); end
  def have_enqueued_sidekiq_job(*expected_arguments); end
  def save_backtrace(expected_backtrace = nil); end
end
class RSpec::Sidekiq::Matchers::BeDelayed
  def description; end
  def failure_message; end
  def failure_message_when_negated; end
  def find_job(method, arguments, &block); end
  def for(interval); end
  def initialize(*expected_arguments); end
  def matches?(expected_method); end
  def until(time); end
end
class RSpec::Sidekiq::Matchers::BeExpiredIn
  def description; end
  def failure_message; end
  def failure_message_when_negated; end
  def initialize(expected_argument); end
  def matches?(job); end
end
class RSpec::Sidekiq::Matchers::BeProcessedIn
  def description; end
  def failure_message; end
  def failure_message_when_negated; end
  def initialize(expected_queue); end
  def matches?(job); end
end
class RSpec::Sidekiq::Matchers::BeRetryable
  def description; end
  def failure_message; end
  def failure_message_when_negated; end
  def initialize(expected_retry); end
  def matches?(job); end
end
class RSpec::Sidekiq::Matchers::BeUnique
  def self.new; end
end
class RSpec::Sidekiq::Matchers::BeUnique::Base
  def description; end
  def failure_message; end
  def failure_message_when_negated; end
  def for(interval); end
  def interval_matches?; end
  def interval_specified?; end
  def matches?(job); end
end
class RSpec::Sidekiq::Matchers::BeUnique::SidekiqUniqueJobs < RSpec::Sidekiq::Matchers::BeUnique::Base
  def actual_interval; end
  def unique_key; end
  def value_matches?; end
end
class RSpec::Sidekiq::Matchers::BeUnique::SidekiqEnterprise < RSpec::Sidekiq::Matchers::BeUnique::Base
  def actual_interval; end
  def unique_key; end
  def value_matches?; end
end
class RSpec::Sidekiq::Matchers::JobOptionParser
  def at_evaluator(value); end
  def in_evaluator(value); end
  def initialize(job); end
  def job; end
  def matches?(option, value); end
end
class RSpec::Sidekiq::Matchers::JobMatcher
  def arguments_matches?(job, arguments); end
  def contain_exactly?(expected, got); end
  def find_job(arguments, options); end
  def initialize(klass); end
  def job_arguments(job); end
  def jobs; end
  def matches?(job, arguments, options); end
  def options_matches?(job, options); end
  def present?(arguments, options); end
  def unwrap_jobs(jobs); end
end
class RSpec::Sidekiq::Matchers::HaveEnqueuedJob
  def actual_arguments; end
  def actual_options; end
  def at(timestamp); end
  def description; end
  def expected_arguments; end
  def expected_options; end
  def failure_message; end
  def failure_message_when_negated; end
  def in(interval); end
  def initialize(expected_arguments); end
  def job_arguments(hash); end
  def klass; end
  def map_arguments(job); end
  def matches?(klass); end
  def normalize_arguments(args); end
  def unwrapped_job_arguments(jobs); end
  def unwrapped_job_options(jobs); end
end
class RSpec::Sidekiq::Matchers::SaveBacktrace
  def description; end
  def failure_message; end
  def failure_message_when_negated; end
  def initialize(expected_backtrace = nil); end
  def matches?(job); end
end