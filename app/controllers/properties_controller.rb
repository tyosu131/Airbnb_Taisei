class PropertiesController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @property = current_user.properties.build
  end

  def create
    @property = current_user.properties.new(property_params)
    if @property.save
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
