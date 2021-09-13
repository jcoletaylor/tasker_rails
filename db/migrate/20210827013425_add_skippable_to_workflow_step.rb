# typed: false
# frozen_string_literal: true

class AddSkippableToWorkflowStep < ActiveRecord::Migration[6.1]
  def change
    change_table :workflow_steps do |t|
      t.boolean :skippable, default: false, null: false
    end
  end
end
