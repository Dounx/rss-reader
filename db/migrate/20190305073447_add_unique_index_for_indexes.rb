class AddUniqueIndexForIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :subscriptions, [:user_id, :feed_id], unique: true, :length => 100
    add_index :item_states, [:user_id, :item_id], unique: true, :length => 100
  end
end
