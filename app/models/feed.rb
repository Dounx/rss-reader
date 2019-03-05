class Feed < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :users, through: :subscriptions

  validates :link, :format => URI::regexp(%w(http https)), uniqueness: true
end
