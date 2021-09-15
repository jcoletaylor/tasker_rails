# typed: false
# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_210_913_132_203) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'annotation_types', primary_key: 'annotation_type_id', id: :serial, force: :cascade do |t|
    t.string 'name', limit: 64, null: false
    t.string 'description', limit: 255
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['name'], name: 'annotation_types_name_index'
    t.index ['name'], name: 'annotation_types_name_unique', unique: true
  end

  create_table 'dependent_system_object_maps', primary_key: 'dependent_system_object_map_id', force: :cascade do |t|
    t.integer 'dependent_system_one_id', null: false
    t.integer 'dependent_system_two_id', null: false
    t.string 'remote_id_one', limit: 128, null: false
    t.string 'remote_id_two', limit: 128, null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[dependent_system_one_id dependent_system_two_id remote_id_one remote_id_two], name: 'dependent_system_object_maps_dependent_system_one_id_dependent_', unique: true
    t.index ['dependent_system_one_id'], name: 'dependent_system_object_maps_dependent_system_one_id_index'
    t.index ['dependent_system_two_id'], name: 'dependent_system_object_maps_dependent_system_two_id_index'
    t.index ['remote_id_one'], name: 'dependent_system_object_maps_remote_id_one_index'
    t.index ['remote_id_two'], name: 'dependent_system_object_maps_remote_id_two_index'
  end

  create_table 'dependent_systems', primary_key: 'dependent_system_id', id: :serial, force: :cascade do |t|
    t.string 'name', limit: 64, null: false
    t.string 'description', limit: 255
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['name'], name: 'dependent_systems_name_index'
    t.index ['name'], name: 'dependent_systems_name_unique', unique: true
  end

  create_table 'named_steps', primary_key: 'named_step_id', id: :serial, force: :cascade do |t|
    t.integer 'dependent_system_id', null: false
    t.string 'name', limit: 128, null: false
    t.string 'description', limit: 255
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[dependent_system_id name], name: 'named_step_by_system_uniq', unique: true
    t.index ['dependent_system_id'], name: 'named_steps_dependent_system_id_index'
    t.index ['name'], name: 'named_steps_name_index'
  end

  create_table 'named_tasks', primary_key: 'named_task_id', id: :serial, force: :cascade do |t|
    t.string 'name', limit: 64, null: false
    t.string 'description', limit: 255
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['name'], name: 'named_tasks_name_index'
    t.index ['name'], name: 'named_tasks_name_unique', unique: true
  end

  create_table 'named_tasks_named_steps', id: :serial, force: :cascade do |t|
    t.integer 'named_task_id', null: false
    t.integer 'named_step_id', null: false
    t.boolean 'skippable', default: false, null: false
    t.boolean 'default_retryable', default: true, null: false
    t.integer 'default_retry_limit', default: 3, null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['named_step_id'], name: 'named_tasks_named_steps_named_step_id_index'
    t.index %w[named_task_id named_step_id], name: 'named_tasks_steps_ids_unique', unique: true
    t.index ['named_task_id'], name: 'named_tasks_named_steps_named_task_id_index'
  end

  create_table 'task_annotations', primary_key: 'task_annotation_id', force: :cascade do |t|
    t.bigint 'task_id', null: false
    t.integer 'annotation_type_id', null: false
    t.jsonb 'annotation'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['annotation'], name: 'task_annotations_annotation_idx', using: :gin
    t.index ['annotation'], name: 'task_annotations_annotation_idx1', opclass: :jsonb_path_ops, using: :gin
    t.index ['annotation_type_id'], name: 'task_annotations_annotation_type_id_index'
    t.index ['task_id'], name: 'task_annotations_task_id_index'
  end

  create_table 'tasks', primary_key: 'task_id', force: :cascade do |t|
    t.integer 'named_task_id', null: false
    t.string 'status', limit: 64, null: false
    t.boolean 'complete', default: false, null: false
    t.datetime 'requested_at', null: false
    t.string 'initiator', limit: 128
    t.string 'source_system', limit: 128
    t.string 'reason', limit: 128
    t.json 'bypass_steps'
    t.jsonb 'tags'
    t.jsonb 'context'
    t.string 'identity_hash', limit: 128, null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['context'], name: 'tasks_context_idx', using: :gin
    t.index ['context'], name: 'tasks_context_idx1', opclass: :jsonb_path_ops, using: :gin
    t.index ['identity_hash'], name: 'index_tasks_on_identity_hash', unique: true
    t.index ['identity_hash'], name: 'tasks_identity_hash_index'
    t.index ['named_task_id'], name: 'tasks_named_task_id_index'
    t.index ['requested_at'], name: 'tasks_requested_at_index'
    t.index ['source_system'], name: 'tasks_source_system_index'
    t.index ['status'], name: 'tasks_status_index'
    t.index ['tags'], name: 'tasks_tags_idx', using: :gin
    t.index ['tags'], name: 'tasks_tags_idx1', opclass: :jsonb_path_ops, using: :gin
  end

  create_table 'workflow_steps', primary_key: 'workflow_step_id', force: :cascade do |t|
    t.bigint 'task_id', null: false
    t.integer 'named_step_id', null: false
    t.bigint 'depends_on_step_id'
    t.string 'status', limit: 64, null: false
    t.boolean 'retryable', default: true, null: false
    t.integer 'retry_limit', default: 3
    t.boolean 'in_process', default: false, null: false
    t.boolean 'processed', default: false, null: false
    t.datetime 'processed_at'
    t.integer 'attempts'
    t.datetime 'last_attempted_at'
    t.integer 'backoff_request_seconds'
    t.jsonb 'inputs'
    t.jsonb 'results'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.boolean 'skippable', default: false, null: false
    t.index ['depends_on_step_id'], name: 'workflow_steps_depends_on_step_id_index'
    t.index ['last_attempted_at'], name: 'workflow_steps_last_attempted_at_index'
    t.index ['named_step_id'], name: 'workflow_steps_named_step_id_index'
    t.index ['processed_at'], name: 'workflow_steps_processed_at_index'
    t.index ['status'], name: 'workflow_steps_status_index'
    t.index ['task_id'], name: 'workflow_steps_task_id_index'
  end

  add_foreign_key 'dependent_system_object_maps', 'dependent_systems', column: 'dependent_system_one_id', primary_key: 'dependent_system_id', name: 'dependent_system_object_maps_dependent_system_one_id_foreign'
  add_foreign_key 'dependent_system_object_maps', 'dependent_systems', column: 'dependent_system_two_id', primary_key: 'dependent_system_id', name: 'dependent_system_object_maps_dependent_system_two_id_foreign'
  add_foreign_key 'named_steps', 'dependent_systems', primary_key: 'dependent_system_id', name: 'named_steps_dependent_system_id_foreign'
  add_foreign_key 'named_tasks_named_steps', 'named_steps', primary_key: 'named_step_id', name: 'named_tasks_named_steps_named_step_id_foreign'
  add_foreign_key 'named_tasks_named_steps', 'named_tasks', primary_key: 'named_task_id', name: 'named_tasks_named_steps_named_task_id_foreign'
  add_foreign_key 'task_annotations', 'annotation_types', primary_key: 'annotation_type_id', name: 'task_annotations_annotation_type_id_foreign'
  add_foreign_key 'task_annotations', 'tasks', primary_key: 'task_id', name: 'task_annotations_task_id_foreign'
  add_foreign_key 'tasks', 'named_tasks', primary_key: 'named_task_id', name: 'tasks_named_task_id_foreign'
  add_foreign_key 'workflow_steps', 'named_steps', primary_key: 'named_step_id', name: 'workflow_steps_named_step_id_foreign'
  add_foreign_key 'workflow_steps', 'tasks', primary_key: 'task_id', name: 'workflow_steps_task_id_foreign'
  add_foreign_key 'workflow_steps', 'workflow_steps', column: 'depends_on_step_id', primary_key: 'workflow_step_id', name: 'workflow_steps_depends_on_step_id_foreign'
end
