class AddAnonToStories < ActiveRecord::Migration
  def change
    add_column :stories, :anon, :boolean, :default => false
    add_index :stories, [ :anon ]
  end
end
