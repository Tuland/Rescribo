class RenameOntoUploadedToUploadedOnto < ActiveRecord::Migration
  def self.up
    rename_table :onto_uploadeds, :uploaded_ontos
  end

  def self.down
    rename_table :uploaded_ontos, :onto_uploadeds
  end
end
