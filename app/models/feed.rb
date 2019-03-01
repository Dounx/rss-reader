class Feed < ApplicationRecord
  has_many :items
  has_many :users, through: :subscriptions
end
