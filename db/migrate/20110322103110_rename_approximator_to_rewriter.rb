class RenameApproximatorToRewriter < ActiveRecord::Migration
  def self.up
    rename_table :approximators, :rewriters
  end

  def self.down
    rename_table :rewriters, :approximators
  end
end
