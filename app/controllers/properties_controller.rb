class PropertiesController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @property = Property.new
  end

  def create
    @property = current_user.properties.find(params[:id])
    if @property.save!(property_params)
      flash[:success] = "Success! New category created."
      redirect_to root_path
    else
      flash[:danger] = "This form contains errors."
      render 'new'
    end
  end

  private
  def property_params
    params.require(:property).permit(:home_type, :room_type, :accommodate, :bedrooms, :bathrooms)
  end
end
