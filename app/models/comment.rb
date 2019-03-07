class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :item

  validates :content, presence: true

  paginates_per 6
end
