class ChangeTrackerMigration < ActiveRecord::Migration
  def self.up
    create_table :changes do |t|
      t.string :record_model
      t.integer :record_id
      t.integer :change_type, default: nil
      t.text :changed_data
      t.timestamps
    end
  end

  def self.down
    drop_table :changes
  end
end