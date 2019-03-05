class ItemState < ApplicationRecord
  belongs_to :item
  belongs_to :user

  validates :item_id, uniqueness: { scope: :user_id}
end
