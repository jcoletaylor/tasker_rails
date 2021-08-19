# frozen_string_literal: true

# == Schema Information
#
# Table name: named_steps
#
#  description         :string(255)
#  name                :string(128)      not null
#  dependent_system_id :integer          not null
#  named_step_id       :integer          not null, primary key
#
# Indexes
#
#  named_step_by_system_uniq              (dependent_system_id,name) UNIQUE
#  named_steps_dependent_system_id_index  (dependent_system_id)
#  named_steps_name_index                 (name)
#
# Foreign Keys
#
#  named_steps_dependent_system_id_foreign  (dependent_system_id => dependent_systems.dependent_system_id)
#
require 'rails_helper'

RSpec.describe NamedStep, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
