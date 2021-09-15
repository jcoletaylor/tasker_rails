# typed: true
# frozen_string_literal: true

class AddUniqueConstraintToTaskIdentityHash < ActiveRecord::Migration[6.1]
  def change
    add_index :tasks, :identity_hash, unique: true
  end
end
