class Reservation < ApplicationRecord
  belongs_to :guest, class_name: "User", inverse_of: :reservations
  belongs_to :property

  validates :check_in, :check_out, presence: true
  validates :total_price, numericality: { only_integer: true, greater_than: 0 }
  validate :check_in_is_not_in_the_past
  validate :check_out_is_after_check_in
  validate :property_is_available
  validate :guest_is_not_the_host

  before_validation :calculate_total_price

  def nights
    return 0 unless check_in && check_out

    (check_out - check_in).to_i
  end

  private

  def calculate_total_price
    self.total_price = nights * property.price if property&.price && nights.positive?
  end

  def check_in_is_not_in_the_past
    errors.add(:check_in, "cannot be in the past") if check_in && check_in < Date.current
  end

  def check_out_is_after_check_in
    return unless check_in && check_out

    errors.add(:check_out, "must be after check-in") unless check_out > check_in
  end

  def property_is_available
    return unless property && check_in && check_out && check_out > check_in

    overlap = property.reservations
                      .where.not(id: id)
                      .where("check_in < ? AND check_out > ?", check_out, check_in)
                      .exists?
    errors.add(:base, "Property is already reserved for those dates") if overlap
  end

  def guest_is_not_the_host
    errors.add(:guest, "cannot reserve their own property") if property && guest == property.user
  end
end
