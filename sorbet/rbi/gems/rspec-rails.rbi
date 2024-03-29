# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/rspec-rails/all/rspec-rails.rbi
#
# rspec-rails-6.0.1

module RSpec
end
module RSpec::Rails
end
module RSpec::Rails::FeatureCheck
  def has_action_cable_testing?; end
  def has_action_mailbox?; end
  def has_action_mailer?; end
  def has_action_mailer_legacy_delivery_job?; end
  def has_action_mailer_parameterized?; end
  def has_action_mailer_preview?; end
  def has_action_mailer_unified_delivery?; end
  def has_active_job?; end
  def has_active_record?; end
  def has_active_record_migration?; end
  def self.has_action_cable_testing?; end
  def self.has_action_mailbox?; end
  def self.has_action_mailer?; end
  def self.has_action_mailer_legacy_delivery_job?; end
  def self.has_action_mailer_parameterized?; end
  def self.has_action_mailer_preview?; end
  def self.has_action_mailer_unified_delivery?; end
  def self.has_active_job?; end
  def self.has_active_record?; end
  def self.has_active_record_migration?; end
  def self.type_metatag(type); end
  def type_metatag(type); end
end
class RSpec::Rails::Railtie < Rails::Railtie
  def config_default_preview_path(options); end
  def config_preview_path?(options); end
  def setup_preview_path(app); end
  def supports_action_mailer_previews?(config); end
end
