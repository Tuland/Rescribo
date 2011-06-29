class CreateInstances < ActiveRecord::Migration
  def self.up
    create_table :instances do |t|
      t.string :uri, :null => false
      t.string :concept
      t.integer :pattern
      t.integer :level
      t.integer :user_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :instances
  end
end
