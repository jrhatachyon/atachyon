class AddAnonToComments < ActiveRecord::Migration
  def change
    add_column :comments, :anon, :boolean, :default => false
    add_index :comments, [ :anon ]
  end
end
