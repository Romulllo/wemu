class Community < ApplicationRecord
  belongs_to :user
  has_many :messages
  has_many :memberships
  has_many :users, through: :memberships
end
