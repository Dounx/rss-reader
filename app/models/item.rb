class Item < ApplicationRecord
  belongs_to :feed, dependent: :destroy
end
