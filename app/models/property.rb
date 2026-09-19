class Property < ApplicationRecord
  belongs_to :user
  has_many :images, dependent: :destroy
  has_many :reservations, dependent: :restrict_with_error

  validates :user,
            :home_type,
            :room_type,
            :accommodate,
            :bedrooms,
            :bathrooms,
            presence: true
  validates :price, numericality: { greater_than: 0 }, allow_nil: true
  validates :accommodate, :bedrooms, :bathrooms,
            numericality: { only_integer: true, greater_than: 0 }
  validates :name, :description, :address, presence: true, if: :is_active?
  validate :active_listing_must_be_complete

  def listing_complete?
    home_type.present? &&
      room_type.present? &&
      accommodate.present? &&
      bedrooms.present? &&
      bathrooms.present? &&
      name.present? &&
      description.present? &&
      price.present? &&
      price.to_i.positive? &&
      address.present?
  end

  private

  def active_listing_must_be_complete
    return unless is_active?
    return if listing_complete?

    errors.add(:is_active, "cannot be true until the listing is complete")
  end
end
