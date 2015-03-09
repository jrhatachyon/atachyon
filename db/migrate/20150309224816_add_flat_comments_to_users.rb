class AddFlatCommentsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :flat_comments, :boolean, :default => false
  end
end
