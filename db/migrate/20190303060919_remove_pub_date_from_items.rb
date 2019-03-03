class RemovePubDateFromItems < ActiveRecord::Migration[5.2]
  def change
    remove_column :items, :pub_date
  end
end
