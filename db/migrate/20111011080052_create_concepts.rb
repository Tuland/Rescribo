class CreateConcepts < ActiveRecord::Migration
  def self.up
    create_table :concepts do |t|
      t.string :uri
      t.integer :level
      t.integer :pattern
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :concepts
  end
end
