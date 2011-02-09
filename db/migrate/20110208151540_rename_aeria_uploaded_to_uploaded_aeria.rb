class RenameAeriaUploadedToUploadedAeria < ActiveRecord::Migration
  def self.up
    rename_table :aeria_uploadeds, :uploaded_aerias
  end

  def self.down
    rename_table :uploaded_aerias, :aeria_uploadeds
  end
end
