class AddIndexToItemsAndFeeds < ActiveRecord::Migration[5.2]
  def change
    add_index :feeds, :link
    add_index :items, :link
  end
end
