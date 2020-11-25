class Community < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy
  has_many :memberships
  has_many :users, through: :memberships
  has_one_attached :photo

  include PgSearch::Model
  pg_search_scope :search_by_name,
    against: [ :name ],
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }
end
