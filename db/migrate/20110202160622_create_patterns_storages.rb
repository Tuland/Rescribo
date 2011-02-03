class CreatePatternsStorages < ActiveRecord::Migration
  def self.up
    create_table :patterns_storages do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :patterns_storages
  end
end
