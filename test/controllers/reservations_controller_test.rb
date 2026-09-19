require "test_helper"

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @host = create_user(email: "host@example.com")
    @guest = create_user
    @property = create_property(user: @host)
  end

  test "requires authentication to reserve" do
    post property_reservations_path(@property), params: reservation_dates

    assert_redirected_to new_user_session_path
    assert_equal 0, Reservation.count
  end

  test "creates a priced reservation for the signed-in guest" do
    sign_in @guest

    assert_difference("Reservation.count", 1) do
      post property_reservations_path(@property), params: reservation_dates
    end

    reservation = Reservation.last
    assert_equal @guest, reservation.guest
    assert_equal 240, reservation.total_price
    assert_redirected_to reservations_path
  end

  test "does not trust a submitted total price or guest id" do
    other = create_user(email: "other@example.com")
    sign_in @guest
    parameters = reservation_dates
    parameters[:reservation].merge!(total_price: 1, guest_id: other.id)

    post property_reservations_path(@property), params: parameters

    reservation = Reservation.last
    assert_equal @guest, reservation.guest
    assert_equal 240, reservation.total_price
  end

  test "unrelated users cannot cancel a reservation" do
    reservation = @property.reservations.create!(
      guest: @guest,
      check_in: Date.current + 2.days,
      check_out: Date.current + 4.days
    )
    sign_in create_user(email: "stranger@example.com")

    reservation_count = Reservation.count

    assert_raises(ActiveRecord::RecordNotFound) { delete reservation_path(reservation) }
    assert_equal reservation_count, Reservation.count
    assert Reservation.exists?(reservation.id)
  end

  private

  def reservation_dates
    {
      reservation: {
        check_in: Date.current + 2.days,
        check_out: Date.current + 4.days
      }
    }
  end
end
