class CreateItemStates < ActiveRecord::Migration[5.2]
  def change
    create_table :item_states do |t|
      t.references :item, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
