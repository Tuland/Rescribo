class CreateAeriaUploadeds < ActiveRecord::Migration
  def self.up
    create_table :aeria_uploadeds do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :aeria_uploadeds
  end
end
