class AddReferencesToItems < ActiveRecord::Migration[5.2]
  def change
    add_reference :items, :feed, foreign_key: true
  end
end
