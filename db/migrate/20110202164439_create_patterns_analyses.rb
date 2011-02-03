class CreatePatternsAnalyses < ActiveRecord::Migration
  def self.up
    create_table :patterns_analyses do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :patterns_analyses
  end
end
