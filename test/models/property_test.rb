require "test_helper"

class PropertyTest < ActiveSupport::TestCase
  test "requires its host and basic property facts" do
    property = Property.new

    assert_not property.valid?
    assert_includes property.errors[:user], "must exist"
    assert property.errors[:home_type].any?
    assert property.errors[:accommodate].any?
  end

  test "allows an incomplete draft but refuses to publish it" do
    property = Property.new(
      user: create_user,
      home_type: "House",
      room_type: "Entire",
      accommodate: 2,
      bedrooms: 1,
      bathrooms: 1
    )

    assert property.valid?
    property.is_active = true
    assert_not property.valid?
    assert_includes property.errors[:is_active], "cannot be true until the listing is complete"
  end

  test "requires positive capacity and price values" do
    property = create_property(user: create_user)
    property.assign_attributes(accommodate: 0, bedrooms: -1, bathrooms: 0, price: 0)

    assert_not property.valid?
    %i[accommodate bedrooms bathrooms price].each do |attribute|
      assert property.errors[attribute].any?, "expected an error on #{attribute}"
    end
  end
end
