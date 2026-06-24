class PropertiesController < ApplicationController
  before_action :set_property, only: [:show]

  def index
    @properties = Property.where(is_active: true)
  end

  def show
  end

  private

  def set_property
    @property = Property.where(is_active: true).find(params[:id])
  end
end
