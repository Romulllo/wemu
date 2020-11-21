class Community < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy
  has_many :memberships
  has_many :users, through: :memberships
  has_one_attached :photo
end
