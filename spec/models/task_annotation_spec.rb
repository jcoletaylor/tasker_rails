# frozen_string_literal: true

# == Schema Information
#
# Table name: task_annotations
#
#  annotation         :jsonb
#  annotation_type_id :integer          not null
#  task_annotation_id :bigint           not null, primary key
#  task_id            :bigint           not null
#
# Indexes
#
#  task_annotations_annotation_idx            (annotation) USING gin
#  task_annotations_annotation_idx1           (annotation) USING gin
#  task_annotations_annotation_type_id_index  (annotation_type_id)
#  task_annotations_task_id_index             (task_id)
#
# Foreign Keys
#
#  task_annotations_annotation_type_id_foreign  (annotation_type_id => annotation_types.annotation_type_id)
#  task_annotations_task_id_foreign             (task_id => tasks.task_id)
#
require 'rails_helper'

RSpec.describe TaskAnnotation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
