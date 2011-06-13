class CreatePrefixes < ActiveRecord::Migration
  def self.up
    create_table :prefixes do |t|
      t.text :namespace
      t.text :prefix
      t.integer :user_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :prefixes
  end
end
