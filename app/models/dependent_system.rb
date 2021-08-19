# frozen_string_literal: true

# == Schema Information
#
# Table name: dependent_systems
#
#  description         :string(255)
#  name                :string(64)       not null
#  dependent_system_id :integer          not null, primary key
#
# Indexes
#
#  dependent_systems_name_index   (name)
#  dependent_systems_name_unique  (name) UNIQUE
#
class DependentSystem < ApplicationRecord
  set_primary_key :dependent_system_id
  validates :name, presence: true, uniqueness: true
end
