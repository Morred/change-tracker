# encoding: utf-8 
require 'spec_helper'

class PickledRadish < ActiveRecord::Base
  validates :pickler, :manufacturing_date, presence: true
end

describe 'Change Tracker' do

  context 'for untracked models' do

    it 'does not track creating a model' do
      PickledRadish.create(pickler: "Mortimer", manufacturing_date: Date.today)
      expect(Change.all.count).to eq(0)
    end

    it 'does not track changing a model' do
      jar = PickledRadish.create(pickler: "Mortimer", manufacturing_date: Date.today)
      jar.update_attributes(pickler: "Sally")
      expect(Change.all.count).to eq(0)
    end

    it 'does not track deleting a model' do
      jar = PickledRadish.create(pickler: "Mortimer", manufacturing_date: Date.today)
      jar.destroy
      expect(Change.all.count).to eq(0)
    end

  end

  context 'for tracked models' do
    before(:each) do
      PickledRadish.send(:include, ChangeTracker)
    end

    it 'tracks creating a model' do
      jar = PickledRadish.create(pickler: "Mortimer", manufacturing_date: Date.today)
      expect(Change.all.count).to eq(1)
      change = Change.last
      expect(change.record_model).to eq("PickledRadish")
      expect(change.record_id).to eq(jar.id)
      expect(change.change_type).to eq("added_record")
      expect(change.changed_data).to include({"id"=>"#{jar.id}".to_i, "pickler"=>"Mortimer"})
    end

    it 'tracks updating a model' do
      jar = PickledRadish.create(pickler: "Mortimer", manufacturing_date: Date.today)
      jar.update(pickler: "Sally")
      expect(Change.all.count).to eq(2)
      change = Change.last
      expect(change.record_model).to eq("PickledRadish")
      expect(change.record_id).to eq(jar.id)
      expect(change.change_type).to eq("changed_record")
      expect(change.changed_data).to eq({"pickler" => ["Mortimer", "Sally"]})
    end

    it 'tracks deleting a model' do
      jar = PickledRadish.create(pickler: "Mortimer", manufacturing_date: Date.today)
      jar.destroy
      expect(Change.all.count).to eq(2)
      change = Change.last
      expect(change.record_model).to eq("PickledRadish")
      expect(change.record_id).to eq(jar.id)
      expect(change.change_type).to eq("deleted_record")
      expect(change.changed_data).to include({"id"=>"#{jar.id}".to_i, "pickler"=>"Mortimer"})
    end

  end
end
