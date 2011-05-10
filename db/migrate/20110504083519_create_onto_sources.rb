class CreateOntoSources < ActiveRecord::Migration
  def self.up
    create_table :onto_sources do |t|
      t.text :source
      t.text :user_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :onto_sources
  end
end
