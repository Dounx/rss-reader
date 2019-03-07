class Item < ApplicationRecord
  belongs_to :feed
  has_many :item_states, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :link, uniqueness: true
end
