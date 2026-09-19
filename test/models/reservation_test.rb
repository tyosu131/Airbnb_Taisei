require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  setup do
    @host = create_user(email: "host@example.com")
    @guest = create_user
    @property = create_property(user: @host)
  end

  test "derives total price from the current nightly rate and stay length" do
    reservation = @property.reservations.create!(
      guest: @guest,
      check_in: Date.current + 2.days,
      check_out: Date.current + 5.days
    )

    assert_equal 3, reservation.nights
    assert_equal 360, reservation.total_price
  end

  test "rejects past and reversed dates" do
    reservation = @property.reservations.build(
      guest: @guest,
      check_in: Date.current - 1.day,
      check_out: Date.current - 2.days
    )

    assert_not reservation.valid?
    assert reservation.errors[:check_in].any?
    assert reservation.errors[:check_out].any?
  end

  test "rejects overlapping stays but allows adjacent stays" do
    @property.reservations.create!(
      guest: @guest,
      check_in: Date.current + 5.days,
      check_out: Date.current + 8.days
    )

    overlap = @property.reservations.build(
      guest: create_user(email: "second@example.com"),
      check_in: Date.current + 7.days,
      check_out: Date.current + 10.days
    )
    adjacent = @property.reservations.build(
      guest: create_user(email: "third@example.com"),
      check_in: Date.current + 8.days,
      check_out: Date.current + 10.days
    )

    assert_not overlap.valid?
    assert_includes overlap.errors[:base], "Property is already reserved for those dates"
    assert adjacent.valid?
  end

  test "host cannot reserve their own listing" do
    reservation = @property.reservations.build(
      guest: @host,
      check_in: Date.current + 1.day,
      check_out: Date.current + 2.days
    )

    assert_not reservation.valid?
    assert reservation.errors[:guest].any?
  end
end
