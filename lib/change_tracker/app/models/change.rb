class Change < ActiveRecord::Base
  enum change_type: [ :added_record, :changed_record, :deleted_record ]
  serialize :changed_data, Hash

  validates :record_model, :record_id, :change_type, :changed_data, presence: true
end
