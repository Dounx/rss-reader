class ChangeDescriptionToTextType < ActiveRecord::Migration[5.2]
  def change
    change_column :feeds, :description, :text, :limit => 4294967295
    change_column :items, :description, :text, :limit => 4294967295
  end
end
