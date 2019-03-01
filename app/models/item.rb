class Item < ApplicationRecord
  belongs_to :feed, dependent: :destroy
  has_many :users, through: :subscriptions
end
