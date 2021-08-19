# frozen_string_literal: true

# == Schema Information
#
# Table name: dependent_system_object_maps
#
#  remote_id_one                  :string(128)      not null
#  remote_id_two                  :string(128)      not null
#  dependent_system_object_map_id :bigint           not null, primary key
#  dependent_system_one_id        :integer          not null
#  dependent_system_two_id        :integer          not null
#
# Indexes
#
#  dependent_system_object_maps_dependent_system_one_id_dependent_  (dependent_system_one_id,dependent_system_two_id,remote_id_one,remote_id_two) UNIQUE
#  dependent_system_object_maps_dependent_system_one_id_index       (dependent_system_one_id)
#  dependent_system_object_maps_dependent_system_two_id_index       (dependent_system_two_id)
#  dependent_system_object_maps_remote_id_one_index                 (remote_id_one)
#  dependent_system_object_maps_remote_id_two_index                 (remote_id_two)
#
# Foreign Keys
#
#  dependent_system_object_maps_dependent_system_one_id_foreign  (dependent_system_one_id => dependent_systems.dependent_system_id)
#  dependent_system_object_maps_dependent_system_two_id_foreign  (dependent_system_two_id => dependent_systems.dependent_system_id)
#
class DependentSystemObjectMap < ApplicationRecord
  belongs_to :dependent_system_one
  belongs_to :dependent_system_two
end
