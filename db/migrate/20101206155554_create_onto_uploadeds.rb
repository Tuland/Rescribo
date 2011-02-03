class CreateOntoUploadeds < ActiveRecord::Migration
  def self.up
    create_table :onto_uploadeds do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :onto_uploadeds
  end
end
