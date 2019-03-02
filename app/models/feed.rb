class Feed < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :users, through: :subscriptions
end
