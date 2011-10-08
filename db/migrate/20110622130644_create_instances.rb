class CreateInstances < ActiveRecord::Migration
  def self.up
    create_table :instances, :force => true do |t|
      t.string :uri, :null => false
      t.integer :pattern
      t.integer :level
      t.integer :user_id, :null => false
      t.integer :parent_id
      t.integer :property_id
      t.timestamps
    end
  end

  def self.down
    drop_table :instances
  end
end
