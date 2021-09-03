# typed: false
# frozen_string_literal: true

# == Schema Information
#
# Table name: annotation_types
#
#  description        :string(255)
#  name               :string(64)       not null
#  annotation_type_id :integer          not null, primary key
#
# Indexes
#
#  annotation_types_name_index   (name)
#  annotation_types_name_unique  (name) UNIQUE
#
require 'rails_helper'

RSpec.describe AnnotationType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
