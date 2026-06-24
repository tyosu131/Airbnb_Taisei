class PropertiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_property, except: [:new, :create, :index]

  def new
    @property = current_user.properties.build
  end

  def create
    @property = current_user.properties.new(property_params)

    if @property.save
      flash[:success] = "Success!"
      redirect_to listing_property_path(@property)
    else
      flash[:danger] = "This form contains errors."
      render 'new'
    end
  end

  def edit
  end

  def index
    @properties = current_user.properties
  end

  def show
  end

  def update
    if @property.update(property_params)
      flash[:success] = "Property Update"
      redirect_back(fallback_location: listing_property_path(@property))
    else
      render 'edit'
    end
  end

  def listing
  end

  def pricing
  end

  def description
  end

  def images
    @images = @property.images
  end

  def amenities
  end

  def location
  end

  private

  def property_params
    params.require(:property).permit(
      :home_type,
      :room_type,
      :accommodate,
      :bedrooms,
      :bathrooms,
      :price,
      :name,
      :description,
      :address,
      :has_tv,
      :has_kitchen,
      :has_internet,
      :has_heating,
      :has_air_condtion,
      :is_active
    )
  end

  def set_property
    @property = current_user.properties.find(params[:id])
  end
end
