class CreateOntologies < ActiveRecord::Migration
  def self.up
    create_table :ontologies do |t|
      t.text :url
      t.text :user_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :ontologies
  end
end
