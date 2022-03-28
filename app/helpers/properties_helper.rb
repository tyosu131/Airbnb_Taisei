module PropertiesHelper
  def is_complete?(property)
    #check it all the columns (textboxes) are not empty anymore
    #check all except amenities
    property.home_type.present? &&
    property.room_type.present? &&
    property.accommodate.present? &&
    property.bedrooms.present? &&
    property.bathrooms.present? &&
    property.name.present? &&
    property.description.present? &&
    property.price.present? &&
    property.address.present?
  end
end
