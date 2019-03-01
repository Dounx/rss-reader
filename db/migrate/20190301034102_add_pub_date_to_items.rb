class AddPubDateToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :pub_date, :datetime
  end
end
