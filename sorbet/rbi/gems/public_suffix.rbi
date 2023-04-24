# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: true
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/public_suffix/all/public_suffix.rbi
#
# public_suffix-5.0.1

module PublicSuffix
  def self.decompose(name, rule); end
  def self.domain(name, **options); end
  def self.normalize(name); end
  def self.parse(name, list: nil, default_rule: nil, ignore_private: nil); end
  def self.valid?(name, list: nil, default_rule: nil, ignore_private: nil); end
end
class PublicSuffix::Domain
  def domain; end
  def domain?; end
  def initialize(*args); end
  def name; end
  def self.name_to_labels(name); end
  def sld; end
  def subdomain; end
  def subdomain?; end
  def tld; end
  def to_a; end
  def to_s; end
  def trd; end
end
class PublicSuffix::Error < StandardError
end
class PublicSuffix::DomainInvalid < PublicSuffix::Error
end
class PublicSuffix::DomainNotAllowed < PublicSuffix::DomainInvalid
end
module PublicSuffix::Rule
  def self.default; end
  def self.factory(content, private: nil); end
end
class PublicSuffix::Rule::Entry < Struct
  def length; end
  def length=(_); end
  def private; end
  def private=(_); end
  def self.[](*arg0); end
  def self.inspect; end
  def self.members; end
  def self.new(*arg0); end
  def type; end
  def type=(_); end
end
class PublicSuffix::Rule::Base
  def ==(other); end
  def decompose(*arg0); end
  def eql?(other); end
  def initialize(value:, length: nil, private: nil); end
  def length; end
  def match?(name); end
  def parts; end
  def private; end
  def self.build(content, private: nil); end
  def value; end
end
class PublicSuffix::Rule::Normal < PublicSuffix::Rule::Base
  def decompose(domain); end
  def parts; end
  def rule; end
end
class PublicSuffix::Rule::Wildcard < PublicSuffix::Rule::Base
  def decompose(domain); end
  def initialize(value:, length: nil, private: nil); end
  def parts; end
  def rule; end
  def self.build(content, private: nil); end
end
class PublicSuffix::Rule::Exception < PublicSuffix::Rule::Base
  def decompose(domain); end
  def parts; end
  def rule; end
  def self.build(content, private: nil); end
end
class PublicSuffix::List
  def <<(rule); end
  def ==(other); end
  def add(rule); end
  def clear; end
  def default_rule; end
  def each(&block); end
  def empty?; end
  def entry_to_rule(entry, value); end
  def eql?(other); end
  def find(name, default: nil, **options); end
  def initialize; end
  def rule_to_entry(rule); end
  def rules; end
  def select(name, ignore_private: nil); end
  def self.default(**options); end
  def self.default=(value); end
  def self.parse(input, private_domains: nil); end
  def size; end
end
