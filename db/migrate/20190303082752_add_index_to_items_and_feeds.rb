class AddIndexToItemsAndFeeds < ActiveRecord::Migration[5.2]
  def change
    add_index :feeds, :link, :length => 100
    add_index :items, :link, :length => 100
  end
end
