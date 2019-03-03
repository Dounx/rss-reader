class ChangePubDateName < ActiveRecord::Migration[5.2]
  def change
    rename_column :feeds, :pub_date, :modified_at
  end
end
