$LOAD_PATH << '.' unless $LOAD_PATH.include?('.')
$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require 'active_record'
require 'database_cleaner'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

require File.expand_path('../../lib/change_tracker', __FILE__)

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.define(:version => 1) do
  create_table :changes do |t|
    t.string   :record_model
    t.integer  :record_id
    t.integer  :change_type
    t.text     :changed_data
    t.timestamps
  end

  create_table :pickled_radishes do |t|
    t.string :pickler
    t.datetime :manufacturing_date
  end
end

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
