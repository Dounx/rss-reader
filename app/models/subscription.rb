class Subscription < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :feed, dependent: :destroy
end
