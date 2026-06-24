class Image < ApplicationRecord
  belongs_to :property
  has_one_attached :img

  VALID_CONTENT_TYPES = %w[
    image/gif
    image/jpeg
    image/png
    image/webp
  ].freeze

  validates :property, presence: true
  validate :img_content_type

  private

  def img_content_type
    return unless img.attached?
    return if img.blob.content_type.in?(VALID_CONTENT_TYPES)

    errors.add(:img, "must be a GIF, JPEG, PNG, or WebP image")
  end
end
