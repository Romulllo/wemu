class Community < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy
  has_many :memberships, dependent: :delete_all
  has_many :users, through: :memberships
  validates :photo, presence: true
  has_one_attached :photo, dependent: :destroy



  include PgSearch::Model
  pg_search_scope :search_by_name,
    against: [ :name ],
    using: {
      tsearch: { prefix: true }
    }
end
