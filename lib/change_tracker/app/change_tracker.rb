module ChangeTracker
  extend ActiveSupport::Concern

  included do
    before_save :find_changes
    after_save :save_changes
    before_destroy :save_destroyed_record
  end

  # before_save
  def find_changes
    tracked_object = self
    change_type = tracked_object.new_record? ? :added_record : :changed_record
    @changes = Change.new(change_type: change_type, record_model: tracked_object.class.name)
    @changes.changed_data = tracked_object.changes if @changes.change_type == 'changed_record'
  end

  # after_save
  def save_changes
    tracked_object = self
    @changes.record_id = tracked_object.id
    @changes.changed_data = tracked_object.attributes if @changes.change_type == 'added_record'
    @changes.save!
  end

  # before_destroy
  def save_destroyed_record
    tracked_object = self
    @changes = Change.create!(change_type: :deleted_record,
                              record_model: tracked_object.class.name,
                              changed_data: tracked_object.attributes,
                              record_id: tracked_object.id)
  end
end
