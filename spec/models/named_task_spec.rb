# typed: false
# frozen_string_literal: true

# == Schema Information
#
# Table name: named_tasks
#
#  description   :string(255)
#  name          :string(64)       not null
#  named_task_id :integer          not null, primary key
#
# Indexes
#
#  named_tasks_name_index   (name)
#  named_tasks_name_unique  (name) UNIQUE
#
require 'rails_helper'

RSpec.describe NamedTask, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
