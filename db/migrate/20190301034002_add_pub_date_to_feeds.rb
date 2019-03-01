class AddPubDateToFeeds < ActiveRecord::Migration[5.2]
  def change
    add_column :feeds, :pub_date, :datetime
  end
end
