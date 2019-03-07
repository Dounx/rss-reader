class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :subscriptions, dependent: :destroy
  has_many :item_states, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :feeds, through: :subscriptions
  has_many :items, through: :item_states
end
