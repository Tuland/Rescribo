class CreateSearchEngines < ActiveRecord::Migration
  def self.up
    create_table :search_engines do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :search_engines
  end
end
