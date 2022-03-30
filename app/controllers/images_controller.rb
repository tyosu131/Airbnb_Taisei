class ImagesController < ApplicationController

  def create
    @property = Property.find(params[:property_id])
    params[:images].each do |image|
      @property.images.create(img: image)
    end
    redirect_back(fallback_location: request.referer, notice: "Property Update")
  end

  def destroy
    @property = Property.find(params[:property_id])
    @image = @property.images.find(params[:id])
    @image.destroy
    redirect_to property_images_path
  end
end
