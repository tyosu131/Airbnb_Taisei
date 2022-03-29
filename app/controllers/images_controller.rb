class ImagesController < ApplicationController

  def create
    @property = Property.find(params[:property_id])
    params[:images].each do |image|
      @property.images.create(img: image)
    end
  end

  def destroy

  end
end
