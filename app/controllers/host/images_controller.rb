class Host::ImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_property

  def create
    if params[:images].blank?
      redirect_back(
        fallback_location: images_host_property_path(@property),
        alert: "Please select images."
      )
      return
    end

    params[:images].each do |image|
      @property.images.create(img: image)
    end

    redirect_back(
      fallback_location: images_host_property_path(@property),
      notice: "Property Update"
    )
  end

  def destroy
    @image = @property.images.find(params[:id])
    @image.destroy

    redirect_to images_host_property_path(@property), notice: "Image deleted"
  end

  private

  def set_property
    @property = current_user.properties.find(params[:property_id])
  end
end
