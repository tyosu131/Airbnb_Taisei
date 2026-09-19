class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: :destroy

  def index
    @reservations = Reservation.joins(:property)
                               .where(
                                 "reservations.guest_id = :user_id OR properties.user_id = :user_id",
                                 user_id: current_user.id
                               )
                               .includes(:guest, :property)
                               .order(check_in: :asc)
  end

  def create
    property = Property.where(is_active: true).find(params[:property_id])
    @reservation = property.reservations.build(reservation_params.merge(guest: current_user))

    property.with_lock do
      if @reservation.save
        redirect_to reservations_path, notice: "Reservation confirmed."
      else
        redirect_to property_path(property), alert: @reservation.errors.full_messages.to_sentence
      end
    end
  end

  def destroy
    @reservation.destroy
    redirect_to reservations_path, notice: "Reservation cancelled."
  end

  private

  def set_reservation
    @reservation = Reservation.joins(:property).where(
      "reservations.guest_id = :user_id OR properties.user_id = :user_id",
      user_id: current_user.id
    ).find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:check_in, :check_out)
  end
end
