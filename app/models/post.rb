class Post < ApplicationRecord
    belongs_to :user
    has_many_attached :images

    has_many :likes, dependent: :destroy
    has_many :comments, dependent: :destroy

    scope :recent, -> { order(created_at: :desc) }

    scope :created_within_24h, -> { where(created_at: 24.hours.ago..Time.current) }

    scope :popular, -> {
      joins(:likes)
        .group("posts.id")
        .order("COUNT(likes.id) DESC")
    }
  validates :content, :images, presence: true
end
