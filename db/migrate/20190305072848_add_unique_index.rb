class AddUniqueIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :items, :link
    remove_index :feeds, :link
    add_index :items, :link, unique: true
    add_index :feeds, :link, unique: true
  end
end
